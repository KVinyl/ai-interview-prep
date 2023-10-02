import { createApp } from 'vue'
import App from './App.vue'
import './assets/tailwind.css'
import axios from 'axios'

axios.defaults.baseURL = import.meta.env.VITE_REMOTE_API

createApp(App).mount('#app')
