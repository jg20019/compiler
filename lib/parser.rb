require './lib/errors.rb' 
require './lib/node.rb' 

class Parser
  def initialize(tokens)
    @tokens = tokens
  end

  def parse
    parse_expr
  end

  def parse_expr
    IntegerNode.new(consume(:integer).value) 
  end

  def consume(expected_type) 
    if @tokens[0].type == expected_type
      @tokens.shift
    else
      Errors.expected(expected_type) 
    end 
  end
end
