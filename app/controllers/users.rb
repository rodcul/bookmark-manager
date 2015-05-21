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
  @email = params[:email]
  user = User.first(email: @email)
  if user.nil?
    flash[:notice] = 'Unknown e-mail address, try again'
    redirect to '/users/reset_password/send_email'
  else
    # avoid having to memorise ascii codes
    token = SecureRandom.hex
    user.password_token = token
    user.password_token_timestamp = Time.now
    user.save
    flash[:notice] = 'Password recovery e-mail sent!'
    redirect to '/email/' + token
  end
end

get '/users/reset_password/:token' do
  @token = params[:token]
  user = User.first(password_token: @token)
  if user.nil?
    flash[:notice] = 'Invalid token (already used or expired, please resend confirmation e-mail)'
    redirect to '/'
  else
    erb :'users/reset_password/new'
  end
end

post '/users/reset_password' do
  token = params[:token]
  user = User.first(password_token: token)
  if user.password_token_timestamp >= DateTime.now - (1 * 60 * 60)
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    user.save
    flash[:notice] = 'New password saved, please login'
    redirect to '/sessions/new'
  else
    flash[:notice] = 'Your password did not get saved, try again'
    redirect to '/users/reset_password/send_email'
  end
end
