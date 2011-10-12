require "httparty"
module PostcodeAnywhere
  
  SERVICE_ADDRESS = "http://services.postcodeanywhere.co.uk/PostcodeAnywhere/Interactive/RetrieveByPostcodeAndBuilding/v1.00/xmle.ws"
  
  include HTTParty
  format :xml
  
  class << self
    
    attr_accessor :key, :postcode, :number
    
    def license_key
      @key
    end
    
    
  end
  
  def self.lookup(query_options={})
    PostcodeAnywhere.validate_key
    data = PostcodeAnywhere.lookup(postcode)
    data["Table"]["Row"]
  end
  
  def self.find_by_postcode(postcode)
    PostcodeAnywhere.validate_key
    data = PostcodeAnywhere.lookup(postcode)
    data["Table"]["Row"]
  end
  
  def self.find_by_postcode_and_number(postcode, number)
    PostcodeAnywhere.validate_key
    data = PostcodeAnywhere.lookup(postcode, number)
    data["Table"]["Row"]
  end
  
  protected
  
  def params
    {
      :Key      => self.key,
      :Postcode => self.postcode,
      :Building => self.number
    }
  end
  
  def query_string
    params.map{|k,v| "#{CGI::escape(k.to_s)}=#{CGI::escape(v)}"}.join('&')
  end
  
  # appends query string to HOST_URL
  def to_s
    "#{HOST_URL}?#{query_string}"  
  end
  
  
  def self.validate_key
    unless PostcodeAnywhere.key
      raise PostcodeAnywhereException, "Please provide a valid Postcode Anywhere License Key"
    end
  end
  
  def self.sanitised_postcode(postcode)
    postcode.gsub(/\s/, "")
  end
  
  def self.lookup(postcode, number='')
    #PostcodeAnywhere.get SERVICE_ADDRESS+"?Key=#{PostcodeAnywhere.key}&Postcode=#{sanitised_postcode(postcode)}&Building=#{number}"
    PostcodeAnywhere.get "#{SERVICE_ADDRESS}?#{query_string}"
  end

  class PostcodeAnywhereException < StandardError;end
  
end