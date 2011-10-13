module Hatch
  
  autoload :PostcodeAnywhere, 'hatch/postcode_anywhere'
  autoload :Version,          'hatch/version'

end

require 'hatch/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3