require 'active_support/core_ext/class/attribute'

class PresenterBase
  class_attribute :model_class
  attr_accessor :model
  delegate :persisted?, :new_record?, :to_param, :to=> :model

  def initialize(obj)
    @model = obj
    self.class.model_class = obj.class if model_class.nil?
  end

  def self.decorate(input, *args)
    input.respond_to?(:each) ? input.map { |i| new(i, *args) } : new(input, *args)
  end

  def self.model_name
    ActiveModel::Name.new(model_class)
  end

  def method_missing(method, *args, &block)
    model.send(method, *args, &block)
  end
end