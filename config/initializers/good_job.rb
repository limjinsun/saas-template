# config/initializers/good_job.rb
Rails.application.configure do
  config.good_job.execution_mode = :external
  config.good_job.max_threads = 5 # This means "One worker process can do 5 things at once"

  config.good_job.enable_cron = false
  config.good_job.cron = {}

  config.good_job.preserve_job_records = true
  config.good_job.cleanup_preserved_jobs_before_seconds_ago = 90.days
end
