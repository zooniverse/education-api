revision_file = Rails.root.join 'public/commit.txt'

if File.exists?(revision_file)
  Rails.application.revision = File.read(revision_file).chomp
end