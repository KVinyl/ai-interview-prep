using AIInterviewPrep.Models;
using Microsoft.AspNetCore.Mvc;

namespace AIInterviewPrep.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class GradeController : ControllerBase
    {
        [HttpPost()]
        public ActionResult<string> Grade(Prompt prompt)
        {
            if (prompt.Content.Length == 0)
            {
                return BadRequest("The prompt cannot be empty.");
            }

            return Ok($"test response to {prompt.Content}");
        }
    }
}