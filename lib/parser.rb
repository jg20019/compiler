require './lib/errors.rb' 
require './lib/node.rb' 
require './lib/token.rb'

class Parser
  def initialize(tokens)
    @tokens = tokens
  end

  def peek
    @tokens[0] 
  end

  def addOp?(token) 
    token.type == :plus || token.type == :minus
  end

  def atEnd? 
    @tokens.length == 0
  end

  def parse
    parse_expr
  end

  def parse_expr
    op1 = parse_term
    if atEnd? 
      op1
    else
      case peek.type
      when :plus 
        addOp = AddOpNode.new(:plus)
        consume(:plus) 
        op2 = parse_term
      when :minus 
        addOp = AddOpNode.new(:minus)
        consume(:minus) 
        op2 = parse_term
      else 
        Error.expected('Addop') 
      end 
      ExprNode.new(op1, addOp, op2) 
    end
  end

  def parse_term
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
