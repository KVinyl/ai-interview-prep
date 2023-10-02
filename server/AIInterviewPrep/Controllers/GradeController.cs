using Microsoft.AspNetCore.Mvc;

namespace AIInterviewPrep.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class GradeController : ControllerBase
    {
        [HttpGet()]
        public ActionResult<string> Grade()
        {
            return Ok("test response");
        }
    }
}