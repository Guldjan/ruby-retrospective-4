module UI
  class Methods
    @@text = ''
    @@orientation = 0

    def style(symbol)
      case symbol
      when :upcase then @@text.upcase!
      when :downcase then @@text.downcase!
      when :nil then @@text
      end
    end

    def label(text:, border: nil, style: nil)
      @@text << text
      border ? @@text.insert(0, border).insert(@@text.length, border) : nil
      @@orientation == 1 ? insert : nil
      style(style)
      @@text
    end

    def insert
      @@text << "\n"
    end

    def self.change
      @@text = ''
    end

    def horizontal(border: nil, style: nil, &block)
      @@orientation = 0
      block.call
    end

    def vertical(border: nil, style: nil, &block)
      @@orientation = 1
      block.call
    end
  end

  class TextScreen
    @@used = 0
    def self.draw(&block)
      change
      @@used = 1
      p = Methods.new
      p.instance_eval &block
    end

    def self.change
      if @@used == 1
        Methods.change
      end
    end
  end
end