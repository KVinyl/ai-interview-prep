<template>
  <button class="bg-sky-500 rounded-full p-1 hover:bg-yellow-600">
    <div class="flex text-white px-1 space-x-1">
      <MagicWand /><span>Add</span>
    </div>
  </button>
</template>

<script setup lang="ts">
import MagicWand from './icons/MagicWand.vue'
</script>