<template>
  <div class="container">
    <div v-if="currentQuestion">
      <div class="border border-black m-16">
        <div class="flex flex-col items-center space-y-4 px-12 py-4">
          <p>{{ currentQuestion }}</p>
          <textarea ref="textarea" v-model="answer" class="w-3/4 h-32 border border-black p-4"
            placeholder="Enter your answer" :disabled="!isUnanswered"></textarea>
          <RectangleButton v-show="isUnanswered" text="Submit" :disabled="isAnswerEmpty"
            @click="submitAnswer(currentQuestion, answer)" />
        </div>
      </div>
      <div class="flex flex-row justify-center space-x-4 ">
        <RectangleButton text="Previous Question" :disabled="isPrevButtonDisabled" @click="previousQuestion" />
        <RectangleButton text="Try Again" :disabled="!isGraded" @click="resetQuestion" />
        <RectangleButton text="Next Question" :disabled="isGrading" @click="nextQuestion" />
      </div>
      <div class="bg-gray-300 flex px-12 py-4 ">
        <p>{{ feedback }}</p>
      </div>
    </div>

    <div v-else-if="hasQuestions">
      <div class="border border-black m-16 flex flex-col items-center space-y-4 px-12 py-4">
        <h2>End of study session</h2>
        <RectangleButton text="Restart Session" @click="restartSession" />
      </div>
    </div>

    <div v-else>
      <div class="border border-black m-16 flex flex-col items-center space-y-4 px-12 py-4">
        <h2>No questions found</h2>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'

import RectangleButton from './RectangleButton.vue'

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

const isPrevButtonDisabled = computed(() => questionsIndex.value === 0 || isGrading.value)

function resetQuestion() {
  answer.value = ""
  feedback.value = ""
  status.value = QuestionStatus.Unanswered
}

function previousQuestion() {
  questionsIndex.value--
  resetQuestion()
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

const textarea = ref<HTMLInputElement | null>(null)
onMounted(() => textarea.value?.focus())
</script>