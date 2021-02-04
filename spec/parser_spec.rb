require './lib/token.rb' 
require './lib/parser.rb' 

describe Parser do 
  describe "#parse" do 
    it "recognizes single number expressions" do 
      tokens = [Token.new(:integer, 1)]
      parser = Parser.new(tokens) 
      expect(parser.parse_expr).to eql(IntegerNode.new(1))
    end
  end
end
