<template>
    <div class="my-8 drop-shadow-lg">
        <div v-if="name" class="bg-slate-300 border border-gray-400 border-b-2  p-2 text-l font-semibold rounded-t-lg">{{ name }}</div>
        <div class="border border-gray-400 divide-y divide-gray-400 overflow-y-auto h-96 rounded-b-lg">
            <DeckTableRow v-for="(question, index) in questions" :number="index + 1" :question="question"
                :isCurrent="index === currentIndex" @clickText="emit('goToIndex', index)" />
        </div>
    </div>
</template>

<script setup lang="ts">
import DeckTableRow from './DeckTableRow.vue'

defineProps<{
    questions: string[],
    name?: string,
    currentIndex?: number
}>()

const emit = defineEmits<{
    goToIndex: [nextIndex: number]
}>()

</script>