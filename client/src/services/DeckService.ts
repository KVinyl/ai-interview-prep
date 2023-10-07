import axios from 'axios'

import type Deck from '../interfaces/Deck'

export default {
    getDeck(deckId: number) {
        return axios.get<Deck>(`/deck/${deckId}`)
    }
}