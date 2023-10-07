<template>
    <div class="border border-gray-400 divide-y divide-gray-400 my-4 drop-shadow-lg overflow-y-auto h-96">
        <DeckTableRow v-for="(question, index) in questions" :number="index + 1" :question="question"
            :isCurrent="index === currentIndex" @clickText="emit('goToIndex', index)" />
    </div>
</template>

<script setup lang="ts">
import DeckTableRow from './DeckTableRow.vue'

defineProps<{
    questions: string[],
    currentIndex?: number
}>()

const emit = defineEmits<{
    goToIndex: [nextIndex: number]
}>()

</script>