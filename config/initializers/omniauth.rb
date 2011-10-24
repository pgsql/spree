require 'openid/store/filesystem'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '122369121194599', '66ae81101188498c9055326a64b61997'
end

