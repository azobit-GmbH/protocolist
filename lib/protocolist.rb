require 'active_support'
require 'active_support/core_ext'

require 'protocolist/version'
require 'protocolist/model_additions'
require 'protocolist/controller_additions'

require 'protocolist/railtie' if defined? Rails


module Protocolist
  mattr_accessor :actor, :activity_class

  def self.fire(activity_type, options = {})
    options = options.reverse_merge actor: @@actor, activity_type: activity_type
    @@activity_class.create options if options[:actor] && @@activity_class
  end
end
