<template>
  <button :class="buttonClasses" :disabled="disabled" @click="emit('click')">{{ text }}</button>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = withDefaults(defineProps<{ text?: string, color?: string, disabled?: boolean }>(), {
  text: "", color: "bg-sky-500", disabled: false
})

const emit = defineEmits(['click'])

const buttonClasses = computed(() => {
  const baseClasses = "px-4 py-2"
  if (props.disabled) {
    const disabledClasses = "bg-gray-400 opacity-20 cursor-not-allowed"
    return `${baseClasses} ${disabledClasses}`
  } else {
    return `${baseClasses} ${props.color}`
  }
})
</script>
