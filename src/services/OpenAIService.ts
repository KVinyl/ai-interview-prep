import axios from "axios";

export default {
  getFeedback(content: string) {
    const apiKey: string | undefined = import.meta.env.VITE_OPENAI_API_KEY;

    return axios.post(
      "https://api.openai.com/v1/chat/completions",
      {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content }],
        temperature: 0.7,
      },
      {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${apiKey}`,
        },
      }
    )
  }
}