<template>
  <div class="container sm:w-3/5 max-w-4xl mx-auto">
    <div v-if="isInSession">
      <div
        class="flex flex-col items-center space-y-4 px-4 py-4 sm:mt-8 rounded-t-lg bg-gray-200 border border-gray-400 drop-shadow-lg">
        <div class="px-4 py-2"> {{ currentQuestion }}</div>
        <textarea ref="textarea" v-model="questionsData[currentIndex].answer"
          class="w-5/6 h-24 rounded-lg border border-gray-400 px-4 py-2 disabled:bg-cobalt-200"
          placeholder="Enter your answer" :disabled="!isUnanswered"></textarea>
        <RectangleButton v-show="isUnanswered" :disabled="isSubmitButtonDisabled" @click="submitAnswer"
          class="bg-green-500 hover:bg-green-600 ">Submit</RectangleButton>
        <RectangleButton v-show="isGrading" class="invisible" :disabled="true">Loading</RectangleButton>
        <RectangleButton v-show="isGraded || isError" @click="resetQuestion" class="bg-sky-400 hover:bg-sky-600">Try Again
        </RectangleButton>
      </div>

      <NavigationBar :class="{ 'rounded-b-lg': !showFeedbackCard && !isError }" :index="currentIndex"
        :shuffleStartIndex="shuffleStartIndex" :status="currentStatus!" :isShuffled="isShuffled"
        @toggleShuffle="toggleShuffle" @previousQuestion="previousQuestion" @nextQuestion="nextQuestion"><span
          class="text-xl font-medium">{{
            currentQuestionNumber }} / {{ questionsData.length }}</span></NavigationBar>

      <ErrorMessageCard v-show="isError" :class="{ 'rounded-b-lg drop-shadow-lg': !showFeedbackCard }"
        message="Error grading your answer. Please try again." />
      <AIFeedbackCard v-show="showFeedbackCard" :questionData="currentQuestionData!" />

    </div>

    <EndOfSessionCard v-else-if="questionsData.length" @goToLastQuestion="goToLastQuestion"
      @restartSession="restartSession" />
    <ErrorMessageCard v-else message="This deck currently has zero cards." />

    <AddQuestionModal :show="showAddQuestionModal" @cancel="closeAddQuestionModal" @submit="addQuestion">
    </AddQuestionModal>

    <DeckTable v-if="questionsData.length" :questionsData="questionsData" :name="name" :currentIndex="currentIndex"
      :isDisabled="isGrading" @jumpToIndex="jumpToIndex" @clickAddQuestion="openAddQuestionModal" />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount, watch } from 'vue'
import type { QuestionData } from '@/types/QuestionData'
import type { QuestionStatus } from '@/types/QuestionStatus'
import signalRService from '@/services/SignalRService'
import AddQuestionModal from './AddQuestionModal.vue'
import AIFeedbackCard from './AIFeedbackCard.vue'
import DeckTable from './DeckTable.vue'
import EndOfSessionCard from './EndOfSessionCard.vue'
import ErrorMessageCard from './ErrorMessageCard.vue'
import NavigationBar from './NavigationBar.vue'
import RectangleButton from './RectangleButton.vue'


const props = defineProps<{
  name?: string,
  questionsData: QuestionData[]
}>()

const currentIndex = ref(0)
const questionsData = ref(props.questionsData)

const currentQuestionData = computed<QuestionData | undefined>(() => questionsData.value[currentIndex.value])

const currentQuestionNumber = computed(() => currentQuestionData.value?.number)
const currentQuestion = computed(() => currentQuestionData.value?.question)
const currentAnswer = computed(() => currentQuestionData.value?.answer)
const currentFeedback = computed(() => currentQuestionData.value?.feedback)
const currentStatus = computed(() => currentQuestionData.value?.status)

const isUnanswered = computed(() => currentStatus.value === "Unanswered")
const isGrading = computed(() => currentStatus.value === "Grading")
const isGraded = computed(() => currentStatus.value === "Graded")
const isError = computed(() => currentStatus.value === "Error")

const isInSession = computed(() => 0 <= currentIndex.value && currentIndex.value < questionsData.value.length)
const isSubmitButtonDisabled = computed(() => !currentAnswer.value?.trim())

function goToIndex(nextIndex: number) {
  currentIndex.value = nextIndex
}

const isShuffled = ref(false)

const nextShuffledIndices = computed<number[]>(() =>
  questionsData.value
    .map((data, index) => (data.status !== "Graded" ? index : -1))
    .filter(index => ![-1, currentIndex.value, ...prevShuffleHistory.value].includes(index))
)

