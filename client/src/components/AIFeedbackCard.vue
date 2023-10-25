<template>
  <div class="px-12 py-4 mb-4 min-h-[200px] h-auto border rounded-b-lg border-gray-400 bg-gray-200 drop-shadow-md">
    <div v-show="isLoading" class="flex flex-col items-center mx-auto">
      <span>{{ gradingMessage }}</span>
      <div class="w-1/4 p-4">
        <AnimatedSpinner />
      </div>
    </div>
    <div v-show="!isLoading" class="justify-start whitespace-pre-wrap">
      {{ questionData.feedback }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { QuestionData } from '../types/QuestionData'
import AnimatedSpinner from './icons/AnimatedSpinner.vue'

const props = defineProps<{
  questionData: QuestionData
}>()

const gradingMessage = "Grading your answer. Please wait..."

const isLoading = computed(() => props.questionData.status === "Grading" && !props.questionData.feedback)
</script>