<template>
  <div>
    <p>{{ question }}</p>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  question: string
}>()
</script>

<style scoped></style>