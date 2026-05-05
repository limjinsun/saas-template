class ApplicationJob < ActiveJob::Base
  include GoodJob::ActiveJobExtensions::Concurrency

  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  around_perform do |job, block|
    if job.arguments.any? && job.arguments.last.is_a?(Hash)
      tid = job.arguments.last[:tenant_id] # 1. Look for the bridge (tenant_id in args)
    end

    if tid
      Current.tenant = Tenant.find(tid) # 2. Re-establish context in the "Job World"
    end

    block.call
  ensure
    Current.reset
  end
end
