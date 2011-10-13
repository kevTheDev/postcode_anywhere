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
    
    # TODO - we should be able to accept common aliases for postcode var
    def self.params(options={})
      params_hash = {
        :Key      => POSTCODE_ANYWHERE_KEY,
        :Postcode => sanitised_postcode(options[:postcode]),
        :Building => options[:number]
      }
      params_hash.delete_if {|k,v| v.nil? || v.empty? }
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

    class PostcodeAnywhereException < StandardError;end
    
  end

end