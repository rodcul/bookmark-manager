require 'rest-client'

API_KEY = ENV['MAILGUN_API_KEY']
API_URL = "https://api:#{API_KEY}@api.mailgun.net/v2/appb1f8e5f10041475584fa283b96b24836.mailgun.org"

get '/email/:token' do

  token = params[:token]
  user = User.first(password_token: token)


  RestClient.post API_URL+"/messages",
      :from => "rodcul@gmail.com",
      :to => "rodcul@gmail.com",
      :subject => "This is subject",
      :text => user.email,
      :html => "https://secret-retreat-5607.herokuapp.com/users/reset_password/" + token
end
