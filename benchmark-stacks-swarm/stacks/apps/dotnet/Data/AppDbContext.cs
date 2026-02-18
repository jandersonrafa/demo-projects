using Microsoft.EntityFrameworkCore;
using Monolith.Models;

namespace Monolith.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Client> Clients { get; set; }
        public DbSet<Bonus> Bonuses { get; set; }
    }
}
