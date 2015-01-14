module RBFS
  class File
    attr_accessor :data

    def initialize(data = nil)
      @data = data
    end

    def data_type
      case @data.class.to_s
      when 'Fixnum', 'Float'         then @data_type = :number
      when 'TrueClass', 'FalseClass' then @data_type = :boolean
      when 'NilClass'                then @data_type = :nil
      else @data_type = @data.class.to_s.downcase.intern
      end
    end

    def serialize
      data_type.to_s + ':' + @data.to_s
    end

    def self.parse(string_data)
      array = string_data.partition(':')
      case array[0]
      when 'number'  then File.new(array[2].to_f)
      when 'nil'     then File.new(nil)
      when 'string'  then File.new(array[2])
      when 'symbol'  then File.new(array[2].intern)
      when 'boolean' then File.new(array[2] == 'true')
      end
    end
  end

  class Directory
    def initialize(hash = {})
      @directory = hash
    end

    def add_file(name, file)
      @directory[name] = file
    end

    def add_directory(name, directory = Directory.new)
      @directory[name] = directory
    end

    def files
      @directory.select{|key, value| value.is_a? File}
    end

    def directories
      @directory.select{|key, value| value.is_a? Directory}
    end

    def [](name)
      @directory[name]
    end

    def serialize
      result = files.length.to_s + ':'
      files.each do |key, value|
        result += key + ':' + value.serialize.length.to_s + ':' + value.serialize
      end
      result += directories.length.to_s + ':'
      directories.each do |key, value|
        result += key + ':' + value.serialize.length.to_s + ':' + value.serialize
      end
      result
    end
  end
end