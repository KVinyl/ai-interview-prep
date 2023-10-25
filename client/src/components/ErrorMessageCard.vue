<template>
  <div class="px-12 py-4 h-auto border  border-gray-400 bg-gray-200 drop-shadow-md">
    <div class="flex flex-col items-center mx-auto">
      <span class="text-red-800">{{ message }}</span>
    </div>
  </div>
</template>
<script setup lang="ts">
defineProps<{
  message: string
}>()
</script>