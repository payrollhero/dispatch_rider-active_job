require 'spec_helper'
require 'dispatch_rider/active_job'

describe DispatchRider::ActiveJob do
  it "should have a VERSION constant" do
    subject.const_get('VERSION').should_not be_empty
  end
end
