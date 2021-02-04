require './lib/errors.rb'
require './lib/token.rb' 


class Lexer
  def initialize(source) 
    @index = 0
    @source = source
  end

  def look
    @source[@index]
  end

  def getChar
    index = @index
    @index += 1
    @source[index] 
  end

  def match(ch) 
    if look == ch
      getChar
    else
      Error.expected(ch) 
    end
  end

  def alpha?(ch) 
    /\A[a-zA-Z]$/.match? ch
  end

  def digit?(ch) 
    /\A[0-9]$/.match? ch
  end

  def getName
    Error.expected('Name') unless alpha?(look) 
    token = Token.new(:name, look.upcase) 
    getChar
    token
  end

  def getNum
    Error.expected('Integer') unless digit?(look) 
    token = Token.new(:number, look.to_i) 
    getChar
    token
  end
end
