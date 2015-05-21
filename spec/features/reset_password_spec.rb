feature 'User forgotten password' do

  before(:each) do
    User.create(email: 'test@test.com',
                password: 'test',
                password_confirmation: 'test',
                password_token: 'test-token',
                password_token_timestamp: Time.now)

  end

  xscenario 'Sending password reset email' do
    visit '/'
    click_link 'Login'
    click_link 'Reset password'
    fill_in :email, with: 'test@test.com'
    click_button 'Reset Password'
    expect(page).to have_content('Password e-mail sent, check your inbox!')
  end

  scenario 'reset by clicking on link' do
    visit '/users/reset_password/test-token'
    fill_in :password, with: 'newpassword'
    fill_in :password_confirmation, with: 'newpassword'
    click_button 'Reset password'
    expect(page).to have_content('New password saved, please login')
  end

  scenario 'FAIL: Sending password reset email (incorrect email)' do
    visit '/'
    click_link 'Login'
    click_link 'Reset password'
    fill_in :email, with: 'error@test.com'
    click_button 'Reset Password'
    expect(page).to have_content('Unknown e-mail address, try again')
  end

  scenario 'FAIL: trying to use same token twice' do
    visit '/users/reset_password/test-token'
    fill_in :password, with: 'newpassword'
    fill_in :password_confirmation, with: 'newpassword'
    click_button 'Reset password'
    visit '/users/reset_password/test-token'
    expect(page).to have_content('Invalid token')
  end

  scenario 'FAIL: expired token' do
    user = User.first(password_token: 'test-token')
    user.password_token_timestamp = (Time.now - (2 * 60 * 60))
    user.save
    visit '/users/reset_password/test-token'
    expect(page).to have_content('Invalid token')
  end

  scenario 'FAIL: Invalid token' do
    visit '/users/reset_password/invalid-token'
    expect(page).to have_content('Invalid token')
  end

end
