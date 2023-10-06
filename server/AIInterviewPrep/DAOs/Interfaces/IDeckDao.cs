using AIInterviewPrep.Models;

namespace AIInterviewPrep.DAOs.Interfaces
{
    public interface IDeckDao
    {
        public Deck? GetDeck(int deckId);
    }
}
