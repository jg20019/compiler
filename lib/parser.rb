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
    term = parse_term
    addition_operation_terms = parse_addop_terms # returns a list
    if addition_operation_terms.empty?
      {expr: term} 
    else
      {expr: [term].concat(addition_operation_terms)} 
    end
  end

  def parse_term 
    factor = parse_factor
    multiplication_operation_factors = parse_mulop_factors 
    if multiplication_operation_factors.empty? 
      {term: factor} 
    else
      {term: [factor].concat(multiplication_operation_factors)}
    end
  end

  def parse_addop_terms() 
    addition_operation_terms = [] 
    while !atEnd? && addOp?(peek) 
      case peek.type
      when :plus 
        addition_operation_terms.concat parse_add
      when :minus 
        addition_operation_terms.concat parse_subtract 
      else 
        Error.expected('Addop') 
      end 
    end
    addition_operation_terms 
  end

  def parse_factor
    Error.expected('factor') if @tokens.empty? 
    if peek.type == :lparen
      consume(:lparen)
      factor = {factor: parse_expr}
      consume(:rparen)
    else
      factor = {factor: consume(:integer).value} 
    end
    factor
  end

  def parse_mulop_factors() 
    multiplication_operation_factors = []
    while !atEnd? && mulOp?(peek) 
      case peek.type
      when :star 
        multiplication_operation_factors.concat(parse_multiply)  
      when :slash
        multiplication_operation_factors.concat(parse_divide)
      else
        Error.expected 'Mulop' 
      end
    end
    multiplication_operation_factors 
  end

  def parse_add()
    consume(:plus) 
    [{operation: :addition}, parse_term] 
  end

  def parse_subtract()
    consume(:minus) 
    [{operation: :subtraction}, parse_term]
  end

  def parse_multiply() 
    consume(:star)
    [{operation: :multiplication}, parse_factor]
  end

  def parse_divide() 
    consume(:slash)
    [{operation: :division}, parse_factor]
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

tokens = [
  Token.new(:integer, 1), 
  Token.new(:plus, '+'), 
  Token.new(:integer, 2)
]

puts Parser.new(tokens).parse 
