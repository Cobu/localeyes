class LocalEyesSettings < Settingslogic
  source    Rails.root.join('config/localeyes_settings.yml')
  namespace Rails.env
  load!
end

