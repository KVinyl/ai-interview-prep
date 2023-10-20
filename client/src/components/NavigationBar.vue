<template>
  <div
    class="flex flex-row justify-center items-center space-x-6 p-2 bg-slate-300 border border-gray-400  drop-shadow-lg">
    <ShuffleButton :isShuffled="isShuffled" :isDisabled="isGrading" @click="emit('toggleShuffle')" />

    <CircleButton :disabled="isPrevButtonDisabled" @click="emit('previousQuestion')"
      class="bg-sky-500 hover:bg-sky-600 text-2xl">
      🡨</CircleButton>
    <span class="text-xl">
      <slot></slot>
    </span>
    <CircleButton :disabled="isGrading" @click="emit('nextQuestion')" class="bg-sky-500 hover:bg-sky-600 text-2xl">🡪
    </CircleButton>

    <CircleButton class="invisible">.
    </CircleButton>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { QuestionStatus } from '../types/QuestionStatus'

import CircleButton from './CircleButton.vue'
import ShuffleButton from './ShuffleButton.vue'

const props = defineProps<{
  index: number,
  status: QuestionStatus,
  isShuffled: boolean
}>()

const emit = defineEmits(['toggleShuffle', 'previousQuestion', 'nextQuestion'])

const isGrading = computed(() => props.status === "Grading")
const isPrevButtonDisabled = computed(() => isGrading.value || props.index === 0)
</script>