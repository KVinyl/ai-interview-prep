<template>
  <div class="container w-1/2 mx-auto">
    <div v-if="isInSession">
      <div
        class="flex flex-col items-center space-y-4 px-4 py-4 mt-8 rounded-t-lg bg-gray-200 border border-gray-400 drop-shadow-lg">
        <QuestionSection :question="currentQuestion!" :class="{ 'text-red-800': isError }" />
        <textarea ref="textarea" v-model="questionsData[currentIndex].answer"
          class="w-5/6 h-24 rounded-lg border border-gray-400 px-4 py-2" placeholder="Enter your answer"
          :disabled="!isUnanswered"></textarea>
        <RectangleButton v-show="isUnanswered" :disabled="isSubmitButtonDisabled" @click="submitAnswer"
          class="bg-green-500 hover:bg-green-600">Submit</RectangleButton>
        <RectangleButton v-show="isProcessing" class="invisible" :disabled="true">Loading</RectangleButton>
        <RectangleButton v-show="isGraded" @click="resetQuestion" class="bg-sky-500 hover:bg-sky-600">Try Again
        </RectangleButton>
      </div>

      <NavigationBar :class="{ 'rounded-b-lg': !showFeedbackCard }" :index="currentIndex"
        :shuffleStartIndex="shuffleStartIndex" :status="currentStatus!" :isShuffled="isShuffled"
        @toggleShuffle="toggleShuffle" @previousQuestion="previousQuestion" @nextQuestion="nextQuestion">{{
          currentQuestionNumber }} / {{ questionsData.length }}</NavigationBar>

      <AIFeedbackCard v-show="showFeedbackCard" :feedback="currentFeedback!" :isGrading="isGrading" />
    </div>

    <EndOfSessionCard v-else-if="questions.length" @goToLastQuestion="goToLastQuestion"
      @restartSession="restartSession" />
    <MessageCard v-else message="This deck currently has zero cards." />

    <DeckTable v-if="questionsData.length" :questionsData="questionsData" :name="name" :currentIndex="currentIndex"
      :isDisabled="isProcessing" @jumpToIndex="jumpToIndex" @clickMagicAdd="magicAddQuestion" />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount, watch } from 'vue'
import type { QuestionData } from '../types/QuestionData'
import signalRService from '../services/SignalRService'
import AIFeedbackCard from './AIFeedbackCard.vue'
import DeckTable from './DeckTable.vue'
import EndOfSessionCard from './EndOfSessionCard.vue'
import MessageCard from './MessageCard.vue'
import NavigationBar from './NavigationBar.vue'
import QuestionSection from './QuestionSection.vue'
import RectangleButton from './RectangleButton.vue'

const props = defineProps<{
  name?: string,
  questions: string[]
}>()

const currentIndex = ref(0)
const questionsData = ref<QuestionData[]>(props.questions.map((question, index) => ({
  number: index + 1,
  question,
  answer: "",
  feedback: "",
  status: "Unanswered"
})))

const currentQuestionData = computed<QuestionData | undefined>(() => questionsData.value[currentIndex.value])

const currentQuestionNumber = computed(() => currentQuestionData.value?.number)
const currentQuestion = computed(() => currentQuestionData.value?.question)
const currentAnswer = computed(() => currentQuestionData.value?.answer)
const currentFeedback = computed(() => currentQuestionData.value?.feedback)
const currentStatus = computed(() => currentQuestionData.value?.status)

const isUnanswered = computed(() => currentStatus.value === "Unanswered")
const isProcessing = computed(() => currentStatus.value === "Processing")
const isGraded = computed(() => currentStatus.value === "Graded")
const isError = computed(() => currentStatus.value === "Error")
const isMagicAdding = ref(false)
const isGrading = computed(() => isProcessing && !isMagicAdding)

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

function resetQuestion() {
  questionsData.value[currentIndex.value].status = "Unanswered"
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
  if (response !== null) {
    if (isMagicAdding.value) {
      questionsData.value[currentIndex.value].question += response
    } else {
      questionsData.value[currentIndex.value].feedback += response
    }
  }
})

function submitAnswer() {
  questionsData.value[currentIndex.value].feedback = ""
  questionsData.value[currentIndex.value].status = "Processing"

  const prompt = `Suppose I'm seeking a junior software developer position. 
  I'm being asked this question in an interview: ${currentQuestion.value}
  This is my answer: ${currentAnswer.value}
  Give me feedback of my answer to that interview question.`

  signalRService.invoke('SendPrompt', prompt)
    .then(() => console.log('Prompt sent'))
    .catch(error => {
      console.error(error)
      questionsData.value[currentIndex.value].feedback = error
    })
    .finally(() => questionsData.value[currentIndex.value].status = "Graded")
}

function magicAddQuestion() {
  isMagicAdding.value = true

  const questions = questionsData.value.map(data => data.question).reverse()
  const prompt = `Suppose I'm seeking a junior software developer position.
  Generate a potential question that could be asked in an interview.
  Make sure that potential question is different from the following questions: 
  """
  ${questions.join("\n")}
  """`

  let lastIndex = questionsData.value.length - 1
  const nextQuestionData: QuestionData = {
    number: questionsData.value.length + 1,
    question: "",
    answer: "",
    feedback: "",
    status: "Processing"
  }

  if (questionsData.value[lastIndex].status === "Error") {
    questionsData.value[lastIndex] = { ...nextQuestionData, number: questionsData.value[lastIndex].number }
  } else {
    questionsData.value.push(nextQuestionData)
    lastIndex = questionsData.value.length - 1
  }

  jumpToIndex(lastIndex)

  signalRService.invoke('SendPrompt', prompt)
    .then(() => questionsData.value[lastIndex].status = "Unanswered")
    .catch(error => {
      console.error(error)
      questionsData.value[lastIndex].question = "Error generating question. Please try again."
      questionsData.value[lastIndex].status = "Error"
    })
    .finally(() => {
      isMagicAdding.value = false
    })
}
</script>