namespace MassDefect.Models
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class Anomaly
    {
        private ICollection<Person> persons;

        public Anomaly()
        {
            this.persons = new HashSet<Person>();
        }

        [Key]
        public int Id { get; set; }

        public int? OriginPlanetId { get; set; }

        [ForeignKey("OriginPlanetId")]
        public virtual Planet OriginPlanet { get; set; }

        public int? TeleportPlanetId { get; set; }

        [ForeignKey("TeleportPlanetId")]
        public virtual Planet TeleportPlanet { get; set; }

        public virtual ICollection<Person> Persons
        {
            get { return this.persons; }
            set { this.persons = value; }
        }
    }
}
