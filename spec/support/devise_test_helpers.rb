# spec/support/devise_test_helpers.rb
module DeviseTestHelpers
  def login_as(user)
    visit new_user_session_path
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end
end

RSpec.configure do |config|
  config.include DeviseTestHelpers, type: :system
end