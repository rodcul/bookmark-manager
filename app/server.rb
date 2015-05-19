require 'sinatra'
require 'data_mapper'
require './lib/link' # this needs to be done after datamapper is initialised
require './lib/tag'
require './lib/user'
require_relative 'helpers/application'
require_relative 'data_mapper_setup'
require 'rack-flash'

enable :sessions
set :session_secret, 'nuOkCokOb'
use Rack::Flash
use Rack::MethodOverride

get '/' do
  @links = Link.all
  erb :index
end

post '/links' do
  url = params['url']
  title = params['title']
  tags = params['tags'].split(' ').map do |tag|
    # this will either find this tag or create
    # it if it doesn't exist already
    Tag.first_or_create(text: tag)
  end
  Link.create(url: url, title: title, tags: tags)
  redirect to('/')
end

get '/tags/:text' do
  tag = Tag.first(text: params[:text])
  @links = tag ? tag.links : []
  erb :index
end

get '/users/new' do
  # note the view is in views/users/new.erb
  # we need the quotes because otherwise
  # ruby would divide the symbol :users by the
  # variable new (which makes no sense)
  @user = User.new
  erb :'users/new'
end

get '/sessions/new' do
  erb :'sessions/new'
end

post '/sessions' do
  email = params[:email]
  password = params[:password]
  user = User.authenticate(email, password)
  if user
    session[:user_id] = user.id
    redirect to '/'
  else
    flash[:errors] = ['The email or password is incorrect']
    erb :'sessions/new'
  end
end

delete '/sessions' do
  flash[:notice] = 'Good bye!'
  session[:user_id] = nil
  redirect to '/'

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
