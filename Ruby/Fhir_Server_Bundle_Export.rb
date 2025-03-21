 Fetch FHIR resources from a FHIR server and export them to JSON files.
require 'json'
require 'net/http'
require 'fileutils'

# Define the FHIR resource types
resource_types = [
  "Patient", "HealthcareService", "Organization", "Location", "Practitioner",
  "PractitionerRole", "RelatedPerson", "Encounter", "AllergyIntolerance",
  "Condition", "Immunization", "Procedure", "Observation", "Medication",
  "MedicationRequest", "MedicationStatement", "Coverage", "Specimen",
  "CommunicationRequest", "Consent", "ServiceRequest", "Task"
]

# Define the FHIR server URL
fhir_server_url = "https://aucore.aidbox.beda.software/fhir"
output_directory = "C:/dump/output"
FileUtils.mkdir_p(output_directory)

resource_types.each do |resource|
  uri = URI("#{fhir_server_url}/#{resource}")
  puts "Fetching #{resource} from #{uri}"
  response = Net::HTTP.get(uri)
  json_response = JSON.pretty_generate(JSON.parse(response))

  output_file = File.join(output_directory, "output_#{resource}.json")
  File.write(output_file, json_response)

  puts "JSON data has been written to #{output_file}"
end

puts "FHIR resource export completed."

# Convert extracted bundle resources into individual JSON files
input_directory = "C:/dump/output"
output_directory = "C:/dump/input"
FileUtils.mkdir_p(output_directory)

resource_types.each do |resource|
  input_file = File.join(input_directory, "output_#{resource}.json")
  next unless File.exist?(input_file)

  json_content = JSON.parse(File.read(input_file))
  index = 1
  json_content["entry"].each do |entry|
    resource_data = JSON.pretty_generate(entry["resource"])
    resource_type = entry["resource"]["resourceType"]
    output_file = File.join(output_directory, "#{resource_type}-#{index}.json")
    File.write(output_file, resource_data)
    puts "Saved: #{output_file}"
    index += 1
  end
end

puts "All JSON resources have been extracted and saved."
