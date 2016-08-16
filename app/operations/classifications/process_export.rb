require 'csv'

module Classifications
  class ProcessExport < Operation
    filters[:panoptes].options[:default] = nil
    filters[:current_user].options[:default] = nil
    string :export_path

    def execute
      carto_transformer = CartoTransformer.new

      CSV.foreach(export_path, headers: true).with_index do |line, index|
        carto_transformer.process(line)

        if index % 10000 == 0
          # Do carto uploads in batches.
          carto_transformer.finalize
        end
      end

      classifications_counter.finalize
      carto_transformer.finalize
    end
  end
end
