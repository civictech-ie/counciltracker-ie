Rails.application.config.sorcery.submodules = [:remember_me]

Rails.application.config.sorcery.configure do |config|
  config.user_config do |user|
    user.username_attribute_names = [:email_address]
  end

  config.user_class = 'User'
end
