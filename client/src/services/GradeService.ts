import axios from 'axios';

export default {
  grade() {
    return axios.get('/grade');
  },
}