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
    exprNode = ExprNode.new(parse_term, [])
    if atEnd? 
      exprNode
    else
      parse_addop_terms exprNode
    end
  end

  def parse_addop_terms(exprNode) 
    while !atEnd? && addOp?(peek) 
      case peek.type
      when :plus 
        addOp = AddOpNode.new(:plus)
        consume(:plus) 
        exprNode.addopTerms << addOp << parse_term
      when :minus 
        addOp = AddOpNode.new(:minus)
        consume(:minus) 
        exprNode.addopTerms << addOp << parse_term
      else 
        Error.expected('Addop') 
      end 
    end
    exprNode
  end

  def parse_term
    TermNode.new(consume(:integer).value) 
  end

  def consume(expected_type) 
    if @tokens[0].type == expected_type
      @tokens.shift
    else
      Errors.expected(expected_type) 
    end 
  end
end
