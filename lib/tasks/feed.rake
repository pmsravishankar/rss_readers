namespace :feed do
  desc "RSS Reader database setup..."
  task :setup => ["db:drop:all", "db:create:all", "db:migrate"]
end
