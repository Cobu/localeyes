class Authentication < ActiveRecord::Base
  belongs_to :user

  serialize :auth_hash, Hash

  scope :facebook, where(provider: :facebook)
  scope :twitter, where(provider: :twitter)

  def name
    auth_hash[:info].try(:[], :name)
  end

  def auth_token
    auth_hash[:credentials][:token]
  end

  def auth_secret
    auth_hash[:credentials][:secret]
  end

  def facebook
    @fb_user ||= Koala::Facebook::API.new(auth_token)
  end

  def twitter
    @tw_user ||=
      consumer = OAuth::Consumer.new(LocalEyesSettings.twitter_api_key, LocalEyesSettings.twitter_secret, {:site => "http://api.twitter.com"})
      token_hash = {:oauth_token => auth_token, :oauth_token_secret => auth_secret}
      OAuth::AccessToken.from_hash(consumer, token_hash)
  end

  def publish(text)
    begin
      case provider
        when 'facebook' then
          facebook.put_wall_post(text)
        when 'twitter' then
          twitter.request(:post, "http://api.twitter.com/1/statuses/update.json", :status => text)
      end
    rescue Exception => e
      Rails.logger.error e
    end
  end

  protected

  #def extract_user_attributes(hash)
  #  user_credentials = hash['credentials'] || {}
  #  user_info = hash['user_info'] || {}
  #  user_hash = hash['extra'] ? (hash['extra']['user_hash'] || {}) : {}
  #
  #  {
  #    :token => user_credentials['token'],
  #    :secret => user_credentials['secret'],
  #    :name => user_info['name'],
  #    :email => (user_info['email'] || user_hash['email']),
  #    :nickname => user_info['nickname'],
  #    :last_name => user_info['last_name'],
  #    :first_name => user_info['first_name'],
  #    :link => (user_info['link'] || user_hash['link']),
  #    :photo_url => (user_info['image'] || user_hash['image']),
  #    :locale => (user_info['locale'] || user_hash['locale']),
  #    :description => (user_info['description'] || user_hash['description'])
  #  }
  #end
end