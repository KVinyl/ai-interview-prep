<template>
  <div class="flex flex-grow px-12 py-4 m-4 min-h-[200px] h-auto border border-gray-400 bg-gray-200 ">
    <p>{{ feedback }}</p>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  feedback: string
}>()
</script>