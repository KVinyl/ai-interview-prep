<template>
  <div v-if="question">
    <p>{{ question }}</p>
    <textarea v-model="answer"></textarea>
    <button @click="getFeedback(answer)">Submit</button>
    <p>{{ feedback }}</p>
    <button @click="currentIndex++">Next Question</button>
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

const questions: string[] = ["What is git? Why do we use it?",
  "What is a variable? Can you give an example of an integer expression? A boolean expression?",
  "What controls whether the “if” or the “else” portion of an if-else should execute?"
]
const currentIndex = ref(0)
const question = computed(() => questions[currentIndex.value])

const answer = ref("")
const feedback = ref("")

function getFeedback(prompt: string) {
  feedback.value = prompt ? `This is the feedback to the answer: ${prompt}` : "Please enter an answer to the question."
}

watch(currentIndex, () => {
  answer.value = ""
  feedback.value = ""
})
</script>

<style scoped></style>