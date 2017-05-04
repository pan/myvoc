# frozen_string_literal: true

require 'test_helper'

class AddWordJobTest < ActiveJob::TestCase
  test 'add a new in background' do
    skip 'job was finished too fast'
    task = tester_amanda.tasks.create
    assert_performed_jobs 1 do
      bg = AddWordJob.perform_later(amanda_uid, 'queue')
      task.jobs.create(job_id: bg.job_id, word: 'queue')
    end
  end
end
