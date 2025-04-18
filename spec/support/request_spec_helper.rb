# spec/support/request_spec_helper.rb
module RequestSpecHelper
  include Warden::Test::Helpers

  def sign_in(user)
    login_as(user, scope: :user)
  end

  def sign_out
    logout(:user)
  end
end