require "httparty"
require 'cgi'

module Hatch
  class PostcodeAnywhere
    
    SERVICE_ADDRESS = "http://services.postcodeanywhere.co.uk/PostcodeAnywhere/Interactive/RetrieveByPostcodeAndBuilding/v1.00/xmle.ws"
    
    include HTTParty
    format :xml

    def self.find(query_options={})
      PostcodeAnywhere.validate_key
      data = PostcodeAnywhere.lookup(query_options)
      data["Table"]["Row"]
    end

    def self.params(options={})
      {
        :Key      => POSTCODE_ANYWHERE_KEY,
        :Postcode => sanitised_postcode(options[:postcode]),
        :Building => options[:number]
      }
    end
    
    def self.query_string(options={})
      params(options).map{|k,v| "#{CGI::escape(k.to_s)}=#{CGI::escape(v)}"}.join('&')
    end

    def self.validate_key
      unless POSTCODE_ANYWHERE_KEY
        raise PostcodeAnywhereException, "Please provide a valid Postcode Anywhere License Key"
      end
    end
    
    def self.sanitised_postcode(postcode)
      postcode.gsub(/\s/, "")
    end
    
    def self.lookup(query_options={})
      param_string = query_string(query_options)
      PostcodeAnywhere.get "#{SERVICE_ADDRESS}?#{param_string}"
    end
  
    class PostcodeAnywhereException < StandardError;end
    
  end

end