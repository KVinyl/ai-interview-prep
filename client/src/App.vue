<template>
  <div class="bg-sky-100 overflow-auto min-h-screen">
    <AppHeader />
    <TestSession v-if="questionsData" :name="deckName" :questionsData="questionsData" />
    <ErrorMessageCard v-else :message=message class="w-1/2 mx-auto my-4" />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'

import type { Ref } from 'vue'
import type { AxiosError } from 'axios'

import AppHeader from './components/AppHeader.vue'
import TestSession from './components/TestSession.vue'
import ErrorMessageCard from './components/ErrorMessageCard.vue'

import deckService from './services/DeckService'
import type { QuestionData } from './types/QuestionData'

const deckName = ref("")
const questionsData: Ref<QuestionData[] | null> = ref(null)
const deckId = 1

const message = ref("Loading deck...")

onMounted(() => {
  const savedQuestionsDataString: string | null = localStorage.getItem("questionsData")

  if (savedQuestionsDataString) {
    questionsData.value = JSON.parse(savedQuestionsDataString)
  } else {
    resetDeck()
  }
})

function resetDeck() {
  deckService.getDeck(deckId)
    .then(response => {
      const deck = response.data
      deckName.value = deck.name ?? ""
      questionsData.value = deck.questions.map((question, index) => ({
        number: index + 1,
        question,
        answer: "",
        feedback: "",
        status: "Unanswered"
      }))
    })
    .catch((error: AxiosError) => {
      console.error(error)
      message.value = "Error loading the deck. Please try again."
    })
}
</script>