class NumberSet
  include Enumerable

  def initialize(array = [])
    @array = array
  end

  def each
    iterator = 0
    while iterator <= @array.size
      yield @array[iterator]
      iterator += 1
    end
  end

  def <<(number)
    unless @array.include?(number)
      @array << number
    end
  end

  def size
    @array.size
  end

  def empty?
    @array.empty?
  end

  def [](filter)
    NumberSet.new(filter.filter_numbers(@array))
  end
end

class CombineFilters
  def initialize(first_filter, second_filter, operator)
    @first_filter = first_filter
    @second_filter = second_filter
    @operator = operator
  end

  def filter_numbers(array)
    if @operator == :&
      @first_filter.filter_numbers(@second_filter.filter_numbers(array))
    else @operator == :|
      new_array = @first_filter.filter_numbers(array)
      new_array + @second_filter.filter_numbers(array)
    end
  end
end


class Filter
  def initialize(&block)
    @block = block
  end

  def filter_numbers(array)
    array.select {|element| @block.(element)}
  end

  def &(filter)
    CombineFilters.new(self, filter, :&)
  end

  def |(filter)
    CombineFilters.new(self, filter, :|)
  end
end

class TypeFilter
  def initialize(type)
    @type = type
  end

  def filter_numbers(array)
    case @type
    when :integer then array.select {|number| number.is_a? Integer}
    when :complex then array.select {|number| number.is_a? Complex}
    else array.select {|number| number.is_a? Float or number.is_a? Rational}
    end
  end

  def &(filter)
    CombineFilters.new(self, filter, :&)
  end

  def |(filter)
    CombineFilters.new(self, filter, :|)
  end
end

class SignFilter
  def initialize(sign)
    @sign = sign
  end

  def filter_numbers(array)
    case @sign
    when :positive     then array.select {|number| number > 0}
    when :non_positive then array.select {|number| number <= 0}
    when :negative     then array.select {|number| number < 0}
    when :non_negative then array.select {|number| number >= 0}
    end
  end

  def &(filter)
    CombineFilters.new(self, filter, :&)
  end

  def |(filter)
    CombineFilters.new(self, filter, :|)
  end
end