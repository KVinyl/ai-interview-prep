<template>
  <div v-if="question">
    <p>{{ question }}</p>
    <textarea v-model="answer" :disabled="status !== QuestionStatus.Unanswered"></textarea>
    <button v-show="!feedback" @click="getFeedback(question, answer)"
      :disabled="!(status === QuestionStatus.Unanswered) || !answer.trim()">Submit</button>
    <p>{{ feedback }}</p>
    <button v-show="status === QuestionStatus.Graded" @click="reset">Try Again</button>
    <button v-show="status !== QuestionStatus.Grading" @click="questionsIndex++">Next Question</button>
  </div>

  <div v-else-if="questions.length">
    <h2>End of study session</h2>
    <button @click="questionsIndex = 0">Start Over</button>
  </div>

  <div v-else>
    <h2>No questions found</h2>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'

import type OpenAIApiResponse from '../interfaces/OpenAIApiResponse'
import type OpenAIApiError from '../interfaces/OpenAIApiError'
import openAIService from '../services/OpenAIService'

const { questions } = defineProps<{
  questions: string[]
}>()

const questionsIndex = ref(0)
const question = computed(() => questions[questionsIndex.value])

const answer = ref("")
const feedback = ref("")

enum QuestionStatus {
  Unanswered,
  Grading,
  Graded
}
const status = ref(QuestionStatus.Unanswered)

function getFeedback(question: string, answer: string) {
  status.value = QuestionStatus.Grading
  const prompt = `Suppose I'm seeking a role as a junior software developer. 
  I'm being asked this question in an interview: ${question}
  
  This is my answer: ${answer}
  
  Give me feedback of my answer to that interview question.`

  feedback.value = "Generating OpenAI Feedback..."

  openAIService.getFeedback(prompt)
    .then((response: OpenAIApiResponse) => feedback.value = response.data.choices[0].message.content)
    .catch((error: OpenAIApiError) => feedback.value = error.message)
    .finally(() => status.value = QuestionStatus.Graded)
}

function reset() {
  answer.value = ""
  feedback.value = ""
  status.value = QuestionStatus.Unanswered
}

watch(questionsIndex, () => {
  reset()
})
</script>

<style scoped></style>../types/OpenAIApiResponse../types/OpenAIApiResponseData../types/OpenAIApiResponse../interfaces/OpenAIApiResponse