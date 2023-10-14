<template>
  <div class="container w-1/2 mx-auto">
    <div v-if="isInSession">
      <div
        class="flex flex-col items-center space-y-4 px-4 py-4 mt-8 mb-4 rounded-lg bg-gray-200 border border-gray-400 drop-shadow-lg">
        <QuestionSection :question="currentQuestion" />
        <textarea ref="textarea" v-model="questionsData[index].answer"
          class="w-5/6 h-24 rounded-lg border border-gray-400 p-4" placeholder="Enter your answer"
          :disabled="!isUnanswered"></textarea>
        <RectangleButton v-show="isUnanswered" :disabled="isSubmitButtonDisabled" @click="submitAnswer"
          class="bg-green-500 hover:bg-green-600">Submit</RectangleButton>
        <RectangleButton v-show="isGrading" class="invisible" :disabled="true">Loading</RectangleButton>
        <RectangleButton v-show="isGraded" @click="resetQuestion" class="bg-sky-500 hover:bg-sky-600">Try Again
        </RectangleButton>
      </div>

      <div class="flex flex-row justify-center items-center space-x-6 m-4">
        <CircleButton :disabled="isPrevButtonDisabled" @click="previousQuestion"
          class="bg-sky-500 hover:bg-sky-600 text-2xl">🡨</CircleButton>
        <span class="text-xl">{{ currentQuestionNumber }} / {{ questions.length }}</span>
        <CircleButton :disabled="isGrading" @click="nextQuestion" class="bg-sky-500 hover:bg-sky-600 text-2xl">🡪
        </CircleButton>
      </div>

      <AIFeedbackCard v-show="currentFeedback || isGrading" :feedback="currentFeedback" :isGrading="isGrading" />
    </div>

    <EndOfSessionCard v-else-if="questions.length" @goToLastQuestion="goToLastQuestion"
      @restartSession="restartSession" />
    <MessageCard v-else message="This deck currently has zero cards." />

    <DeckTable v-if="questions.length" :questions="questions" :name="name" :currentIndex="index" @goToIndex="goToIndex" />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount, watch } from 'vue'
import type { QuestionData } from '../types/QuestionData'

import AIFeedbackCard from './AIFeedbackCard.vue'
import DeckTable from './DeckTable.vue'
import MessageCard from './MessageCard.vue'
import EndOfSessionCard from './EndOfSessionCard.vue'
import QuestionSection from './QuestionSection.vue'

import CircleButton from './CircleButton.vue'
import RectangleButton from './RectangleButton.vue'

import { HubConnectionBuilder } from '@microsoft/signalr'

const props = defineProps<{
  name?: string,
  questions: string[]
}>()

const index = ref(0)
const questionsData = ref(props.questions.map((question, index) => ({
  number: index + 1,
  question,
  answer: "",
  feedback: "",
  status: "Unanswered"
} as QuestionData)))

const currentQuestionNumber = computed(() => questionsData.value[index.value]?.number)
const currentQuestion = computed(() => questionsData.value[index.value]?.question)
const currentAnswer = computed(() => questionsData.value[index.value]?.answer)
const currentFeedback = computed(() => questionsData.value[index.value]?.feedback)
const currentStatus = computed(() => questionsData.value[index.value]?.status)

const isUnanswered = computed(() => currentStatus.value === "Unanswered")
const isGrading = computed(() => currentStatus.value === "Grading")
const isGraded = computed(() => currentStatus.value === "Graded")

const isInSession = computed(() => 0 <= index.value && index.value < questionsData.value.length)
const isPrevButtonDisabled = computed(() => index.value === 0 || isGrading.value)
const isSubmitButtonDisabled = computed(() => !currentAnswer.value.trim())

const hubUrl = `${import.meta.env.VITE_REMOTE_API}/openAIHub`
const connection = new HubConnectionBuilder()
  .withUrl(hubUrl)
  .withAutomaticReconnect()
  .build()

const textarea = ref<HTMLInputElement | null>(null)

watch(index, () => {
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
    questionsData.value[index.value].feedback += response
  }
})

function resetQuestion() {
  questionsData.value[index.value].status = "Unanswered"
}

function previousQuestion() {
  index.value--
}

function nextQuestion() {
  index.value++
}

function goToIndex(nextIndex: number) {
  index.value = nextIndex
}

function restartSession() {
  goToIndex(0)
}

function goToLastQuestion() {
  goToIndex(props.questions.length - 1)
}

function submitAnswer() {
  questionsData.value[index.value].feedback = ""
  questionsData.value[index.value].status = "Grading"

  const prompt = `Suppose I'm seeking a junior software developer position. 
  I'm being asked this question in an interview: ${currentQuestion.value}
  This is my answer: ${currentAnswer.value}
  Give me feedback of my answer to that interview question.`

  connection.invoke('SendPrompt', prompt)
    .then(() => console.log('Prompt sent'))
    .catch(error => {
      console.error(error)
      questionsData.value[index.value].feedback = error
    })
    .finally(() => questionsData.value[index.value].status = "Graded")
}
</script>