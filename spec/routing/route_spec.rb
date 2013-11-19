require 'spec_helper'

describe Tribunals::Application.routes do
  include RSpec::Rails::RequestExampleGroup

  it "redirects from / to /utiac/decisions" do
    get '/'
    response.should redirect_to(decisions_path)
  end

  it "redirects from /utiac to /utiac/decisions" do
    get '/utiac'
    response.should redirect_to(decisions_path)
  end

  it "should render EAT's index routes" do
    expect(get: "/eat").to route_to(controller: 'eat_decisions', action: 'index')
  end

  it "should render EAT's show routes" do
    expect(get: "/eat/1").to route_to(controller: 'eat_decisions', action: 'show', id: '1')
  end
end
