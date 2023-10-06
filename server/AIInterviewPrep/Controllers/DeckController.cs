using AIInterviewPrep.DAOs;
using AIInterviewPrep.DAOs.Interfaces;
using AIInterviewPrep.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace AIInterviewPrep.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class DeckController : ControllerBase
    {
        public IDeckDao deckDao;

        public DeckController(IDeckDao deckDao)
        {
            this.deckDao = deckDao;
        }

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
