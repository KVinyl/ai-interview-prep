<template>
  <div class="bg-gray-300 flex px-12 py-4 ">
    <p>{{ feedback }}</p>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  feedback: string
}>()
</script>