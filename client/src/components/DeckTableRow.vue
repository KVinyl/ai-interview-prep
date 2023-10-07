<template>
    <div v-if="isCurrent" class="bg-green-200 p-2">
        <span class="font-semibold">{{ text }}</span>
    </div>
    <div v-else class="bg-gray-200 hover:text-green-900 p-2">
        <span class=" hover:underline cursor-pointer" @click="emit('clickText')">{{ text }}</span>
    </div>
</template>

<script setup lang="ts">
const props = defineProps<{
    number: number,
    question: string,
    isCurrent?: boolean
}>()

const emit = defineEmits(['clickText'])

const text = `${props.number}. ${props.question}`
</script>