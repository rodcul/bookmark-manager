require 'securerandom'
require 'rest-client'

get '/users/new' do
  # note the view is in views/users/new.erb
  # we need the quotes because otherwise
  # ruby would divide the symbol :users by the
  # variable new (which makes no sense)
  @user = User.new
  erb :'users/new'
end

post '/users' do
  @user = User.create(email: params[:email],
                      password: params[:password],
                      password_confirmation: params[:password_confirmation])

  if @user.save
    session[:user_id] = @user.id
    redirect to('/')
  else
    flash.now[:errors] = @user.errors.full_messages
    erb :'users/new'
  end
end

get '/users/reset_password/send_email' do
  erb :'users/reset_password/send_email'
end

post '/users/reset_password/send_email' do
  flash[:notice] = 'Password recovery e-mail sent!'
  email = params[:email]
  user = User.first(email: email)
  # avoid having to memorise ascii codes
  user.password_token = random_string = SecureRandom.hex
  user.password_token_timestamp = Time.now
  user.save
  erb :'users/reset_password/send_email'
end

get '/users/reset_password/:token' do
  @token = params[:token]
  user = User.first(password_token: @token)
  erb :'users/reset_password/new'
end

post '/users/reset_password' do
  token = params[:token]
  user = User.first(password_token: token)
  if user.password_token_timestamp >= DateTime.now - (1 * 60 * 60)
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    user.save
    flash[:notice] = 'Password updated, please login with your new password'
    redirect to '/sessions/new'
  else
    flash[:notice] = 'Your password did not get saved, try again'
    redirect to '/users/reset_password/send_email'
  end
end
