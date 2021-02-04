require './lib/node.rb' 

class CodeGenerator
  def initialize(iostream=STDOUT) 
    @iostream = iostream
  end

  def generate(tree) 
    case tree
    when ExprNode 
      generate(tree.term)
      unless tree.addopTerms.empty? 
        addop, term = tree.addopTerms
        emitLn "MOVE D0, D1" 
        generateAddOp addop, term
      end
    when TermNode 
      emitLn "MOVE \##{tree.value}, D0"
    else
      Error.abort "Unexpected node '#{tree.class}'" 
    end
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
