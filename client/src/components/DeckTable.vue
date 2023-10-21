<template>
  <div class="mt-12 mb-8 drop-shadow-lg">
    <div v-if="name"
      class="flex justify-between bg-slate-300 border border-gray-400 border-b-2 px-4 py-2 text-l font-semibold rounded-t-lg">
      <span class="text-2xl">{{ name }}</span>
      <MagicAddButton :disabled="isDisabled" @click="emit('clickMagicAdd')" />
    </div>
    <div class="border border-gray-400 divide-y divide-gray-400 overflow-y-auto h-96 rounded-b-lg"
      :class="{ 'rounded-t-lg': !name }">
      <DeckTableRow v-for="(questionData, index) in questionsData" :key=questionData.number :questionData="questionData"
        :isCurrent="index === currentIndex" :isDisabled="isDisabled" @clickRowText="emit('jumpToIndex', index)" />
    </div>
  </div>
</template>

<script setup lang="ts">
import type { QuestionData } from '../types/QuestionData'
import DeckTableRow from './DeckTableRow.vue'
import MagicAddButton from './MagicAddButton.vue'

defineProps<{
  questionsData: QuestionData[],
  name?: string,
  currentIndex?: number,
  isDisabled?: boolean
}>()

const emit = defineEmits<{
  jumpToIndex: [nextIndex: number],
  clickMagicAdd: [],
}>()
</script>