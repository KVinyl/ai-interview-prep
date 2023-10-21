<template>
  <div class="px-4 py-2">
    {{ question }}
  </div>
</template>

<script setup lang="ts">
defineProps<{
  question: string
}>()
</script>