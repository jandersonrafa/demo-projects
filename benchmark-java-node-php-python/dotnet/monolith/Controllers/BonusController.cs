using Microsoft.AspNetCore.Mvc;
using Monolith.DTOs;
using Monolith.Models;
using Monolith.Services;

namespace Monolith.Controllers
{
    [ApiController]
    [Route("bonus")]
    public class BonusController : ControllerBase
    {
        private readonly IBonusService _service;

        public BonusController(IBonusService service)
        {
            _service = service;
        }

        [HttpPost]
        public async Task<ActionResult<Bonus>> Create([FromBody] BonusDTO dto)
        {
            try
            {
                var bonus = await _service.CreateBonusAsync(dto);
                return CreatedAtAction(nameof(Get), new { id = bonus.Id }, bonus);
            }
            catch (Exception ex) when (ex.Message == "Client not found")
            {
                return NotFound(new { error = ex.Message });
            }
            catch (Exception ex) when (ex.Message == "Client is inactive")
            {
                return BadRequest(new { error = ex.Message });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Bonus>> Get(int id)
        {
            var bonus = await _service.GetBonusAsync(id);
            if (bonus == null) return Ok(null); // Java returns null -> 200 with empty/null body
            return Ok(bonus);
        }
    }
}
