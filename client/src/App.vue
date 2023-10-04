<template>
  <div class="bg-sky-100 overflow-auto min-h-screen">
    <AppHeader />
    <InterviewPreparation v-if="questions.length" :questions="questions" />
    <div v-else class="text-center">No questions found in the deck</div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import type { Ref } from 'vue'

import AppHeader from './components/AppHeader.vue'
import InterviewPreparation from './components/InterviewPreparation.vue'

import deckService from './services/DeckService'

const questions: Ref<string[]> = ref([])
const deckId = 1

onMounted(() => {
  deckService.getDeck(deckId)
    .then((response) => questions.value = response.data.questions)
    .catch((error) => console.error(error))
}) 
</script>