<template>
  <div class="p-2" :class="bgColor, { 'hover:text-green-900': !isCurrent }">
    <span :class="isCurrent ? 'font-semibold' : 'hover:underline cursor-pointer'" @click="handleClick">{{ questionText
    }}</span>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import type { QuestionData } from '../types/QuestionData'

const props = defineProps<{
  questionData: QuestionData,
  isCurrent?: boolean,
  isDisabled?: boolean
}>()

const emit = defineEmits(['clickText'])

const questionText = `${props.questionData.number}. ${props.questionData.question}`

const bgColor = computed(() => {
  if (props.isCurrent) {
    return "bg-green-200"
  } else if (props.questionData.status === "Graded") {
    return "bg-gray-300"
  } else {
    return "bg-gray-200"
  }
})

function handleClick() {
  if (!props.isDisabled && !props.isCurrent) {
    emit('clickText')
  }
}
</script>