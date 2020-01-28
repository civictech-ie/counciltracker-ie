if Rails.env.development? || Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
  end
end

if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region: "eu-west-1",
    }

    config.cache_dir = "#{Rails.root}/tmp/uploads"
    config.asset_host = ENV["AWS_HOST"]
    config.fog_directory = ENV["AWS_BUCKET"]
    config.fog_attributes = {"Cache-Control" => "max-age=315576000"}
    config.storage = :fog
  end
end
