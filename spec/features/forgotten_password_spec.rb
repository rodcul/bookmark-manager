# require_relative 'helpers/session'
# include SessionHelpers
#
# feature 'user signs out' do
#
#   before(:each) do
#     User.create(email: 'test@test.com',
#                 password: 'test',
#                 password_confirmation: 'test')
#   end
#
#   scenario 'sending password recovery email' do
#     visit('/sessions/new')
#     click_link('Reset password')
#     fill_in('email', with: 'test@test.com')
#     click_button('Reset password')
#     expect(page).to have_content('Password recovery e-mail sent!')
#   end
#
# end
