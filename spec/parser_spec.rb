require './lib/token.rb' 
require './lib/parser.rb' 

describe Parser do 
  describe "#parse" do 
    it "recognizes single number expressions" do 
      tokens = [Token.new(:integer, 1)]
      tree = Parser.new(tokens).parse
      expect(tree.term).to eql(TermNode.new(1))
    end

    it "recognizes expressions like '1+1' and '2-1'" do
      tokens = [
        Token.new(:integer, 1), 
        Token.new(:minus, '-'), 
        Token.new(:integer, 2)
      ]

      tree = Parser.new(tokens).parse
      expect(tree.class).to eql(ExprNode) 
      expect(tree.term.class).to eql(TermNode)
      expect(tree.term.value).to eql(1)

      op, term = tree.addopTerms
      expect(op.class).to eql(AddOpNode)
      expect(op.type).to eql(:minus)
      expect(term.class).to eql(TermNode) 
      expect(term.value).to eql(2)

      tokens = [
        Token.new(:integer, 1), 
        Token.new(:plus, '+'), 
        Token.new(:integer, 2)
      ]

      tree = Parser.new(tokens).parse
      expect(tree.class).to eql(ExprNode) 
      expect(tree.term.class).to eql(TermNode)
      expect(tree.term.value).to eql(1)

      op, term = tree.addopTerms
      expect(op.class).to eql(AddOpNode)
      expect(op.type).to eql(:plus)
      expect(term.class).to eql(TermNode) 
      expect(term.value).to eql(2)
    end

    it "parses expressions like '5+3-1'" do 
      tokens = [
        Token.new(:integer, 5), 
        Token.new(:plus, '+'), 
        Token.new(:integer, 3), 
        Token.new(:minus, '-'), 
        Token.new(:integer, 1) 
      ] 

      tree = Parser.new(tokens).parse
      expect(tree.class).to eql(ExprNode) 
      expect(tree.term.class).to eql(TermNode) 
      expect(tree.term.value).to eql(5) 

      addopTerms = tree.addopTerms
      expect(addopTerms[0].class).to eql(AddOpNode) 
      expect(addopTerms[0].type).to eql(:plus) 

      expect(addopTerms[1].class).to eql(TermNode) 
      expect(addopTerms[1].value).to eql(3) 

      expect(addopTerms[2].class).to eql(AddOpNode) 
      expect(addopTerms[2].type).to eql(:minus) 

      expect(addopTerms[3].class).to eql(TermNode) 
      expect(addopTerms[3].value).to eql(1) 
    end
  end
end
