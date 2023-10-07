<template>
    <div class="bg-gray-200 p-2">
        <span class=" hover:text-green-900 hover:underline cursor-pointer" @click="$emit('clickText')">{{ text }}</span>
    </div>
</template>

<script setup lang="ts">
const props = defineProps<{
    number: number,
    question: string
}>()

const emit = defineEmits(['clickText'])

const text = `${props.number}. ${props.question}`
</script>