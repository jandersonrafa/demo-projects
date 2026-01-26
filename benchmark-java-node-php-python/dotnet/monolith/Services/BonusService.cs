using Monolith.Data;
using Monolith.DTOs;
using Monolith.Models;
using Microsoft.EntityFrameworkCore;

namespace Monolith.Services
{
    public interface IBonusService
    {
        Task<Bonus> CreateBonusAsync(BonusDTO dto);
        Task<Bonus?> GetBonusAsync(int id);
    }

    public class BonusService : IBonusService
    {
        private readonly AppDbContext _context;

        public BonusService(AppDbContext context)
        {
            _context = context;
        }

        public async Task<Bonus> CreateBonusAsync(BonusDTO dto)
        {
            var client = await _context.Clients.FindAsync(dto.ClientId);
            if (client == null) throw new Exception("Client not found");
            if (!client.Active) throw new Exception("Client is inactive");

            decimal finalAmount = dto.Amount;
            if (finalAmount > 100)
            {
                finalAmount *= 1.1m;
            }

            var bonus = new Bonus
            {
                Amount = finalAmount,
                Description = "DOTNET - " + dto.Description,
                ClientId = dto.ClientId,
                CreatedAt = DateTime.UtcNow,
                ExpirationDate = DateTime.UtcNow.AddDays(30)
            };

            _context.Bonuses.Add(bonus);
            await _context.SaveChangesAsync();

            return bonus;
        }

        public async Task<Bonus?> GetBonusAsync(int id)
        {
            return await _context.Bonuses.FindAsync(id);
        }
    }
}
