<template>
  <div class="container w-1/2 mx-auto">
    <div v-if="isInSession">
      <div
        class="flex flex-col items-center space-y-4 px-4 py-4 mt-8 rounded-t-lg bg-gray-200 border border-gray-400 drop-shadow-lg">
        <QuestionSection :question="currentQuestion!" />
        <textarea ref="textarea" v-model="questionsData[currentIndex].answer"
          class="w-5/6 h-24 rounded-lg border border-gray-400 p-4" placeholder="Enter your answer"
          :disabled="!isUnanswered"></textarea>
        <RectangleButton v-show="isUnanswered" :disabled="isSubmitButtonDisabled" @click="submitAnswer"
          class="bg-green-500 hover:bg-green-600">Submit</RectangleButton>
        <RectangleButton v-show="isGrading" class="invisible" :disabled="true">Loading</RectangleButton>
        <RectangleButton v-show="isGraded" @click="resetQuestion" class="bg-sky-500 hover:bg-sky-600">Try Again
        </RectangleButton>
      </div>

      <NavigationBar :index="currentIndex" :status="currentStatus!" :isShuffled="isShuffled" @toggleShuffle="toggleShuffle"
        @previousQuestion="previousQuestion" @nextQuestion="nextQuestion">{{
          currentQuestionNumber }} / {{ questions.length }}</NavigationBar>

      <AIFeedbackCard v-show="currentFeedback || isGrading" :feedback="currentFeedback!" :isGrading="isGrading" />
    </div>

    <EndOfSessionCard v-else-if="questions.length" @goToLastQuestion="goToLastQuestion"
      @restartSession="restartSession" />
    <MessageCard v-else message="This deck currently has zero cards." />

    <DeckTable v-if="questionsData.length" :questionsData="questionsData" :name="name" :currentIndex="currentIndex"
      :isDisabled="isGrading" @goToIndex="goToIndex" />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount, watch } from 'vue'
import type { QuestionData } from '../types/QuestionData'

import AIFeedbackCard from './AIFeedbackCard.vue'
import DeckTable from './DeckTable.vue'
import EndOfSessionCard from './EndOfSessionCard.vue'
import MessageCard from './MessageCard.vue'
import NavigationBar from './NavigationBar.vue'
import QuestionSection from './QuestionSection.vue'
import RectangleButton from './RectangleButton.vue'

import { HubConnectionBuilder } from '@microsoft/signalr'

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
const isGrading = computed(() => currentStatus.value === "Grading")
const isGraded = computed(() => currentStatus.value === "Graded")

const isInSession = computed(() => 0 <= currentIndex.value && currentIndex.value < questionsData.value.length)
const isSubmitButtonDisabled = computed(() => !currentAnswer.value?.trim())

const hubUrl = `${import.meta.env.VITE_REMOTE_API}/openAIHub`
const connection = new HubConnectionBuilder()
  .withUrl(hubUrl)
  .withAutomaticReconnect()
  .build()

const textarea = ref<HTMLInputElement | null>(null)

watch(currentIndex, () => {
  textarea.value?.focus()
})

function startSignalRConnection() {
  connection.start()
    .then(() => console.log('SignalR connected'))
    .catch(error => console.error(`Error connecting to SignalR: ${error}`))
}

onMounted(() => {
  startSignalRConnection()
  textarea.value?.focus()
})

onBeforeUnmount(() => {
  if (connection) {
    connection.stop()
  }
})

connection.on('ReceiveFeedback', (response: string) => {
  if (response !== null) {
    questionsData.value[currentIndex.value].feedback += response
  }
})

function goToIndex(nextIndex: number) {
  currentIndex.value = nextIndex
}

const isShuffled = ref(false)

const nextShuffledIndices = computed<number[]>(() =>
  questionsData.value
    .map((data, index) => (data.status !== "Graded" ? index : -1))
    .filter(index => index !== -1 && index !== currentIndex.value)
)

function getNextShuffledIndex() {
  if (nextShuffledIndices.value.length > 0) {
    const randomIndex = Math.floor(Math.random() * nextShuffledIndices.value.length)
    return nextShuffledIndices.value[randomIndex]
  }
  return questionsData.value.length
}

const prevShuffleHistory: number[] = []
const nextShuffleHistory: number[] = []

function resetShuffleHistory() {
  prevShuffleHistory.length = 0
  nextShuffleHistory.length = 0
}

function toggleShuffle() {
  isShuffled.value = !isShuffled.value
}

function previousQuestion() {
  if (isShuffled.value) {
    if (prevShuffleHistory.length > 0) {
      nextShuffleHistory.unshift(currentIndex.value)
      const prevIndex = prevShuffleHistory.pop()!
      goToIndex(prevIndex)
    }
  } else {
    goToIndex(currentIndex.value - 1)
  }
}

function nextQuestion() {
  if (isShuffled.value) {
    prevShuffleHistory.push(currentIndex.value)
    const nextIndex = nextShuffleHistory.length > 0 ? nextShuffleHistory.shift()! : getNextShuffledIndex()
    goToIndex(nextIndex)
  } else {
    goToIndex(currentIndex.value + 1)
  }
}

function resetQuestion() {
  questionsData.value[currentIndex.value].status = "Unanswered"
}

function restartSession() {
  goToIndex(0)
}

function goToLastQuestion() {
  goToIndex(props.questions.length - 1)
}

function submitAnswer() {
  questionsData.value[currentIndex.value].feedback = ""
  questionsData.value[currentIndex.value].status = "Grading"

  const prompt = `Suppose I'm seeking a junior software developer position. 
  I'm being asked this question in an interview: ${currentQuestion.value}
  This is my answer: ${currentAnswer.value}
  Give me feedback of my answer to that interview question.`

  connection.invoke('SendPrompt', prompt)
    .then(() => console.log('Prompt sent'))
    .catch(error => {
      console.error(error)
      questionsData.value[currentIndex.value].feedback = error
    })
    .finally(() => questionsData.value[currentIndex.value].status = "Graded")
}
</script>