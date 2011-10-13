require "httparty"
require 'cgi'

module Hatch
  class PostcodeAnywhere
    
    SERVICE_ADDRESS = "http://services.postcodeanywhere.co.uk/PostcodeAnywhere/Interactive/RetrieveByPostcodeAndBuilding/v1.00/xmle.ws"
    
    include HTTParty
    format :xml

    def self.lookup(query_options={})
      PostcodeAnywhere.validate_key
      data = PostcodeAnywhere.get "#{SERVICE_ADDRESS}?#{query_string(query_options)}"
      data["Table"]["Row"]
    end
    
    def self.params(options={})
      postal_code = sanitised_postcode( find_postal_code(options) )
      
      params_hash = {
        :Key      => POSTCODE_ANYWHERE_KEY,
        :Postcode => postal_code,
        :Building => options[:number]
      }
      params_hash.delete_if {|k,v| v.nil? || v.empty? }
    end
    
    def self.query_string(options={})
      params(options).map{|k,v| "#{CGI::escape(k.to_s)}=#{CGI::escape(v)}"}.join('&')
    end

    private

    def self.validate_key
      unless POSTCODE_ANYWHERE_KEY
        raise PostcodeAnywhereException, "Please provide a valid Postcode Anywhere License Key"
      end
    end
    
    def self.sanitised_postcode(postcode)
      postcode.nil? ? nil : postcode.gsub(/\s/, "")
    end
    
    def self.find_postal_code(options={})
      case
      when options.has_key?(:postal_code)
        options[:postal_code]
      when options.has_key?(:postcode)
        options[:postcode]
      when options.has_key?(:post_code)
        options[:post_code]
      when options.has_key?(:zip_code)
        options[:zip_code]
      when options.has_key?(:zipcode)
        options[:zipcode]
      else
        nil
      end
    end

    class PostcodeAnywhereException < StandardError;end
    
  end

end