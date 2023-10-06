<template>
    <div class="border border-gray-400 bg-gray-200 m-4 flex flex-col items-center space-y-4 px-12 py-4">
        <h2>{{ message }}</h2>
    </div>
</template>
<script setup lang="ts">
defineProps<{
    message: string
}>()
</script>