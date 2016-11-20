namespace MassDefect.ConsoleXmlClient
{
    using System;
    using System.Xml.Linq;
    using System.Xml.XPath;
    using Data;
    using Models;

    public class Startup
    {
        public static void Main(string[] args)
        {
            var xml = XDocument.Load(Paths.NewAnomaliesPath);
            var anomalies = xml.XPathSelectElements("anomalies/anomaly");
            var context = new MassDefectContext();

            foreach (var anomaly in anomalies)
            {
                ImportAnomalyVictims(anomaly, context);
            }

        }

        private static void ImportAnomalyVictims(XElement anomaly, MassDefectContext context)
        {
            var originPlanetName = anomaly.Attribute("origin-planet");
            var teleportPlanetName = anomaly.Attribute("teleport-planet");

            if (originPlanetName == null || teleportPlanetName == null)
            {
                Console.WriteLine("Error: Invalid data.");
                return;
            }

            var anomalyEntity = new Anomaly()
            {
                OriginPlanet = GetPlanetByName(originPlanetName.Value, context),
                TeleportPlanet = GetPlanetByName(teleportPlanetName.Value, context)
            };

            if (anomalyEntity.TeleportPlanet == null || anomalyEntity.OriginPlanet == null)
            {
                Console.WriteLine("Error: Invalid data.");
                return;
            }

            context.Anomalies.Add(anomalyEntity);
            Console.WriteLine($"Successfully imported anomaly.");

            var victims = anomaly.XPathSelectElements("victims/victim");
            foreach (var victim in victims)
            {
                ImportVictim(victim, context, anomalyEntity);
            }

            context.SaveChanges();

        }

        private static void ImportVictim(XElement victim, MassDefectContext context, Anomaly anomalyEntity)
        {
            var name = victim.Attribute("name");
            if (name == null)
            {
                Console.WriteLine("Error: Invalid data.");
                return;
            }

            var personEntity = GetPersonByName(name.Value, context);
            if (personEntity == null)
            {
                Console.WriteLine("Error: Invalid data.");
                return;
            }

            anomalyEntity.Persons.Add(personEntity);
        }

        private static Person GetPersonByName(string personName, MassDefectContext context)
        {
            var persons = context.Persons;
            foreach (var person in persons)
            {
                if (person.Name == personName)
                {
                    return person;
                }
            }

            return null;
        }

        private static Planet GetPlanetByName(string planetName, MassDefectContext context)
        {
            var planets = context.Planets;
            foreach (var planet in planets)
            {
                if (planet.Name == planetName)
                {
                    return planet;
                }
            }

            return null;
        }
    }
}
