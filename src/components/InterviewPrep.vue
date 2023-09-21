<template>
  <div v-if="currentQuestion">
    <p>{{ currentQuestion }}</p>
    <textarea v-model="answer" :disabled="!isUnanswered"></textarea>
    <button v-show="isUnanswered" @click="submitAnswer(currentQuestion, answer)" :disabled="isAnswerEmpty">Submit</button>
    <p>{{ feedback }}</p>
    <button v-show="isGraded" @click="resetQuestion">Try Again</button>
    <button v-show="!isGrading" @click="nextQuestion">Next Question</button>
  </div>

  <div v-else-if="hasQuestions">
    <h2>End of study session</h2>
    <button @click="restartSession">Restart Session</button>
  </div>

  <div v-else>
    <h2>No questions found</h2>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

import type OpenAIApiResponse from '../interfaces/OpenAIApiResponse'
import type OpenAIApiError from '../interfaces/OpenAIApiError'
import openAIService from '../services/OpenAIService'

const { questions } = defineProps<{
  questions: string[]
}>()

const questionsIndex = ref(0)
const currentQuestion = computed(() => questions[questionsIndex.value])
const hasQuestions = computed(() => questions.length > 0)

const answer = ref("")
const isAnswerEmpty = computed(() => !answer.value.trim())

const feedback = ref("")

enum QuestionStatus {
  Unanswered,
  Grading,
  Graded
}
const status = ref(QuestionStatus.Unanswered)

const isUnanswered = computed(() => status.value === QuestionStatus.Unanswered)
const isGrading = computed(() => status.value === QuestionStatus.Grading)
const isGraded = computed(() => status.value === QuestionStatus.Graded)

function resetQuestion() {
  answer.value = ""
  feedback.value = ""
  status.value = QuestionStatus.Unanswered
}

function nextQuestion() {
  questionsIndex.value++
  resetQuestion()
}

function restartSession() {
  questionsIndex.value = 0
  resetQuestion()
}

function submitAnswer(question: string, answer: string) {
  status.value = QuestionStatus.Grading
  const prompt = `Suppose I'm seeking a role as a junior software developer. 
  I'm being asked this question in an interview: ${question}
  This is my answer: ${answer}
  Give me feedback of my answer to that interview question.`

  feedback.value = "Grading your answer. Please wait."

  openAIService.gradeAnswer(prompt)
    .then((response: OpenAIApiResponse) => feedback.value = response.data.choices[0].message.content)
    .catch((error: OpenAIApiError) => feedback.value = error.message)
    .finally(() => status.value = QuestionStatus.Graded)
}
</script>

<style scoped></style>