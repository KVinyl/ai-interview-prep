<template>
  <div class="mt-12 mb-8 drop-shadow-lg">
    <div
      class="flex justify-between bg-slate-300 border border-gray-400 border-b-2 px-4 py-2 rounded-t-lg">
      <div class="text-2xl font-semibold">{{ name }}</div>
      <div class="flex items-center">
        <input type="text" v-model="filterString" class="px-3 py-1 rounded-full ring-2 focus:ring-2"
          :class="filterRingColor, filterBgColor" placeholder="Filter questions">
      </div>
      <button class="bg-slate-400 hover:bg-green-500 rounded px-2 disabled:opacity-20 disabled:cursor-not-allowed" :disabled="isDisabled"
        @click="emit('clickAddQuestion')"><span class="text-2xl font-semibold leading-4">+</span></button>

    </div>
    <div class="border border-gray-400 divide-y divide-gray-400 overflow-y-auto max-h-96 rounded-b-lg "
      :class="{ 'rounded-t-lg': !name }">
      <DeckTableRow v-if="filteredQuestionsData.length > 0" v-for="questionData in filteredQuestionsData"
        :key=questionData.number :questionData="questionData" :isCurrent="questionData.number - 1 === currentIndex"
        :isDisabled="isDisabled" @clickRowText="emit('jumpToIndex', questionData.number - 1)" />
      <div v-else class="px-4 py-2 bg-gray-200 text-red-800 ">Nothing found for <span class="font-bold">{{ filterString
      }}</span>.</div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import type { QuestionData } from '../types/QuestionData'
import DeckTableRow from './DeckTableRow.vue'
import RectangleButton from './RectangleButton.vue'


const props = defineProps<{
  questionsData: QuestionData[],
  name?: string,
  currentIndex?: number,
  isDisabled?: boolean
}>()

const emit = defineEmits<{
  jumpToIndex: [nextIndex: number],
  clickAddQuestion: [],
}>()

const filterString = ref("")
const filteredQuestionsData = computed(() => props.questionsData.filter(data => data.question.toLowerCase().includes(filterString.value.trim().toLowerCase())))

const filterRingColor = computed(() => {
  if (filterString.value.trim().length === 0) {
    return ""
  }
  else if (filteredQuestionsData.value.length > 0) {
    return "ring-green-600"
  }
  else {
    return "ring-red-800"
  }
})

const filterBgColor = computed(() => filteredQuestionsData.value.length > 0 ? "bg-white" : "bg-red-300")
</script>