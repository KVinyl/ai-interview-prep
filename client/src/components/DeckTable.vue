<template>
    <div>
        <DeckTableRow v-for="(question, index) in questions" :number="index + 1" :question="question" />
    </div>
</template>

<script setup lang="ts">
import DeckTableRow from './DeckTableRow.vue';
const props = defineProps<{
    questions: string[]
}>()
</script>