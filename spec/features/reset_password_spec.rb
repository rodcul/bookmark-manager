feature 'User resets password' do

  before(:each) do
    User.create(email: 'test@test.com',
                password: 'test',
                password_confirmation: 'test')

  end

  xscenario 'Sending password reset email' do
    visit '/'
    click_link 'Login'
    click_link 'Reset password'
    fill_in :email, with: 'test@test.com'
    click_button 'Reset Password'
    expect(page).to have_content('Password e-mail sent, check your inbox!')
  end

  scenario 'FAIL: Sending password reset email (incorrect email)' do
    visit '/'
    click_link 'Login'
    click_link 'Reset password'
    fill_in :email, with: 'error@test.com'
    click_button 'Reset Password'
    expect(page).to have_content('Unknown e-mail address, try again')
  end

  xscenario 'Change password by clicking on link' do
    user = User.first(email: 'test@test.com')
    token = user.password_token
    visit '/users/reset_password' + token
    fill_in :password, with: 'newpassword'
    fill_in :password_confirmation, with: 'newpassword'
    click_button 'Reset password'
    expect(page).to have_content('Password updated, please login with your new password!')
  end
end
