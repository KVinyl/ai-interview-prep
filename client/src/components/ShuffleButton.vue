<template>
  <button class="text-4xl border-b-2"
    :class="isShuffled ? 'text-green-500 hover:text-green-600 border-green-500 hover:border-green-600' : 'text-gray-400 hover:text-gray-500 border-transparent'">⤨</button>
</template>

<script setup lang="ts">
const props = defineProps<{
  isShuffled: boolean
}>()
</script>