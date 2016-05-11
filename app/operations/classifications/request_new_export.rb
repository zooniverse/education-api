module Classifications
  class RequestNewExport < Operation
    filters[:current_user].options[:default] = nil
    integer :project_id

    def execute
      panoptes.create_classifications_export(project_id)
    end
  end
end
