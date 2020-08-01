class Wagon
  include Company
  include Validation
  attr_reader :number, :type
  NUMBER_FORMAT = /\w{3}-?{1}\w{2}$/

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :type, String

  def initialize(number, type)
    @number = number
    @type = type
    validate!
  end
end
