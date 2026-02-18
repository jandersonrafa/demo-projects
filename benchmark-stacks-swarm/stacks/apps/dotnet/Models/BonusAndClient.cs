using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Monolith.Models
{
    [Table("clients")]
    public class Client
    {
        [Key]
        [Column("id")]
        public string Id { get; set; } = string.Empty;

        [Column("name")]
        public string Name { get; set; } = string.Empty;

        [Column("active")]
        public bool Active { get; set; } = true;
    }

    [Table("bonus")]
    public class Bonus
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("amount")]
        public decimal Amount { get; set; }

        [Column("description")]
        public string Description { get; set; } = string.Empty;

        [Column("client_id")]
        public string ClientId { get; set; } = string.Empty;

        [Column("expiration_date")]
        public DateTime? ExpirationDate { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
