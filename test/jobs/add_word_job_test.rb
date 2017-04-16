# frozen_string_literal: true

require 'test_helper'

class AddWordJobTest < ActiveJob::TestCase
  test 'add a new in background' do
    assert_performed_jobs 1 do
      AddWordJob.perform_later(amanda_uid, 'queue')
    end
  end
end
