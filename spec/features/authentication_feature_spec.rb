require 'spec_helper'

feature 'User Authentication' do

  context 'with standard access to tribunal' do
    scenario 'User can sign in ' do

    end

    scenario 'Super admin can sign in' do

    end

    scenario 'User cannot switch to tribunal without access' do

    end
  end

  context 'without standard access to tribunal' do
    scenario 'User cannot sign in' do

    end
  end

  context 'with super admin access to tribunal' do
    scenario 'User can sign in' do

    end

    scenario 'User can access all tribunals' do

    end
  end

end