namespace AIInterviewPrep.Models
{
    public class Deck
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public List<string> Questions { get; set; } = [];
    }
}