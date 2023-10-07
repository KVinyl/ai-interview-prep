<template>
  <div class="border border-gray-400 bg-gray-200 mx-16 mt-8 mb-16 flex flex-col items-center space-y-4 px-12 py-4 rounded-lg drop-shadow-lg">
    <h2 class="text-lg font-medium">End of study session</h2>
    <div class="flex selection:flex-row space-x-4">
      <CircleButton @click="emit('goToLastQuestion')" class="bg-sky-500 hover:bg-sky-600">🡨</CircleButton>
      <RectangleButton @click="emit('restartSession')" class="bg-sky-500 hover:bg-sky-600">Restart Session</RectangleButton>
    </div>
  </div>
</template>

<script setup lang="ts">
import CircleButton from './CircleButton.vue'
import RectangleButton from './RectangleButton.vue'
const emit = defineEmits(['goToLastQuestion', 'restartSession'])
</script>