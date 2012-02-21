require 'machinist/mongoid'
require 'circuit'

Route.blueprint do
  slug     { Faker::Lorem.words(rand(3) + 2).join('-') }
  behavior { Behaviors::MountByFragmentOrRemap }
end

Site.blueprint do
  domain   { 'www.example.org'   }
  behavior { Behaviors::RenderOK }
  _type    { "Site"              }
  slug     { "_"                 }
end
