namespace MassDefect.XmlExportConsoleClient
{
    using System.Linq;
    using System.Xml.Linq;
    using Data;

    public class Startup
    {
        public static void Main()
        {
            var context = new MassDefectContext();
            var exportedAnomalies = context.Anomalies
                .Select(a => new
                {
                    id = a.Id,
                    originPlanetName = a.OriginPlanet.Name,
                    teleportPlanetName = a.TeleportPlanet.Name,
                    victims = a.Persons.Select(x => x.Name).ToList()
                })
                .OrderBy(x => x.id);

            var xmlDocument = new XElement("anomalies");
            foreach (var exportedAnomaly in exportedAnomalies)
            {
                var anomalyNode = new XElement("anomaly");
                anomalyNode.Add(new XAttribute("id", exportedAnomaly.id));
                anomalyNode.Add(new XAttribute("origin-planet", exportedAnomaly.originPlanetName));
                anomalyNode.Add(new XAttribute("teleport-planet", exportedAnomaly.teleportPlanetName));

                var victimsNode = new XElement("victims");
                foreach (var victim in exportedAnomaly.victims)
                {
                    var victimNode = new XElement("victim");
                    victimNode.Add(new XAttribute("name", victim));
                    victimsNode.Add(victimNode);
                }

                anomalyNode.Add(victimsNode);
                xmlDocument.Add(anomalyNode);
            }

            xmlDocument.Save("../../anomalies.xml");
        }
    }
}