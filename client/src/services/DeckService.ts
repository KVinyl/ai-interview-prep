import axios from 'axios'

export default {
    getDeck(deckId: number) {
        return axios.get(`/deck/${deckId}`)
    }
}