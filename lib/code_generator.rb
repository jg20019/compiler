require './lib/node.rb' 
require './lib/emitter.rb' 

class CodeGenerator
  def initialize(emitter) 
    @emitter = emitter
  end
  def generate(tree) 
    case tree
    when IntegerNode 
      @emitter.emitLn("MOVE \##{tree.value}, D0") 
    else
      Error.abort "Unexpected node '#{tree.class}'" 
    end
  end
end
