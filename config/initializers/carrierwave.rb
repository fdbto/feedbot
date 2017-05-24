if ENV['CW_USE_FILE'].blank? && ENV['CW_S3_KEY_ID'] && ENV['CW_S3_SECRET_KEY'] && ENV['CW_S3_BUCKET']
  CarrierWave.configure do |config|
    config.storage    = :aws
    config.aws_bucket = ENV.fetch('CW_S3_BUCKET')
    config.aws_acl    = :public_read
    if ENV['CW_CDN_HOST']
      config.asset_host = ENV['CW_CDN_HOST']
    end
    config.aws_authenticated_url_expiration = 60 * 60

    config.aws_credentials = {
      access_key_id:     ENV.fetch('CW_S3_KEY_ID'),
      secret_access_key: ENV.fetch('CW_S3_SECRET_KEY'),
      region: ENV.fetch('CW_S3_REGION')
    }
  end
else
  CarrierWave.configure do |config|
    config.storage = :file
    config.asset_host = 'https://feedbot.ngrok.io'
  end
end
