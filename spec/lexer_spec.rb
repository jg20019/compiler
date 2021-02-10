require './lib/lexer.rb' 

describe Lexer do 
  describe "#alpha?" do
    it "returns true on all lowercase letters" do
      lexer = Lexer.new "" 
      ('a'..'z').each { |ch| expect(lexer.alpha?(ch)).to eql(true) }
    end

    it "returns true for all uppercase letters" do 
      lexer = Lexer.new "" 
      ('A'..'Z').each { |ch| expect(lexer.alpha?(ch)).to eql(true) }
    end

    it "returns false for all numbers" do 
      lexer = Lexer.new "" 
      (0..9).each { |num| expect(lexer.alpha?(num.to_s)).to eql(false) }
    end 
  end
  
  describe "#digit?" do
    it "returns true for all digits" do
      lexer = Lexer.new ""
      (0..9).each { |num| expect(lexer.digit?(num.to_s)).to eql(true) }
    end
  end

  describe "#getName" do 
    it "returns a name token if the next character is a letter" do
      lexer = Lexer.new "abc" 
      token = lexer.getName
      expect(token.type).to eql(:name) 
      expect(token.value).to eql("A") 
    end

    it "advances look to the next char if it matched a name" do
      lexer = Lexer.new "a+1"
      lexer.getName
      expect(lexer.look).to eql("+") 
    end
    
    it "raises an error if it look was not a letter" do 
      lexer = Lexer.new "1" 
      expect { lexer.getName }.to raise_error(RuntimeError) 
    end 
  end

  describe "#getNum" do 
    it "returns a number token if the next character is a letter" do
      lexer = Lexer.new "1+1" 
      token = lexer.getNum
      expect(token.type).to eql(:integer)
      expect(token.value).to eql(1)
    end 

    it "advance look if it matched a number" do
      lexer = Lexer.new "1+1"
      lexer.getNum
      expect(lexer.look).to eql("+") 
    end

    it "raises a RuntimeError if it did not match a number" do
      lexer = Lexer.new "a+1" 
      expect { lexer.getNum }.to raise_error(RuntimeError) 
    end

    it "recognizes negative numbers" do 
      tokens = Lexer.new("-1").tokenize
      expected = [
        Token.new(:integer, -1) 
      ]
      expect(tokens).to eql(expected) 
    end
  end 

  describe "#getToken" do
    it "can recogize a plus sign" do
      token = Lexer.new("+").getToken
      expect(token.type).to eql(:plus)  
    end

    it "can recognize a minus sign" do
      token = Lexer.new("-").getToken
      expect(token.type).to eql(:minus) 
    end

    it "recognizes stars" do 
      token = Lexer.new("*").getToken
      expect(token.type).to eql(:star) 
    end

    it "recognizes stars" do 
      token = Lexer.new("/").getToken
      expect(token.type).to eql(:slash) 
    end

    it "recognizes left parens" do 
      token = Lexer.new("(").getToken
      expect(token.type).to eql(:lparen) 
    end

    it "recognizes right parens" do 
      token = Lexer.new(")").getToken
      expect(token.type).to eql(:rparen) 
    end
  end

  describe "#tokenize" do 
    it "can tokenize a single integer" do 
      tokens = Lexer.new("1").tokenize
      expected_tokens = [
        Token.new(:integer, 1) 
      ] 
      expect(tokens).to eql(expected_tokens) 
    end

    it "ignores whitespace" do 
      tokens = Lexer.new(" 1 +   3").tokenize
      expected_tokens = [
        Token.new(:integer, 1), 
        Token.new(:plus, '+'), 
        Token.new(:integer, 3) 
      ] 
      expect(tokens).to eql(expected_tokens) 
    end
  end 
end
