<template>
  <button class="text-4xl border-b-2" :class="{
    'text-green-500 border-green-500': isShuffled,
    'hover:text-green-600 hover:border-green-600': isShuffled && !isDisabled,
    'text-gray-400 border-transparent': !isShuffled,
    'hover:text-gray-500': !isShuffled && !isDisabled
  }" :disabled="isDisabled">⤨</button>
</template>

<script setup lang="ts">
const props = defineProps<{
  isShuffled: boolean,
  isDisabled?: boolean
}>()


</script>