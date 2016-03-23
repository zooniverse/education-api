namespace :carto do
  desc "Uploads Panoptes Classifications to CartoDB"
  task :upload, [:filename] => [:environment] do |t, args|
    Classifications::ProcessExport.run!(export_path: args[:filename])
  end
end