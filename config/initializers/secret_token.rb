# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
key_base_name = 'BITTORIOUS_SECRET_KEY_BASE'
Rails.application.config.secret_key_base = ENV[key_base_name]
if Rails.application.config.secret_key_base.nil?
	tmp = 'not-for-production-use'
	Rails.logger.error "A #{key_base_name} environment MUST be set, but wasn't found. Setting to '#{tmp}'"
	Rails.application.config.secret_key_base = tmp
	# exit 1
end
