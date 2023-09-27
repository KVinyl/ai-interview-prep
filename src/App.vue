<template>
  <div>
    <AppHeader />
    <InterviewPreparation :questions="questions" />
  </div>
</template>

<script setup lang="ts">
import { interviewQuestionOfTheDayArray } from './assets/data'

import AppHeader from './components/AppHeader.vue'
import InterviewPreparation from './components/InterviewPreparation.vue'

const questions = interviewQuestionOfTheDayArray
</script>