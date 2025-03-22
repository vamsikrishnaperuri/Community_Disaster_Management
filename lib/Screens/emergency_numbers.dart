class EmergencyNumber {
  final String name;
  final String phoneNumber;
  // final String logoAsset; // Path to your logo image asset
  final String description; // Short description (optional)

  EmergencyNumber({
    required this.name,
    required this.phoneNumber,
    // required this.logoAsset,
    this.description = "",
  });
}

final List<EmergencyNumber> emergencyNumbers = [
  EmergencyNumber(
    name: "Ambulance",
    phoneNumber: "108",
    description: "Emergency medical services",
  ),
  EmergencyNumber(
    name: "Cyclone Evacuation & Relief Helpline",
    phoneNumber: "1077",
    description: "Support for cyclone-related evacuations",
  ),
  EmergencyNumber(
    name: "District Disaster Management Helpline",
    phoneNumber: "1077",
    description: "Local disaster-related emergency support",
  ),
  EmergencyNumber(
    name: "Electricity Emergency Helpline",
    phoneNumber: "1912",
    description: "For power outages due to cyclones",
  ),
  EmergencyNumber(
    name: "Emergency Medical & Disaster Response",
    phoneNumber: "108",
    description: "Medical emergency and disaster relief services",
  ),
  EmergencyNumber(
    name: "Environmental Emergency",
    phoneNumber: "1075",
    description: "For forest and air pollution control",
  ),
  EmergencyNumber(
    name: "Fire Brigade for Forest Fires",
    phoneNumber: "101",
    description: "For forest fire emergencies",
  ),
  EmergencyNumber(
    name: "Fire Department",
    phoneNumber: "101",
    description: "For fire-related emergencies",
  ),
  EmergencyNumber(
    name: "Fisheries & Marine Emergency",
    phoneNumber: "1554",
    description: "For fishermen & coastal safety during storms",
  ),
  EmergencyNumber(
    name: "Flood & Earthquake Helpline",
    phoneNumber: "1078",
    description: "Support for victims of floods, earthquakes, and landslides",
  ),
  EmergencyNumber(
    name: "Forest & Wildlife Protection Helpline",
    phoneNumber: "1926",
    description: "For reporting wildlife-related emergencies",
  ),
  EmergencyNumber(
    name: "Health Helpline for Disaster-Affected Areas",
    phoneNumber: "104",
    description: "Health assistance during and after disasters",
  ),
  EmergencyNumber(
    name: "Heat Wave & Cold Wave Assistance",
    phoneNumber: "1079",
    description: "Support for extreme weather conditions",
  ),
  EmergencyNumber(
    name: "Indian Meteorological Department (IMD)",
    phoneNumber: "18001801717",
    description: "Weather updates & alerts",
  ),
  EmergencyNumber(
    name: "Medical Emergency During Disasters",
    phoneNumber: "102",
    description: "Ambulance services for disaster-affected areas",
  ),
  EmergencyNumber(
    name: "Meteorological Disaster Alert Helpline",
    phoneNumber: "1938",
    description: "Early warnings on cyclones & storms",
  ),
  EmergencyNumber(
    name: "National Disaster Management Helpline",
    phoneNumber: "1070",
    description: "Emergency assistance during natural disasters",
  ),
  EmergencyNumber(
    name: "National Emergency Helpline",
    phoneNumber: "112",
    description: "All-in-one emergency response service",
  ),
  EmergencyNumber(
    name: "National Forest Fire Helpline",
    phoneNumber: "18001801551",
    description: "Support for forest fire emergencies",
  ),
  EmergencyNumber(
    name: "NDRF Control Room, Delhi",
    phoneNumber: "9711077372",
    description: "Immediate disaster response & coordination",
  ),
  EmergencyNumber(
    name: "NDRF Emergency Operations Center",
    phoneNumber: "01124363260",
    description: "For disaster relief support & emergency assistance",
  ),
  EmergencyNumber(
    name: "NDRF Headquarters Helpline",
    phoneNumber: "01123438252",
    description: "Official disaster management contact",
  ),
  EmergencyNumber(
    name: "NDRF Quick Response Team Contact",
    phoneNumber: "01124363261",
    description: "For immediate disaster response & rescue operations",
  ),
  EmergencyNumber(
    name: "NDRF Rescue Coordination",
    phoneNumber: "9711077371",
    description: "Managing rescue teams & operations",
  ),
  EmergencyNumber(
    name: "Police Emergency",
    phoneNumber: "100",
    description: "For reporting crimes and seeking police assistance",
  ),
  EmergencyNumber(
    name: "Railway Emergency Helpline",
    phoneNumber: "103",
    description: "For railway-related accidents and emergencies",
  ),
  EmergencyNumber(
    name: "Wildlife Rescue Helpline",
    phoneNumber: "1098",
    description: "For reporting animal distress & illegal poaching",
  ),

];