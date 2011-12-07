class Facebook

  def self.base64_url_decode str
    encoded_str = str.gsub('-','+').gsub('_','/')
    encoded_str += '=' while !(encoded_str.size % 4).zero?
    Base64.decode64(encoded_str)
  end

  def self.decode_data str
    encoded_sig, payload = str.split('.')
    ActiveSupport::JSON.decode base64_url_decode(payload)
  end

end