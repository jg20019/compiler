
class Emitter
  def self.emit(str) 
    print "\t#{str}" 
  end

  def self.emitLn(str)
    self.emit(str)
    puts
  end
end
