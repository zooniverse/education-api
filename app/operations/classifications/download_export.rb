require 'csv'

module Classifications
  class DownloadExport < Operation
    filters[:current_user].options[:default] = nil
    integer :project_id

    def execute
      export = panoptes.get("/projects/#{project_id}/classifications_export")
      src    = export.fetch("media")[0].fetch("src")

      `wget -O #{Rails.root.join("tmp", "classifications_export.csv.gz")} "#{src}"`
      `gunzip #{Rails.root.join("tmp", "classifications_export.csv.gz")}`

      Rails.root.join("tmp", "classifications_export.csv")
    end
  end
end
