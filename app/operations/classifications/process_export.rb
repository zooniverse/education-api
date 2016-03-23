require 'csv'

module Classifications
  class ProcessExport < Operation
    filters[:current_user].options[:default] = nil
    string :export_path

    def execute
      classifications_counter = ClassificationsCounter.new

      CSV.foreach(export_path, headers: true) do |line|
        next unless line["user_id"]
        classifications_counter.process(line)
        carto_uploader.process(line)
      end

      classifications_counter.finalize
      carto_uploader.finalize
    end
  end
end
