<template>
    <div class="border border-gray-400 divide-y divide-gray-400 my-4 drop-shadow-lg">
        <DeckTableRow v-for="(question, index) in questions" :number="index + 1" :question="question" @clickText="$emit('goToIndex', index)" />
    </div>
</template>

<script setup lang="ts">
import DeckTableRow from './DeckTableRow.vue'
const props = defineProps<{
    questions: string[]
}>()

const emit = defineEmits(['goToIndex'])

</script>