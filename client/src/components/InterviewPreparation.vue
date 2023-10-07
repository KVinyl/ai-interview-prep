<template>
  <div class="container w-1/2 mx-auto">
    <div v-if="currentQuestion">
      <div
        class="flex flex-col items-center space-y-4 px-4 py-4 mt-8 mb-4 rounded-lg bg-gray-200 border border-gray-400 drop-shadow-lg">
        <QuestionSection :question="currentQuestion" />
        <textarea ref="textarea" v-model="answers[index]" class="w-5/6 h-24 rounded-lg border border-gray-400 p-4"
          placeholder="Enter your answer" :disabled="!isUnanswered"></textarea>
        <RectangleButton v-show="isUnanswered" :disabled="isSubmitButtonDisabled" @click="submitAnswer"
          class="bg-green-500 hover:bg-green-600">Submit</RectangleButton>
        <RectangleButton v-show="isGrading" class="invisible" :disabled="true">Loading</RectangleButton>
        <RectangleButton v-show="isGraded" @click="resetQuestion" class="bg-sky-500 hover:bg-sky-600">Try Again
        </RectangleButton>
      </div>

      <div class="flex flex-row justify-center items-center space-x-6 m-4">
        <CircleButton :disabled="isPrevButtonDisabled" @click="previousQuestion"
          class="bg-sky-500 hover:bg-sky-600 text-2xl">🡨</CircleButton>
        <span class="text-xl">{{ questionNumber }} / {{ questions.length }}</span>
        <CircleButton :disabled="isGrading" @click="nextQuestion" class="bg-sky-500 hover:bg-sky-600 text-2xl">🡪
        </CircleButton>
      </div>

      <AIFeedbackCard v-show="currentFeedback || isGrading" :feedback="currentFeedback" :isGrading="isGrading" />
    </div>

    <EndOfSessionCard v-else-if="questions.length" @goToLastQuestion="goToLastQuestion"
      @restartSession="restartSession" />
    <MessageCard v-else message="This deck currently has zero cards." />

    <DeckTable :questions="questions" :name="name" :currentIndex="index" @goToIndex="goToIndex" />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount, watch } from 'vue'
import type { Ref } from 'vue'

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
const questionNumber = computed(() => index.value + 1)

const currentQuestion = computed(() => props.questions[index.value])

const answers: Ref<string[]> = ref(Array(props.questions.length).fill(""))
const currentAnswer = computed(() => answers.value[index.value])

const submittedAnswers: Ref<string[]> = ref(Array(props.questions.length).fill(""))
const currentSubmittedAnswer = computed(() => submittedAnswers.value[index.value])

const feedbacks: Ref<string[]> = ref(Array(props.questions.length).fill(""))
const currentFeedback = computed(() => feedbacks.value[index.value])

enum QuestionStatus {
  Unanswered,
  Grading,
  Graded
}

const statuses: Ref<QuestionStatus[]> = ref(Array(props.questions.length).fill(QuestionStatus.Unanswered))
const status = computed(() => statuses.value[index.value])

const isUnanswered = computed(() => status.value === QuestionStatus.Unanswered)
const isGrading = computed(() => status.value === QuestionStatus.Grading)
const isGraded = computed(() => status.value === QuestionStatus.Graded)

const isPrevButtonDisabled = computed(() => index.value === 0 || isGrading.value)
const isSubmitButtonDisabled = computed(() => currentAnswer.value.trim() === currentSubmittedAnswer.value.trim() || !currentAnswer.value.trim())

const hubUrl = `${import.meta.env.VITE_REMOTE_API}/openAIHub`
const connection = new HubConnectionBuilder()
  .withUrl(hubUrl)
  .withAutomaticReconnect()
  .build()

const textarea = ref<HTMLInputElement | null>(null)

watch(index, () => {
  textarea.value?.focus()
})

onMounted(() => {
  connection.start()
    .then(() => console.log('SignalR connected'))
    .catch(error => console.error(`Error connecting to SignalR: ${error}`))

  textarea.value?.focus()
})

onBeforeUnmount(() => {
  if (connection) {
    connection.stop()
  }
})

connection.on('ReceiveFeedback', (response: string) => {
  if (response) {
    feedbacks.value[index.value] += response
  }
})

function resetQuestion() {
  statuses.value[index.value] = QuestionStatus.Unanswered
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
  submittedAnswers.value[index.value] = currentAnswer.value
  feedbacks.value[index.value] = ""
  statuses.value[index.value] = QuestionStatus.Grading

  const prompt = `Suppose I'm seeking a junior software developer position. 
  I'm being asked this question in an interview: ${currentQuestion.value}
  This is my answer: ${currentAnswer.value}
  Give me feedback of my answer to that interview question.`

  connection.invoke('SendPrompt', prompt)
    .then(() => console.log('Prompt sent'))
    .catch(error => {
      console.error(error)
      feedbacks.value[index.value] = error
    })
    .finally(() => statuses.value[index.value] = QuestionStatus.Graded)
}
</script>