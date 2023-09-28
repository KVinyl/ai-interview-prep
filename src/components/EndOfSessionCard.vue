<template>
  <div class="border border-gray-400 bg-gray-200 m-16 flex flex-col items-center space-y-4 px-12 py-4">
    <h2>End of study session</h2>
    <RectangleButton @click="emit('restartSession')">Restart Session</RectangleButton>
  </div>
</template>

<script setup lang="ts">
import RectangleButton from './RectangleButton.vue';
const emit = defineEmits(['restartSession'])
</script>