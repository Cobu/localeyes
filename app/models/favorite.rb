class Favorite
  include Mongoid::Document

  field :businesses,:type => Array
end
