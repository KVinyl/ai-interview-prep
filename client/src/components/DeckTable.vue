<template>
  <div class="mt-12 mb-8 drop-shadow-lg">
    <div
      class="flex justify-between bg-slate-300 border border-gray-400 border-b-2 px-4 py-2 text-l font-semibold rounded-t-lg">
      <span class="text-2xl">{{ name }}</span>
      <div class="flex items-center">
        <input type="text" v-model="filterString" class="px-3 py-1 rounded-full"
          :class="{ 'ring-2 ring-green-600': filterString }" placeholder="Filter questions">
      </div>
      <MagicAddButton :disabled="isDisabled" @click="emit('clickMagicAdd')" />
    </div>
    <div class="border border-gray-400 divide-y divide-gray-400 overflow-y-auto max-h-96 rounded-b-lg "
      :class="{ 'rounded-t-lg': !name }">
      <DeckTableRow v-for="questionData in filteredQuestionsData" :key=questionData.number :questionData="questionData"
        :isCurrent="questionData.number - 1 === currentIndex" :isDisabled="isDisabled"
        @clickRowText="emit('jumpToIndex', questionData.number - 1)" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import type { QuestionData } from '../types/QuestionData'
import DeckTableRow from './DeckTableRow.vue'
import MagicAddButton from './MagicAddButton.vue'

const props = defineProps<{
  questionsData: QuestionData[],
  name?: string,
  currentIndex?: number,
  isDisabled?: boolean
}>()

const emit = defineEmits<{
  jumpToIndex: [nextIndex: number],
  clickMagicAdd: [],
}>()

const filterString = ref("")
const filteredQuestionsData = computed(() => props.questionsData.filter(data => data.question.toLowerCase().includes(filterString.value.trim().toLowerCase())))
</script>