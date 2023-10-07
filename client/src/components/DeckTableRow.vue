<template>
    <div class="bg-gray-200 p-2 space-x-1 ">
        <span class="cursor-pointer hover:text-green-900" @click="$emit('clickText')">{{ text }}</span>
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