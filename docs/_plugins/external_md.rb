require 'find'
require 'fileutils'

module ExternalMD
  class Generator < Jekyll::Generator
    def generate(site)
      # Define source directories
      basic_setup_source = File.expand_path("../basic-setup", site.source)
      advanced_conversion_source = File.expand_path("../advanced-conversion", site.source)

      # Define destination directories
      include_destination = File.expand_path("./_includes", site.source) # Changed to _include
      advanced_conversion_destination = File.expand_path("./_advanced-conversion", site.source)

      # Ensure destination directories exist
      FileUtils.mkdir_p(include_destination) unless File.directory?(include_destination) # Updated for _include
      FileUtils.mkdir_p(advanced_conversion_destination) unless File.directory?(advanced_conversion_destination)

      # Process each source directory
      process_directory(basic_setup_source, include_destination, site, true) # Added flag for basic setup
      process_directory(advanced_conversion_source, advanced_conversion_destination, site, false)
    end

    private

    def process_directory(source_dir, destination_dir, site, is_basic_setup)
      Find.find(source_dir) do |path|
        if File.basename(path) == "README.md"
          file = is_basic_setup ? "basic_setup.md" : File.basename(path) # Change file name if basic setup
          destination_path = File.join(destination_dir, file) # Use new file name
          puts "Copying #{file} from #{source_dir} to #{destination_dir}"
          FileUtils.cp(path, destination_path)
          dir = File.dirname(path).gsub(source_dir, '')
          site.static_files << Jekyll::StaticFile.new(site, site.source, dir, file)
        end
      end
    end
  end
end
