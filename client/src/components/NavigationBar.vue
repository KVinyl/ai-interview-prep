<template>
  <div class="flex flex-row justify-center items-center space-x-6 p-2 bg-slate-300 border border-gray-400 drop-shadow-lg">
    <ShuffleButton :isShuffled="isShuffled" :isDisabled="isProcessing" @click="emit('toggleShuffle')" />

    <CircleButton :disabled="isPrevButtonDisabled" @click="emit('previousQuestion')"
      class="bg-sky-500 hover:bg-sky-600 text-2xl">
      🡨</CircleButton>
    <span class="text-xl">
      <slot></slot>
    </span>
    <CircleButton :disabled="isProcessing" @click="emit('nextQuestion')" class="bg-sky-500 hover:bg-sky-600 text-2xl">🡪
    </CircleButton>

    <!-- Invisible button placeholder to maintain center alignment -->
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
  shuffleStartIndex?: number,
  status: QuestionStatus,
  isShuffled: boolean,
}>()

const emit = defineEmits(['toggleShuffle', 'previousQuestion', 'nextQuestion'])

const isProcessing = computed(() => props.status === "Processing")
const isPrevButtonDisabled = computed(() => isProcessing.value || (!props.isShuffled && props.index === 0) || props.index === props.shuffleStartIndex)
</script>