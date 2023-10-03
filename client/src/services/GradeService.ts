import axios from 'axios';

export default {
  grade(content: string) {
    return axios.post('/grade', { content })
  }
}