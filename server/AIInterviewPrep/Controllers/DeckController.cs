using AIInterviewPrep.DAOs.Interfaces;
using AIInterviewPrep.Models;
using Microsoft.AspNetCore.Mvc;

namespace AIInterviewPrep.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class DeckController(IDeckDao deckDao) : ControllerBase
    {
        public IDeckDao deckDao = deckDao;

        [HttpGet("{deckId}")]
        public ActionResult<Deck> GetDeck(int deckId)
        {
            Deck? deck = deckDao.GetDeck(deckId);

            if (deck == null)
            {
                return BadRequest();
            }
            return Ok(deck);
        }
    }
}
