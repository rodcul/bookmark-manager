require 'rest-client'

API_KEY = ENV['MAILGUN_API_KEY']
API_URL = "https://api:#{API_KEY}@api.mailgun.net/v2/appb1f8e5f10041475584fa283b96b24836.mailgun.org"

EMAIL_FROM = ENV['MAILGUN_SMTP_LOGIN']

get '/email/:token' do
  token = params[:token]
  user = User.first(password_token: token)
  email = user.email


  RestClient::Request.execute(
    url: API_URL + '/messages',
    method: :post,
    payload: {
      from: EMAIL_FROM,
      to: email,
      subject: 'Password reset from Bookmark Manager',
      text: base_url + '/users/reset_password/' + token,
      html: base_url + '/users/reset_password/' + token,
      multipart: true
    },
    headers: {
      "h:X-My-Header": 'www/mailgun-email-send'
    },
    verify_ssl: false
  )

  flash[:notice] = "Password e-mail sent, check your inbox!"
  redirect to '/'
end
