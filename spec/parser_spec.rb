require './lib/token.rb' 
require './lib/parser.rb' 

describe Parser do 
  describe "#parse" do 
    it "recognizes single number expressions" do 
      tokens = [Token.new(:integer, 1)]
      parser = Parser.new(tokens) 
      expect(parser.parse_expr).to eql(IntegerNode.new(1))
    end

    it "recognizes expressions like '1+1' and '2-1'" do
      tokens = [
        Token.new(:integer, 1), 
        Token.new(:minus, '-'), 
        Token.new(:integer, 2)
      ]

      tree = Parser.new(tokens).parse
      expect(tree.class).to eql(ExprNode) 
      expect(tree.op1.class).to eql(IntegerNode)
      expect(tree.op1.value).to eql(1)
      expect(tree.addop.class).to eql(AddOpNode)
      expect(tree.addop.type).to eql(:minus)
      expect(tree.op2.class).to eql(IntegerNode) 
      expect(tree.op2.value).to eql(2)

      tokens = [
        Token.new(:integer, 1), 
        Token.new(:plus, '+'), 
        Token.new(:integer, 2)
      ]

      tree = Parser.new(tokens).parse
      expect(tree.class).to eql(ExprNode) 
      expect(tree.op1.class).to eql(IntegerNode)
      expect(tree.op1.value).to eql(1)
      expect(tree.addop.class).to eql(AddOpNode)
      expect(tree.addop.type).to eql(:plus)
      expect(tree.op2.class).to eql(IntegerNode) 
      expect(tree.op2.value).to eql(2)
    end
  end
end
