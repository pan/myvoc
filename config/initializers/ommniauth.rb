OmniAuth.config.on_failure =  Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'],ENV['GOOGLE_CLIENT_SECRET'],
  { 
    name: 'google',
    access_type: 'online',
    scope: 'plus.me',
  }
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
end
