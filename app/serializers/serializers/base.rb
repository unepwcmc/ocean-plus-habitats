module Serializers
  class Base
    def initialize(objects=nil, name)
      instance_variable_set("@#{name}", objects)
    end

    def serialize
      raise NotImplementedError
    end

    def to_json
      serialize.to_json
    end
  end
end
