<template>
  <button class="bg-slate-400 rounded p-1 hover:bg-yellow-600 disabled:invisible">
    <div class="flex text-white px-1 space-x-1">
      <MagicWand /><span>Add</span>
    </div>
  </button>
</template>

<script setup lang="ts">
import MagicWand from './icons/MagicWand.vue'
</script>