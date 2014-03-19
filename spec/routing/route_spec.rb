require 'spec_helper'

describe Tribunals::Application.routes do
  include RSpec::Rails::RequestExampleGroup

  it "redirects from / to /utiac" do
    get '/'
    response.should redirect_to(decisions_path)
  end

  it "redirects from /utiac/decisions to /utiac" do
    get '/utiac/decisions'
    response.should redirect_to(decisions_path)
  end

  it "redirects from /utiac/decisions/decision1 to /utiac/decision1" do
    get '/utiac/decisions/decision1'
    response.should redirect_to(decision_path('decision1'))
  end

  describe "EAT routes" do
    it "should render EAT's index routes" do
      expect(get: "/eat").to route_to(controller: 'eat_decisions', action: 'index')
    end

    it "should render EAT's show routes" do
      expect(get: "/eat/1").to route_to(controller: 'eat_decisions', action: 'show', id: '1')
    end
  end

  describe "FTT routes" do
    it "should render FTT's index routes" do
      expect(get: "/ftt-tax").to route_to(controller: 'ftt_decisions', action: 'index')
    end

    it "should render FTT's show routes" do
      expect(get: "/ftt-tax/1").to route_to(controller: 'ftt_decisions', action: 'show', id: '1')
    end
  end

  describe "AAC routes" do
    it "should render AAC's index routes" do
      expect(get: "/utaac").to route_to(controller: 'aac_decisions', action: 'index')
    end

    it "should render AAC's show routes" do
      expect(get: "/utaac/1").to route_to(controller: 'aac_decisions', action: 'show', id: '1')
    end
  end
end
