using Azure;
using Azure.AI.OpenAI;
using Microsoft.AspNetCore.SignalR;

namespace AIInterviewPrep.Hubs
{
    public class OpenAIHub(IConfiguration configuration) : Hub
    {
        private readonly IConfiguration Configuration = configuration;

        public async Task SendPrompt(string prompt)
        {
            string? openAIApiKey = Configuration["OPENAI_API_KEY"];

            OpenAIClient client = new(openAIApiKey, new OpenAIClientOptions());
            ChatCompletionsOptions chatCompletionsOptions = new()
            {
                Messages = { new ChatMessage(ChatRole.User, prompt) }
            };

            Response<StreamingChatCompletions> response = await client.GetChatCompletionsStreamingAsync(
                deploymentOrModelName: "gpt-3.5-turbo", chatCompletionsOptions);

            using StreamingChatCompletions streamingChatCompletions = response.Value;

            await foreach (StreamingChatChoice choice in streamingChatCompletions.GetChoicesStreaming())
            {
                await foreach (ChatMessage message in choice.GetMessageStreaming())
                {
                    await Clients.Caller.SendAsync("ReceiveFeedback", message.Content);
                }
            }
        }
    }
}