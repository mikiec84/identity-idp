module ControllerHelper
  def sign_in_as_admin
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in FactoryGirl.create(:user, :admin, :signed_up)
  end

  def sign_in_as_user
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in FactoryGirl.create(:user, :signed_up)
  end

  # rubocop:disable Style/PredicateName
  def has_before_filters(*names)
    expect(controller).to have_filters(:before, *names)
  end
  # rubocop:enable Style/PredicateName

  def sign_in_as_tech_user
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in create(:user, :signed_up, :tech_support)
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include ControllerHelper, type: :controller

  config.before(:example, devise: true, type: :controller) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end
end
