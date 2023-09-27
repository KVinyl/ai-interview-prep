<template>
  <div class="bg-gray-200 flex px-12 py-4 m-16 min-h-[200px] h-auto">
    <p>{{ feedback }}</p>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  feedback: string
}>()
</script>