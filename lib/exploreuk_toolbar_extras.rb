# ExploreukToolbarExtras

module ExploreukToolbarExtras
  autoload :ControllerOverride, 'exploreuk_toolbar_extras/controller_override'
  autoload :RouteSets, 'exploreuk_toolbar_extras/route_sets'

  require 'exploreuk_toolbar_extras/version'
  require 'exploreuk_toolbar_extras/engine'

  mattr_accessor :labels
  self.labels = {
    :missing => "Unknown"
  }

  
  @omit_inject = {}
  def self.omit_inject=(value)
    value = Hash.new(true) if value == true
    @omit_inject = value      
  end
  def self.omit_inject ; @omit_inject ; end

  def self.maybe_inject(options = {})
    unless omit_inject[options[:condition]]
      options[:original].send(:include, options[:override]) unless options[:original].include?(options[:override])
    end
  end

  def self.maybe_inject_helper(options = {})
    unless omit_inject[options[:condition]]
      options[:original].send(:helper, options[:override]) unless options[:original].is_a?(options[:override])
    end
  end
  
  def self.inject!
    maybe_inject original: CatalogController,
      override: ExploreukToolbarExtras::ControllerOverride,
      condition: :controller_mixin

    maybe_inject original: Blacklight::Routes,
      override: ExploreukToolbarExtras::RouteSets,
      condition: :routes
  end

  # Add element to array only if it's not already there
  def self.safe_arr_add(array, element)
    array << element unless array.include?(element)
  end
  
end
