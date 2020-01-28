class PortraitUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process convert: "png"

  def filename
    "portrait.png"
  end

  def store_dir
    "councillors/#{model.slug}"
  end

  version :small do
    process resize_to_fill: [192, 192]
  end

  version :medium do
    process resize_to_fit: [512, 512]
  end

  version :large do
    process resize_to_fit: [1024, 1024]
  end
end
