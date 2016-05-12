require 'csv'

module Classifications
  class DownloadExport < Operation
    filters[:current_user].options[:default] = nil
    integer :project_id

    def execute
      export = panoptes.get("/projects/#{project_id}/classifications_export")
      src    = export.fetch("media")[0].fetch("src")

      download_path = Rails.root.join("tmp", "classifications_export.csv.gz")
      csv_path = Rails.root.join("tmp", "classifications_export.csv")

      FileUtils.rm(download_path) if File.exist?(download_path)
      `wget -r -O #{download_path} "#{src}"`

      FileUtils.rm(csv_path) if File.exist?(csv_path)
      `gunzip #{Rails.root.join("tmp", "classifications_export.csv.gz")}`

      csv_path
    end
  end
end
