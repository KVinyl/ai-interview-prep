<template>
  <div>
    <AppHeader />
    <InterviewSession :questions="questions" />
  </div>
</template>

<script setup lang="ts">
import AppHeader from './components/AppHeader.vue'
import InterviewSession from './components/InterviewSession.vue'

const questions = ["What is git? Why do we use it?",
  "What is a variable? Can you give an example of an integer expression? A boolean expression?",
  "What controls whether the “if” or the “else” portion of an if-else should execute?"
]
</script>

<style scoped></style>