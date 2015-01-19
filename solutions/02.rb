class NumberSet
  include Enumerable

  def initialize(array = [])
    @array = array
  end

  def each(&block)
    @array.each(&block)
  end

  def <<(number)
    @array << number unless @array.include?(number)
  end

  def size
    @array.size
  end

  def empty?
    @array.empty?
  end

  def [](filter)
    NumberSet.new @array.select { |element| filter.call element }
  end
end

class Filter
  def initialize(&condition)
    @condition = condition
  end

  def &(filter)
    Filter.new { |element| @condition.call element and filter.call element }
  end

  def |(filter)
    Filter.new { |element| @condition.call element or filter.call element }
  end

  def call(element)
    @condition.call element
  end
end

class TypeFilter < Filter
  def initialize(type)
    case type
    when :integer then super() { |element| element.is_a? Integer }
    when :real    then super() { |element| element.is_a? Float or
                                           element.is_a? Rational }
    when :complex then super() { |element| element.is_a? Complex }
    end
  end
end

class SignFilter < Filter
  def initialize(sign)
    case sign
      when :positive     then super() { |element| element > 0 }
      when :negative     then super() { |element| element < 0 }
      when :non_positive then super() { |element| element <= 0 }
      when :non_negative then super() { |element| element >= 0 }
    end
  end
end