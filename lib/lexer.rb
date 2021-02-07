require './lib/errors.rb'
require './lib/token.rb' 


class Lexer
  def initialize(source) 
    @index = 0
    @source = source
  end

  def tokenize
    tokens = []
    until atEnd? 
      consumeWhitespace
      tokens << getToken
    end
    tokens 
  end

  def atEnd? 
    @index >= @source.length
  end

  def getToken
    if digit?(look) 
      getNum
    elsif look == '+' 
      match('+') 
      Token.new(:plus, '+') 
    elsif look == '-'
      match('-') 
      Token.new(:minus, '-')
    elsif look == '*'
      match('*') 
      Token.new(:star, '*') 
    elsif look == '/'
      match('/')
      Token.new(:slash, '/')
    else
      Error.abort("Unexpected character '#{look}'") 
    end
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

  def whitespace?(ch)
    /\A\s$/.match? ch
  end

  def getName
    Error.expected('Name') unless alpha?(look) 
    token = Token.new(:name, look.upcase) 
    getChar
    token
  end

  def getNum
    Error.expected('Integer') unless digit?(look) 
    token = Token.new(:integer, look.to_i) 
    getChar
    token
  end

  def consumeWhitespace
    @index += 1 while whitespace?(look) 
  end
end

