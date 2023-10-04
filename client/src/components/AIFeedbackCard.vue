<template>
  <div
    class="flex justify-center px-12 py-4 mt-4 mb-16 min-h-[200px] h-auto border rounded-lg border-gray-400 bg-gray-200 drop-shadow-md">
    <div v-show="isLoading" class="flex flex-col items-center">
      <div>{{ gradingMessage }}</div>
      <div class="w-1/2 p-4">
        <AnimatedSpinner />
      </div>
    </div>
    <div v-show="!isLoading">
      <div>{{ feedback }}</div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import AnimatedSpinner from './AnimatedSpinner.vue'

const props = defineProps<{
  feedback: string,
  isGrading?: boolean
}>()

const gradingMessage = "Grading your answer. Please wait..."

const isLoading = computed(() => props.isGrading && !props.feedback)
</script>