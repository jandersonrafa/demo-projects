namespace Monolith.DTOs
{
    public class BonusDTO
    {
        public decimal Amount { get; set; }
        public string Description { get; set; } = string.Empty;
        public string ClientId { get; set; } = string.Empty;
    }
}
