namespace MassDefect.Models
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class Star
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string Name { get; set; }

        public int? SolarSystemId { get; set; }

        [ForeignKey("SolarSystemId")]
        public virtual SolarSystem SolarSystem { get; set; }
    }
}
