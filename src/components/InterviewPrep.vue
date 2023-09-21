<template>
  <div v-if="question">
    <p>{{ question }}</p>
    <textarea v-model="answer" :disabled="isFeedbackLoading"></textarea>
    <button @click="getFeedback(question, answer)" :disabled="isFeedbackLoading">Submit</button>
    <p>{{ feedback }}</p>
    <button @click="currentIndex++" :disabled="isFeedbackLoading">Next Question</button>
  </div>

  <div v-else-if="questions.length">
    <h2>End of study session</h2>
    <button @click="currentIndex = 0">Start Over</button>
  </div>

  <div v-else>
    <h2>No questions found</h2>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import openAIService from '../services/OpenAIService'

const { questions } = defineProps<{
  questions: string[]
}>()

const currentIndex = ref(0)
const question = computed(() => questions[currentIndex.value])

const answer = ref("")
const feedback = ref("")
const isFeedbackLoading = ref(false)

function getFeedback(question: string, answer: string) {
  if (question.trim() && answer.trim()) {
    const prompt = `Suppose I'm seeking a role as a junior software developer. I'm being asked this question in an interview: ${question}\n\nThis is my answer: ${answer}\n\nGive me feedback of my answer to that interview question.`
    
    isFeedbackLoading.value = true
    feedback.value = "Generating OpenAI Feedback..."
    
    openAIService.getFeedback(prompt)
      .then((response: any) => feedback.value = response.data.choices[0].message.content)
      .catch((error: any) => feedback.value = error.message)
      .finally(() => isFeedbackLoading.value = false)
  }
}

watch(currentIndex, () => {
  answer.value = ""
  feedback.value = ""
})
</script>

<style scoped></style>