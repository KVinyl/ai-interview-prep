<template>
  <div class="bg-sky-100 overflow-auto min-h-screen">
    <AppHeader />
    <InterviewPreparation v-if="questions" :questions="questions" />
    <MessageCard v-else :message=message />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import type { Ref } from 'vue'

import AppHeader from './components/AppHeader.vue'
import InterviewPreparation from './components/InterviewPreparation.vue'
import MessageCard from './components/MessageCard.vue'

import deckService from './services/DeckService'

const questions: Ref<string[] | null> = ref(null)
const deckId = 1

const message = ref("Loading deck...")

onMounted(() => {
  deckService.getDeck(deckId)
    .then((response) => questions.value = response.data.questions)
    .catch((error) => {
      console.error(error)
      message.value = "Error loading the deck. Please try again."
    })
}) 
</script>