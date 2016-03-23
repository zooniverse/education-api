require 'csv'

module Classifications
  class ProcessExport < Operation
    filters[:panoptes].options[:default] = nil
    filters[:current_user].options[:default] = nil
    string :export_path

    def execute
      classifications_counter = ClassificationsCounter.new
      carto_transformer = CartoTransformer.new

      CSV.foreach(export_path, headers: true) do |line|
        next unless line["user_id"]
        classifications_counter.process(line)
        carto_transformer.process(line)
      end

      classifications_counter.finalize
      carto_transformer.finalize
    end
  end
end
