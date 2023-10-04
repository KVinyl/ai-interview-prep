namespace AIInterviewPrep.Models
{
    public class Deck
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public List<Question> Questions { get; set; }
    }
}
