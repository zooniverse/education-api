module Kinesis
  class Create < ActiveInteraction::Base
    array :payload do
      hash strip: false
    end

    def execute
      ActiveRecord::Base.transaction do
        payload.each do |stream_event|
          process(stream_event)
        end

        carto_transformer.finalize
      end
    end

    def process(stream_event)
      return unless stream_event.fetch("source") == "panoptes"
      return unless stream_event.fetch("type") == "classification"
      return unless stream_event.fetch("data").fetch("links").fetch("project") == "593"

      if stream_event.fetch("data").fetch("links").fetch("user").present? &&
         stream_event.fetch("data").fetch("metadata").fetch("user_group_ids").present?
        Kinesis::CountClassification.run! stream_event
      end

      carto_transformer.process(stream_event)
    end

    def carto_transformer
      @carto_transformer ||= CartoTransformer.new
    end
  end
end
