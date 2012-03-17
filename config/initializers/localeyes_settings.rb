yaml = YAML.load_file(Rails.root.join('config/localeyes_settings.yml'))[Rails.env]
LocalEyesSettings = ActiveSupport::OrderedOptions.new.update yaml


