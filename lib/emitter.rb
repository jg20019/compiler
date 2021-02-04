
class Emitter
  attr_reader :lines 

  def initialize
    @lines = [] 
  end

  def emit(str) 
    "\t#{str}" 
  end

  def emitLn(str)
    @lines << "#{self.emit(str)}"
  end

  def to_s 
    @lines.join('\n') 
  end
end
