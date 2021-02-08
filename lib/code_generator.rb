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
    generateTerm(exprNode.term) 
    until exprNode.addopTerms.empty? 
      addop, term = exprNode.addopTerms.shift(2)
      emitLn "MOVE D0, -(SP)" 
      generateAddOp addop, term 
    end
  end

  def generateTerm(termNode) 
    generateFactor(termNode.factor) 
    until termNode.mulopFactors.empty? 
      mulopNode, factorNode = termNode.mulopFactors.shift(2) 
      emitLn "MOVE D0, -(SP)" 
      generateMulOp mulopNode, factorNode
    end
  end

  def generateFactor(factorNode) 
    emitLn "MOVE ##{factorNode.value}, D0" 
  end

  def generateMulOp(mulOpNode, factorNode) 
    case mulOpNode.type
    when :star 
      generateMultiply factorNode
    when :slash 
      generateDivide factorNode
    else 
      Error.expected "Mulop" 
    end 
  end

  def generateMultiply(factorNode) 
    generateFactor(factorNode) 
    emitLn "MULS (SP)+, D0" 
  end

  def generateDivide(factorNode) 
    generateFactor(factorNode) 
    emitLn "MOVE (SP)+, D1" 
    emitLn "DIVS D1, D0" 
  end

  def generateAddOp(addOpNode, termNode)  
    case addOpNode.type
    when :plus
      generateAdd termNode
    when :minus
      generateSubtract termNode
    else 
      Error.expected "Addop" 
    end
  end

  def generateAdd(termNode) 
    generate(termNode) 
    emitLn 'ADD (SP)+, D0'
  end

  def generateSubtract(termNode)
    generate(termNode)
    emitLn 'SUB (SP)+, D0'
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
      FactorNode.new(4), [
        MulOpNode.new(:star), 
        FactorNode.new(5)
      ]
    ), 
    []
  )

CodeGenerator.new().generate(tree) 
