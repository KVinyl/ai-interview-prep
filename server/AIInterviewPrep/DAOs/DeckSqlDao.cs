using AIInterviewPrep.DAOs.Interfaces;
using AIInterviewPrep.Models;
using System.Data.SqlClient;

namespace AIInterviewPrep.DAOs
{
    public class DeckSqlDao(string connectionString) : IDeckDao
    {
        private readonly string connectionString = connectionString;

        public Deck? GetDeck(int deckId)
        {
            string sqlGetDeck = "SELECT deck_id, deck_name FROM deck WHERE deck_id = @deck_id;";
            Deck? deck = null;

            try
            {
                using (SqlConnection conn = new(connectionString))
                {
                    conn.Open();
                    using (SqlCommand cmd = new(sqlGetDeck, conn))
                    {
                        cmd.Parameters.AddWithValue("@deck_id", deckId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                deck = MapRowToDeck(reader);
                            }
                        }
                    }
                }
            }
            catch (Exception)
            {
                return null;
            }

            return deck;
        }

        private List<string> GetQuestionsByDeckId(int deckId)
        {
            string sqlGetQuestionsByDeckId = "SELECT question_text FROM question WHERE deck_id = @deck_id;";
            List<string> questions = [];

            try
            {
                using (SqlConnection conn = new(connectionString))
                {
                    conn.Open();
                    using (SqlCommand cmd = new(sqlGetQuestionsByDeckId, conn))
                    {
                        cmd.Parameters.AddWithValue("@deck_id", deckId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                string questionText = Convert.ToString(reader["question_text"])!;
                                questions.Add(questionText);
                            }
                        }
                    }
                }
            }
            catch (Exception)
            {
                return [];
            }

            return questions;
        }

        private Deck MapRowToDeck(SqlDataReader reader)
        {
            Deck deck = new()
            {
                Id = Convert.ToInt32(reader["deck_id"]),
                Name = Convert.ToString(reader["deck_name"])!,       
            };
            deck.Questions = GetQuestionsByDeckId(deck.Id);

            return deck;
        }
    }
}
