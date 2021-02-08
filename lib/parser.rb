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

  def mulOp?(token)
    token.type == :star || token.type == :slash
  end

  def atEnd? 
    @tokens.length == 0
  end

  def parse
    parse_expr
  end

  def parse_expr
    exprNode = ExprNode.new(parse_term, [])
    parse_addop_terms exprNode
  end

  def parse_term 
    termNode = TermNode.new(parse_factor, [])
    parse_mulop_factors termNode
  end

  def parse_addop_terms(exprNode) 
    while !atEnd? && addOp?(peek) 
      case peek.type
      when :plus 
        parse_add exprNode
      when :minus 
        parse_subtract exprNode
      else 
        Error.expected('Addop') 
      end 
    end
    exprNode
  end

  def parse_factor
    FactorNode.new(consume(:integer).value) 
  end

  def parse_mulop_factors(termNode) 
    while !atEnd? && mulOp?(peek) 
      case peek.type
      when :star 
        parse_multiply termNode
      when :slash
        parse_divide termNode
      else
        Error.expected 'Mulop' 
      end
    end
    termNode
  end

  def parse_add(exprNode)
    consume(:plus) 
    addOp = AddOpNode.new(:plus)
    exprNode.addopTerms << addOp << parse_term
  end

  def parse_subtract(exprNode)
    consume(:minus) 
    addOp = AddOpNode.new(:minus)
    exprNode.addopTerms << addOp << parse_term
  end

  def parse_multiply(termNode) 
    consume(:star)
    mulOp = MulOpNode.new(:star) 
    termNode.mulopFactors << mulOp << parse_factor
  end

  def parse_divide(termNode) 
    consume(:slash)
    mulOp = MulOpNode.new(:slash) 
    termNode.mulopFactors << mulOp << parse_factor
  end

  def consume(expected_type) 
    Error.expected "#{expected_type.inspect}" if @tokens.empty?  

    if @tokens[0].type == expected_type
      @tokens.shift
    else
      Error.expected(expected_type) 
    end 
  end
end
