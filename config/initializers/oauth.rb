Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, LocalEyesSettings.facebook_api_key, LocalEyesSettings.facebook_secret, scope: 'email,user_birthday,publish_stream,offline_access'
  provider :twitter, LocalEyesSettings.twitter_api_key, LocalEyesSettings.twitter_secret
end