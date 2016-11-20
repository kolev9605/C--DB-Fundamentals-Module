namespace MassDefect.JsonExportConsoleClient
{
    using System.IO;
    using System.Linq;
    using Data;
    using Newtonsoft.Json;

    public class Startup
    {
        public static void Main()
        {
            var context = new MassDefectContext();
            ExportPlanetsWhichAreNotAnomalyOrigins(context);
            ExportPeopleWhichHaveNotBeenVictims(context);
            ExportTopAnomaly(context);
        }

        private static void ExportPlanetsWhichAreNotAnomalyOrigins(MassDefectContext context)
        {
            var exportedPlanets = context.Planets
                .Where(x => !x.OriginAnomalies.Any())
                .Select(p => new
                {
                    name = p.Name
                });

            var planetsAsJson = JsonConvert.SerializeObject(exportedPlanets, Formatting.Indented);
            File.WriteAllText("../../planets.json", planetsAsJson);
        }

        private static void ExportPeopleWhichHaveNotBeenVictims(MassDefectContext context)
        {
            var persons = context.Persons
                .Where(p => !p.Anomalies.Any())
                .Select(p => new
                {
                    name = p.Name,
                    homePlanet = new
                    {
                        name = p.HomePlanet.Name
                    }
                });

            var personsAsJson = JsonConvert.SerializeObject(persons, Formatting.Indented);
            File.WriteAllText("../../people.json", personsAsJson);
        }

        private static void ExportTopAnomaly(MassDefectContext context)
        {
            var anomalies = context.Anomalies
                .OrderByDescending(x => x.Persons.Count)
                .Take(1)
                .Select(a => new
                {
                    id = a.Id,
                    originPlanet = new
                    {
                        name = a.OriginPlanet.Name
                    },
                    teleportPlanet = new
                    {
                        name = a.TeleportPlanet.Name
                    },
                    victimsCount = a.Persons.Count
                });

            var anomaliesAsJson = JsonConvert.SerializeObject(anomalies, Formatting.Indented);
            File.WriteAllText("../../anomaly.json", anomaliesAsJson);
        }
    }
}