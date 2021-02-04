require './lib/node.rb' 
require './lib/emitter.rb' 

class CodeGenerator
  def initialize(emitter) 
    @emitter = emitter
  end
  def generate(tree) 
    case tree
    when ExprNode 
      generate(tree.op1)
      @emitter.emitLn("MOVE D0,D1") 
      generateAddOp tree.addop, tree.op2
    when IntegerNode 
      @emitter.emitLn("MOVE \##{tree.value}, D0") 
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
    @emitter.emitLn('ADD D1, D0') 
  end

  def generateSubtract(operand)
    generate(operand)
    @emitter.emitLn('SUB D1, D0') 
  end
end
