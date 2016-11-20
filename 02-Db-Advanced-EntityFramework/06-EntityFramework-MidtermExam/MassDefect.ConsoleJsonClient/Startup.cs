namespace MassDefect.ConsoleJsonClient
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using Newtonsoft.Json;
    using DTO;
    using Data;
    using Models;

    public class Startup
    {
        public static void Main()
        {
            ImportSolarSystems();
            ImportStars();
            ImportPlanets();
            ImportPersons();
            ImportAnomalies();
            ImportAnomalyVictims();
        }

        private static void ImportSolarSystems()
        {
            var context = new MassDefectContext();
            var json = File.ReadAllText(Paths.SolarSystemPath);
            var solarSystems = JsonConvert.DeserializeObject<IEnumerable<SolarSystemDTO>>(json);
            foreach (var solarSystem in solarSystems)
            {
                if (solarSystem.Name == null)
                {
                    Console.WriteLine("Error: Invalid data.");
                    continue;
                }

                var system = new SolarSystem()
                {
                    Name = solarSystem.Name
                };

                context.SolarSystems.Add(system);
                context.SaveChanges();
                Console.WriteLine($"Successfully imported Solar System {solarSystem.Name}.");
            }
        }

        private static void ImportStars()
        {
            var context = new MassDefectContext();
            var json = File.ReadAllText(Paths.StarsPath);
            var stars = JsonConvert.DeserializeObject<IEnumerable<StarDTO>>(json);
            foreach (var star in stars)
            {
                if (star.Name == null || star.SolarSystem == null)
                {
                    Console.WriteLine("Error: Invalid data.");
                    continue;
                }

                var starEntity = new Star()
                {
                    Name = star.Name,
                    SolarSystem = GetSolarSystemByName(star.SolarSystem, context)
                };

                if (starEntity.SolarSystem == null)
                {
                    Console.WriteLine("Error: Invalid data.");
                    continue;
                }

                context.Stars.Add(starEntity);
                context.SaveChanges();
                Console.WriteLine($"Successfully imported Star {starEntity.Name}.");
            }
        }

        private static void ImportPlanets()
        {
            var context = new MassDefectContext();
            var json = File.ReadAllText(Paths.PlanetsPath);
            var planets = JsonConvert.DeserializeObject<IEnumerable<PlanetDTO>>(json);
            foreach (var planet in planets)
            {
                if (planet.Name == null || planet.SolarSystem == null || planet.Sun == null)
                {
                    Console.WriteLine("Error: Invalid data.");
                    continue;
                }

                var planetEntity = new Planet()
                {
                    Name = planet.Name,
                    SolarSystem = GetSolarSystemByName(planet.SolarSystem, context),
                    Sun = GetStarByName(planet.Sun, context)
                };

                if (planetEntity.SolarSystem == null || planetEntity.Sun == null)
                {
                    Console.WriteLine("Error: Invalid data.");
                    continue;
                }

                context.Planets.Add(planetEntity);
                context.SaveChanges();
                Console.WriteLine($"Successfully imported Planet {planetEntity.Name}.");
            }
        }

        private static void ImportPersons()
        {
            var context = new MassDefectContext();
            var json = File.ReadAllText(Paths.PersonsPath);
            var persons = JsonConvert.DeserializeObject<IEnumerable<PersonDTO>>(json);
            foreach (var person in persons)
            {
                if (person.Name == null || person.HomePlanet == null)
                {
                    Console.WriteLine("Error: Invalid data.");
                    continue;
                }

                var personEntity = new Person()
                {
                    Name = person.Name,
                    HomePlanet = GetPlanetByName(person.HomePlanet, context)
                };

                if (personEntity.HomePlanet == null)
                {
                    Console.WriteLine("Error: Invalid data.");
                    continue;
                }

                context.Persons.Add(personEntity);
                context.SaveChanges();
                Console.WriteLine($"Successfully imported Person {personEntity.Name}.");
            }
        }

        private static void ImportAnomalies()
        {
            var context = new MassDefectContext();
            var json = File.ReadAllText(Paths.AnomaliesPath);
            var anomalies = JsonConvert.DeserializeObject<IEnumerable<AnomalyDTO>>(json);
            foreach (var anomaly in anomalies)
            {
                if (anomaly.TeleportPlanet == null || anomaly.OriginPlanet == null)
                {
                    Console.WriteLine("Error: Invalid data.");
                    continue;
                }

                var anomalyEntity = new Anomaly()
                {
                    OriginPlanet = GetPlanetByName(anomaly.OriginPlanet, context),
                    TeleportPlanet = GetPlanetByName(anomaly.TeleportPlanet, context)
                };

                if (anomalyEntity.TeleportPlanet == null || anomalyEntity.OriginPlanet == null)
                {
                    Console.WriteLine("Error: Invalid data.");
                    continue;
                }

                context.Anomalies.Add(anomalyEntity);
                context.SaveChanges();
                Console.WriteLine($"Successfully imported anomaly.");

            }
        }

        private static void ImportAnomalyVictims()
        {
            var context = new MassDefectContext();
            var json = File.ReadAllText(Paths.AnomaliesVictimsPath);
            var anomalyVictims = JsonConvert.DeserializeObject<IEnumerable<AnomalyVictimsDTO>>(json);

            foreach (var anomalyVictim in anomalyVictims)
            {
                if (anomalyVictim.Id == null || anomalyVictim.Person == null) //TYPES? string/int
                {
                    Console.WriteLine("Error: Invalid data.");
                    continue;
                }

                var anomalyEntity = GetAnomalyById(anomalyVictim.Id, context);
                var personEntity = GetPersonByName(anomalyVictim.Person, context);

                if (anomalyEntity == null || personEntity == null)
                {
                    Console.WriteLine("Error: Invalid data.");
                    continue;
                }

                anomalyEntity.Persons.Add(personEntity);
                personEntity.Anomalies.Add(anomalyEntity);
                context.SaveChanges();
            }
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

        private static Anomaly GetAnomalyById(int? anomalyId, MassDefectContext context)
        {
            var anomalies = context.Anomalies;
            foreach (var anomaly in anomalies)
            {
                if (anomaly.Id == anomalyId)
                {
                    return anomaly;
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

        private static SolarSystem GetSolarSystemByName(string solarSystemName, MassDefectContext context)
        {
            var systems = context.SolarSystems;
            foreach (SolarSystem solarSystem in systems)
            {
                if (solarSystem.Name == solarSystemName)
                {
                    return solarSystem;
                }
            }

            return null;
        }

        private static Star GetStarByName(string starName, MassDefectContext context)
        {
            var stars = context.Stars;
            foreach (var star in stars)
            {
                if (star.Name == starName)
                {
                    return star;
                }
            }

            return null;
        }
    }
}
