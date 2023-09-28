<template>
  <div class="flex flex-grow px-12 py-4 mt-4 mb-16 min-h-[200px] h-auto border rounded-lg border-gray-400 bg-gray-200 ">
    <p>{{ feedback }}</p>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  feedback: string
}>()
</script>