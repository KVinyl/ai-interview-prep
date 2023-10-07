<template>
  <div class="bg-sky-100 overflow-auto min-h-screen">
    <AppHeader />
    <InterviewPreparation v-if="questions" :name="deckName" :questions="questions" />
    <MessageCard v-else :message=message class="w-1/2 mx-auto" />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'

import type { Ref } from 'vue'
import type { AxiosError } from 'axios'

import AppHeader from './components/AppHeader.vue'
import InterviewPreparation from './components/InterviewPreparation.vue'
import MessageCard from './components/MessageCard.vue'

import deckService from './services/DeckService'

const deckName = ref("")
const questions: Ref<string[] | null> = ref(null)
const deckId = 1

const message = ref("Loading deck...")

onMounted(() => {
  deckService.getDeck(deckId)
    .then(response => {
      const deck = response.data
      deckName.value = deck.name ?? ""
      questions.value = deck.questions
    })
    .catch((error: AxiosError) => {
      console.error(error)
      message.value = "Error loading the deck. Please try again."
    })
}) 
</script>