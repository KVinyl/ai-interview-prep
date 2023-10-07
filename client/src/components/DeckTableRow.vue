<template>
    <div>{{ number }} {{ question }}</div>
</template>

<script setup lang="ts">
const props = defineProps<{
    number: number,
    question: string
}>()
</script>