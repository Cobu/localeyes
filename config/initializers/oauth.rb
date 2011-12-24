Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, LocalEyesSettings.facebook_api_key, LocalEyesSettings.facebook_secret, scope: 'email,user_birthday'
end