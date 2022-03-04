commit_id_file = Rails.root.join 'commit_id.txt'

if File.exist? commit_id_file
  Rails.application.revision = File.read(commit_id_file).chomp
else
  Rails.application.revision = 'N/A'
end
