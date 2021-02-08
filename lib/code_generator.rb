require './lib/node.rb' 

class CodeGenerator
  def initialize(iostream=STDOUT) 
    @iostream = iostream
  end

  def generate(tree) 
    case tree
    when ExprNode 
      generateExpr tree
    when TermNode 
      generateTerm tree
    when FactorNode
      generateFactor tree
    else
      Error.abort "Unexpected node '#{tree.class}'" 
    end
  end

  def generateExpr(exprNode) 
    generate(exprNode.term) 
    until exprNode.addopTerms.empty? 
      addop, term = exprNode.addopTerms.shift(2)
      emitLn "MOVE D0, D1" 
      generateAddOp addop, term 
    end
  end

  def generateTerm(termNode) 
    generateFactor(termNode.factor) 
  end

  def generateFactor(factorNode) 
    emitLn "MOVE ##{factorNode.value}, D0" 
  end

  def generateAddOp(addOp, operand)  
    case addOp.type
    when :plus
      generateAdd operand
    when :minus
      generateSubtract operand
    else 
      Error.abort "Unexpected addOp '#{addOp.inspect}'"  
    end
  end

  def generateAdd(operand) 
    generate(operand) 
    emitLn 'ADD D1, D0'
  end

  def generateSubtract(operand)
    generate(operand)
    emitLn 'SUB D1, D0'
    emitLn 'NEG D0'
  end

  private 
  def emitLn(str)
    @iostream.puts("\t#{str}")
  end
end


tree = 
  ExprNode.new(
    TermNode.new(
      FactorNode.new(1), []
    ), 
    []
  )

CodeGenerator.new().generate(tree) 
