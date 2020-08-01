module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    attr_accessor :history

    def attr_accessor_with_history(*names)
      names.each do |name|
        attr_reader name
        var_name = "@#{name}".to_sym

        #define_method(name) { instance_variable_get(var_name) }

        define_method("#{name}=".to_sym) do |value|
          @history ||= {}
          @history_value ||= []
          @history_value << instance_variable_get(var_name)
          instance_variable_set(var_name, value)
          @history[name] = @history_value.reverse
        end

        define_method("#{name}_history") do
          @history ||= {}
          @history[name]
        end

      end
    end

    def strong_attr_accessor(name, type)
      var_name = "@#{name}".to_sym

      define_method(name) { instance_variable_get(var_name) }

      define_method("#{name}=".to_sym) do |value|
        value.class == type ? instance_variable_set(var_name, value) : raise('Incorrect type')
      end

    end
  end
end
