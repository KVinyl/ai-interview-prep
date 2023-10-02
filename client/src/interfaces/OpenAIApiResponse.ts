export default interface OpenAIApiResponse {
  data: {
    choices: [
      {
        message: {
          content: string
        },
      }
    ]
  }
}