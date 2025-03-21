items = [
  "Patient", "HealthcareService", "Organization", "Location", "Practitioner", "PractitionerRole",
  "RelatedPerson", "Encounter", "AllergyIntolerance", "Condition", "Immunization", "Procedure",
  "Observation", "Medication", "MedicationRequest", "MedicationStatement", "Coverage", "Specimen",
  "CommunicationRequest", "Consent", "ServiceRequest", "Task"
]

items.each do |item|
  command = "C:\\dump\\TestDataClient.exe #{item} C:\\dump\\input https://aucore.aidbox.beda.software/fhir basic default"
  system(command)
end
