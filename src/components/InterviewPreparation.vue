<template>
  <div class="container w-1/2 mx-auto">
    <div v-if="currentQuestion">
      <div class="flex flex-col items-center space-y-4 px-4 py-4 mt-16 mb-4 bg-gray-200 border border-gray-400 ">
        <QuestionSection :question="currentQuestion" />
        <textarea ref="textarea" v-model="typedAnswer" class="w-5/6 h-32 border border-gray-400 p-4"
          placeholder="Enter your answer" :disabled="!isUnanswered"></textarea>
        <RectangleButton v-show="isUnanswered" :disabled="isTypedAnswerEmpty" @click="submitAnswer"
          hoverColor="bg-green-500">Submit
        </RectangleButton>
        <RectangleButton v-show="isGrading" class="invisible" :disabled="true">Loading</RectangleButton>
        <RectangleButton v-show="isGraded" @click="resetQuestion">Try Again
        </RectangleButton>
      </div>

      <div class="flex flex-row justify-center items-center space-x-4 m-4">
        <RectangleButton :disabled="isPrevButtonDisabled" @click="previousQuestion">←</RectangleButton>
        <p>{{ questionNumber }} / {{ questions.length }}</p>
        <RectangleButton :disabled="isGrading" @click="nextQuestion">→</RectangleButton>
      </div>

      <AIFeedbackCard :feedback="currentFeedback" />
    </div>

    <EndOfSessionCard v-else @restartSession="restartSession" />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import type { Ref } from 'vue'

import AIFeedbackCard from './AIFeedbackCard.vue'
import EndOfSessionCard from './EndOfSessionCard.vue'
import QuestionSection from './QuestionSection.vue'
import RectangleButton from './RectangleButton.vue';

import type OpenAIApiResponse from '../interfaces/OpenAIApiResponse'
import type OpenAIApiError from '../interfaces/OpenAIApiError'
import openAIService from '../services/OpenAIService'

const props = defineProps<{
  questions: string[]
}>()

const index = ref(0)
const questionNumber = computed(() => index.value + 1)

const currentQuestion = computed(() => props.questions[index.value])

const answers: Ref<string[]> = ref(Array(props.questions.length).fill(""))
const currentAnswer = computed(() => answers.value[index.value])

const typedAnswer = ref(answers.value[index.value])
const isTypedAnswerEmpty = computed(() => !typedAnswer.value.trim())

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

function resetTypedAnswer() {
  typedAnswer.value = currentAnswer.value
}

function resetQuestion() {
  answers.value[index.value] = ""
  feedbacks.value[index.value] = ""
  statuses.value[index.value] = QuestionStatus.Unanswered
  resetTypedAnswer()
}

function previousQuestion() {
  index.value--
}

function nextQuestion() {
  index.value++
}

function restartSession() {
  index.value = 0
}

function submitAnswer() {
  answers.value[index.value] = typedAnswer.value
  getFeedback()
}

function getFeedback() {
  statuses.value[index.value] = QuestionStatus.Grading
  const prompt = `Suppose I'm seeking a role as a junior software developer. 
  I'm being asked this question in an interview: ${currentQuestion.value}
  This is my answer: ${currentAnswer.value}
  Give me feedback of my answer to that interview question.`

  feedbacks.value[index.value] = "Grading your answer. Please wait."

  openAIService.gradeAnswer(prompt)
    .then((response: OpenAIApiResponse) => feedbacks.value[index.value] = response.data.choices[0].message.content)
    .catch((error: OpenAIApiError) => feedbacks.value[index.value] = error.message)
    .finally(() => statuses.value[index.value] = QuestionStatus.Graded)
}

const textarea = ref<HTMLInputElement | null>(null)
onMounted(() => textarea.value?.focus())

watch(index, () => {
  resetTypedAnswer()
  textarea.value?.focus()
})
</script>