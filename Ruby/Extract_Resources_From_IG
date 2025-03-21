# Fetch the FHIR IG package from the HL7 FHIR Package Registry.
# Download the package.tgz file.
# Extract and process all the FHIR resources.
require 'json'
require 'net/http'
require 'uri'
require 'fileutils'
require 'zlib'
require 'archive/tar/minitar'

# Define the FHIR IG package name (e.g., hl7.fhir.au.core)
ig_package_name = "hl7.fhir.au.core"
ig_version = "1.1.0-preview"  # Set a specific version if needed, or use "latest"

# Define FHIR Package Registry API URL
registry_url = "https://packages.simplifier.net/#{ig_package_name}"

# Determine the package version
if ig_version == "latest"
  puts "Fetching latest version for #{ig_package_name}..."
  uri = URI.parse(registry_url)
  response = Net::HTTP.get(uri)
  package_info = JSON.parse(response)
  if package_info["versions"].nil? || package_info["versions"].empty?
    abort("No versions found for package: #{ig_package_name}")
  end
  ig_version = package_info["versions"].last  # Get latest version
end

# Construct the download URL
download_url = "#{registry_url}/#{ig_version}"
download_path = File.join(Dir.tmpdir, "package.tgz")

puts "Downloading IG package: #{download_url}..."
File.write(download_path, Net::HTTP.get(URI.parse(download_url)))

# Check if the file exists
abort("Failed to download FHIR IG package.") unless File.exist?(download_path)

# Extract package.tgz
temp_dir = File.join(Dir.tmpdir, "FHIR_IG_Extract")
FileUtils.mkdir_p(temp_dir)
puts "Extracting package..."
Zlib::GzipReader.open(download_path) do |gz|
  Archive::Tar::Minitar.unpack(gz, temp_dir)
end

# Define extracted 'package' directory
package_dir = File.join(temp_dir, "package")
abort("Extraction failed.") unless Dir.exist?(package_dir)

# Read all FHIR resource files
resource_files = Dir.glob(File.join(package_dir, "*.json"))

# Parse resources
fhir_resources = resource_files.map do |file|
  JSON.parse(File.read(file))
end

# Output summary
puts "Total resources found: #{fhir_resources.size}"
fhir_resources.each do |resource|
  puts "Resource Type: #{resource['resourceType']}, ID: #{resource['id']}"
end

# Save to file
output_file = File.join(Dir.tmpdir, "FHIR_Resources.json")
File.write(output_file, JSON.pretty_generate(fhir_resources))
puts "FHIR resources saved to: #{output_file}"

# Cleanup (optional)
# FileUtils.rm_rf(temp_dir)
