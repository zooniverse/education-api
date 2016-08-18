module Kinesis
  class Create < Operation
    array :payload do
      hash strip: false
    end

    def execute
      ActiveRecord::Base.transaction do
        carto_transformer = CartoTransformer.new

        payload.each do |stream_event|
          Kinesis::CountClassification.run! stream_event
          carto_transformer.process(stream_event)
        end

        carto_transformer.finalize
      end
    end
  end
end