function getNextShuffledIndex() {
  if (nextShuffledIndices.value.length > 0) {
    const randomIndex = Math.floor(Math.random() * nextShuffledIndices.value.length)
    return nextShuffledIndices.value[randomIndex]
  }
  return questionsData.value.length
}

const shuffleStartIndex = ref(-1)
const prevShuffleHistory = ref<number[]>([])
const nextShuffleHistory = ref<number[]>([])

function resetShuffleHistory() {
  shuffleStartIndex.value = isShuffled.value ? currentIndex.value : -1
  prevShuffleHistory.value = []
  nextShuffleHistory.value = []
}

function jumpToIndex(nextIndex: number) {
  goToIndex(nextIndex)
  resetShuffleHistory()
}

function toggleShuffle() {
  isShuffled.value = !isShuffled.value
  resetShuffleHistory()
}

function previousQuestion() {
  if (isShuffled.value) {
    if (prevShuffleHistory.value.length > 0) {
      nextShuffleHistory.value.unshift(currentIndex.value)
      const prevIndex = prevShuffleHistory.value.pop()!
      goToIndex(prevIndex)
    }
  } else {
    goToIndex(currentIndex.value - 1)
  }
}

function nextQuestion() {
  if (isShuffled.value) {
    prevShuffleHistory.value.push(currentIndex.value)
    const nextIndex = nextShuffleHistory.value.length > 0 ? nextShuffleHistory.value.shift()! : getNextShuffledIndex()
    goToIndex(nextIndex)
  } else {
    goToIndex(currentIndex.value + 1)
  }
}

function saveQuestionsDataToLocalStorage() {
  localStorage.setItem("questionsData", JSON.stringify(questionsData.value))
}

function setCurrentStatus(newStatus: QuestionStatus) {
  questionsData.value[currentIndex.value].status = newStatus
  saveQuestionsDataToLocalStorage()
}

function resetFeedback() {
  questionsData.value[currentIndex.value].feedback = ""
}

function resetQuestion() {
  if (isError.value) {
    resetFeedback()
  }
  setCurrentStatus("Unanswered")
}

function restartSession() {
  if (isShuffled.value) {
    const randomIndex = Math.floor(Math.random() * questionsData.value.length)
    jumpToIndex(randomIndex)
  } else {
    goToIndex(0)
  }
}

function goToLastQuestion() {
  if (isShuffled.value && prevShuffleHistory.value.length > 0) {
    nextShuffleHistory.value.unshift(currentIndex.value)
    const prevIndex = prevShuffleHistory.value.pop()!
    goToIndex(prevIndex)
  } else {
    goToIndex(questionsData.value.length - 1)
  }
}

const showFeedbackCard = computed(() => currentFeedback.value || isGrading.value)

const textarea = ref<HTMLInputElement | null>(null)

watch(currentIndex, () => {
  textarea.value?.focus()
})

onMounted(() => {
  signalRService.startSignalRConnection()
  textarea.value?.focus()
})

onBeforeUnmount(() => {
  signalRService.stopSignalRConnection()
})

signalRService.on('ReceiveFeedback', response => {
  if (isGrading.value && response !== null) {
    questionsData.value[currentIndex.value].feedback += response
  }
})

function submitAnswer() {
  resetFeedback()
  setCurrentStatus("Grading")

  const prompt = `Suppose I'm seeking a junior software developer position. 
  I'm being asked this question in an interview: ${currentQuestion.value}
  This is my answer: ${currentAnswer.value}
  Give me feedback of my answer to that interview question.`

  signalRService.invoke('SendPrompt', prompt)
    .then(() => setCurrentStatus("Graded"))
    .catch(error => {
      console.error(error)
      setCurrentStatus("Error")
    })
    .finally(() => saveQuestionsDataToLocalStorage())
}

const showAddQuestionModal = ref(false)

function openAddQuestionModal() {
  showAddQuestionModal.value = true
}

function closeAddQuestionModal() {
  showAddQuestionModal.value = false
}

function addQuestion(newQuestion: string) {
  const nextQuestionData: QuestionData = {
    number: questionsData.value.length + 1,
    question: newQuestion,
    answer: "",
    feedback: "",
    status: "Unanswered"
  }

  questionsData.value.push(nextQuestionData)
  jumpToIndex(questionsData.value.length - 1)

  saveQuestionsDataToLocalStorage()
  closeAddQuestionModal()
}
</script>