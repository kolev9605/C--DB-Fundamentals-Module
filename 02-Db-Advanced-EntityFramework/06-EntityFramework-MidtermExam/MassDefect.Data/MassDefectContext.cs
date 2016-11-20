namespace MassDefect.Data
{
    using System.Data.Entity;
    using Models;

    public class MassDefectContext : DbContext
    {
        public MassDefectContext()
            : base("name=MassDefectContext")
        {
        }

        public virtual IDbSet<Anomaly> Anomalies { get; set; }

        public virtual IDbSet<Person> Persons { get; set; }

        public virtual IDbSet<Planet> Planets { get; set; }

        public virtual IDbSet<SolarSystem> SolarSystems { get; set; }

        public virtual IDbSet<Star> Stars { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            //            //player - national team relations
            //            modelBuilder.Entity<Anomaly>()
            //            .HasRequired<Planet>(p => p.OriginPlanet)
            //            .WithMany()
            //            .WillCascadeOnDelete(false);
            //
            //            //player - club team relations
            //            modelBuilder.Entity<Anomaly>()
            //                .HasRequired<Planet>(p => p.TeleportPlanet)
            //                .WithMany()
            //                .WillCascadeOnDelete(false);
            //
            //            //player - club team relations
            //            modelBuilder.Entity<Star>()
            //                .HasRequired<SolarSystem>(p => p.SolarSystem)
            //                .WithMany()
            //                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Anomaly>()
               .HasMany(p => p.Persons)
               .WithMany(r => r.Anomalies)
               .Map(mc =>
               {
                   mc.MapLeftKey("AnomalyId");
                   mc.MapRightKey("PersonId");
                   mc.ToTable("AnomalyVictims");
               });
        }
    }
}