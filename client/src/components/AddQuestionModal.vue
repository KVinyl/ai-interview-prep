<template>
  <Teleport to="#modals">
    <!-- Show / hide the modal -->
    <div v-if="show">
      <!-- Backdrop -->
      <div class="fixed inset-0 bg-gray-900 opacity-40"></div>

      <!-- Content -->
      <div class="fixed inset-0 flex items-center justify-center">
        <div class="flex flex-col bg-gray-200 rounded-lg w-2/5 p-4 items-center space-y-2">
          <h2 class="font-semibold">{{ message }}</h2>
          <div class="flex items-start w-full space-x-2">
            <textarea v-model="newQuestion" class="min-h-8 grow" :disabled="isGeneratingQuestion"></textarea>
            <button class="bg-yellow-500 rounded p-1 hover:bg-yellow-600 disabled:invisible" @click="generateQuestion"
              :disabled="isGeneratingQuestion">
              <MagicWand class="text-white" />
            </button>
          </div>
          <div class="space-x-4">
            <RectangleButton class="bg-red-500" @click="cancelQuestion">
              Cancel
            </RectangleButton>
            <RectangleButton class="bg-green-500" @click="submitQuestion" :disabled="isGeneratingQuestion">
              Submit
            </RectangleButton>
          </div>
        </div>
      </div>
    </div>
  </Teleport>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import signalRService from '../services/SignalRService'
import MagicWand from './icons/MagicWand.vue'
import RectangleButton from './RectangleButton.vue'

const props = defineProps<{
  show: boolean
}>()

const emit = defineEmits<{
  'cancel': [],
  'submit': [newQuestion: string]
}>()

const newQuestion = ref("")
const isGeneratingQuestion = ref(false)
const message = computed(() => isGeneratingQuestion.value ? "Generating question..." : "Add New Question")

function clearQuestion() {
  newQuestion.value = ""
}

function cancelQuestion() {
  emit('cancel')
  clearQuestion()
  isGeneratingQuestion.value = false
}

function submitQuestion() {
  emit('submit', newQuestion.value)
  clearQuestion()
}

function generateQuestion() {
  isGeneratingQuestion.value = true
  clearQuestion()

  const prompt = "Suppose I'm seeking a junior full stack software developer position . Generate an intermediate to advanced technical interview question. Only output the interview question."
  signalRService.invoke('SendPrompt', prompt).finally(() => isGeneratingQuestion.value = false)
}

signalRService.on('ReceiveFeedback', response => {
  if (isGeneratingQuestion.value && response !== null) {
    newQuestion.value += response
  }
})
</script>