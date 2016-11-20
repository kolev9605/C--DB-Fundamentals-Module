namespace MassDefect.Models
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class Planet
    {
        private ICollection<Anomaly> originAnomalies;
        private ICollection<Anomaly> teleportAnomalies;

        public Planet()
        {
            this.originAnomalies = new HashSet<Anomaly>();
            this.teleportAnomalies = new HashSet<Anomaly>();
        }

        [Key]
        public int Id { get; set; }

        [Required]
        public string Name { get; set; }

        public int SunId { get; set; }

        [ForeignKey("SunId")]
        public virtual Star Sun { get; set; }

        public int SolarSystemId { get; set; }

        [ForeignKey("SolarSystemId")]
        public virtual SolarSystem SolarSystem { get; set; }
        
        [InverseProperty("OriginPlanet")]
        public virtual ICollection<Anomaly> OriginAnomalies
        {
            get { return this.originAnomalies; }
            set { this.originAnomalies = value; }
        }

        [InverseProperty("TeleportPlanet")]
        public virtual ICollection<Anomaly> TeleportAnomalies
        {
            get { return this.teleportAnomalies; }
            set { this.teleportAnomalies = value; }
        }
    }
}
