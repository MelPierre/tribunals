require 'spec_helper'

describe Tribunals::Application.config do
  it "sets cookie only on the path" do
    subject.session_store.should == ActionDispatch::Session::CookieStore
    subject.session_options.should == {cookie_only: true, key: 'TSID', path: '/', httponly: true}
  end
end
