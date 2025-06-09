# Exercício: Classe Vector2

# Objetivo: 
# Criar uma classe Vector2 que receba dois parâmetros (X e Y) e permita a multiplicação desse Vector2 
# por objetos do tipo Numeric e Vector2. 
 
module IntegerMultiplication
  def *(other)
    return other * self if other.is_a?(Vector2)
    super
  end
end

module IntegerMultiplicationRefinement
  refine Integer do
    import_methods IntegerMultiplication
  end
end

class Vector2
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  Float.class_eval do
    alias_method :original_multiplication, :*
    def *(other)
      return other * self if other.is_a?(Vector2)

      original_multiplication(other)    
    end
  end
  
  def *(other)
    if other.is_a?(Numeric)
      "(#{x * other}, #{y * other})"
    elsif other.is_a?(Vector2)
      (x * other.x) + (y * other.y)
    end
  end

  # def coerce(other)
  #   [self * other, 1]
  # end
end

v = Vector2.new(3, 4) 
using IntegerMultiplicationRefinement
puts v * 2    # Output: (6, 8) 
puts v * 2.5  # Output: (7.5, 10.0) 
puts v * v    # Output: 25 (dot product) 
puts 2 * v    # Output: (6, 8) 
puts 2.5 * v  # Output: (7.5, 10.0) 