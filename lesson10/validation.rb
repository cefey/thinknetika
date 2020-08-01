module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validation
    def validate(name, validation, *params)
      @validation ||= []
      @validation << { var: name, type: validation, opt: params.first }
    end
  end

  module InstanceMethods
    attr_reader :var
    def validate!
      self.class.validation.each do |validation|
        value = get_var(validation[:var])
        send("validate_#{validation[:type]}", validation[:var], value, validation[:opt])
      end
    end

    def valid?
      validate!
      true
    rescue ArgumentError => e
      false
    end

    def get_var(name)
      instance_variable_get("@#{name}")
    end

    protected

    def validate_presence(var, value, *)
      raise ArgumentError, "#{self}: in '#{var}' - Value presence error" if value.to_s.empty?
    end

    def validate_format(var, value, format)
      raise ArgumentError, "#{self}: in '#{var}' - Value format error" if value !~ format
    end

    def validate_type(var, value, value_type)
      raise ArgumentError, "#{self}: in '#{var}' - Value type error" if value.class != value_type
    end
  end
end
