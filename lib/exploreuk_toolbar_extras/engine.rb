require 'blacklight'
require 'exploreuk_toolbar_extras'
require 'rails'

module ExploreukToolbarExtras
  class Engine < Rails::Engine
    config.to_prepare do
      ExploreukToolbarExtras.inject!
    end
  end
end
