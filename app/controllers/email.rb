require 'rest-client'

API_KEY = ENV['MAILGUN_API_KEY']
API_URL = "https://api:#{API_KEY}@api.mailgun.net/v2/appb1f8e5f10041475584fa283b96b24836.mailgun.org"

get '/email' do
  RestClient.post API_URL+"/messages",
      :from => "rodcul@gmail.com",
      :to => "rodcul@gmail.com",
      :subject => "This is subject",
      :text => "Text body",
      :html => "<b>HTML</b> version of the body!"
end
