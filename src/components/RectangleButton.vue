<template>
  <button :class="buttonClasses" :disabled="disabled" @click="emit('click')">
    <slot></slot>
  </button>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = withDefaults(defineProps<{ color?: string, disabled?: boolean }>(), {
  color: "bg-sky-500", disabled: false
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
