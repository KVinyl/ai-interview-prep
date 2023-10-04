<template>
  <div class="px-4 py-2">
    <p>{{ question }}</p>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  question: string
}>()
</script>