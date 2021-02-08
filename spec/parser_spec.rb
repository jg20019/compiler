require './lib/token.rb' 
require './lib/parser.rb' 

describe Parser do 
  describe "#parse" do 
    it "parses single number expressions" do 
      tokens = [Token.new(:integer, 1)]
      tree = Parser.new(tokens).parse
      expected_tree = 
        ExprNode.new(
          TermNode.new(
            FactorNode.new(1), []
          ), 
          []
        )
       
      expect(tree).to eql(expected_tree)
    end

    it "recognizes expressions like '1+1' and '2-1'" do
      tokens = [
        Token.new(:integer, 1), 
        Token.new(:minus, '-'), 
        Token.new(:integer, 2)
      ]

      expected_tree = 
        ExprNode.new(
          TermNode.new(
            FactorNode.new(1), 
            []
          ),
          [
            AddOpNode.new(:minus),
            TermNode.new(
              FactorNode.new(2), 
              []
            )
          ]
        )

      tree = Parser.new(tokens).parse
      expect(tree).to eql(expected_tree) 

      tokens = [
        Token.new(:integer, 1), 
        Token.new(:plus, '+'), 
        Token.new(:integer, 2)
      ]

      tree = Parser.new(tokens).parse
      expected_tree = 
        ExprNode.new(
          TermNode.new(
            FactorNode.new(1), []
          ), 
          [
            AddOpNode.new(:plus), 
            TermNode.new(
              FactorNode.new(2), [] 
            )
          ]
        )

      expect(tree).to eql(expected_tree) 
    end

    it "parses expressions like '5+3-1'" do 
      tokens = [
        Token.new(:integer, 5), 
        Token.new(:plus, '+'), 
        Token.new(:integer, 3), 
        Token.new(:minus, '-'), 
        Token.new(:integer, 1) 
      ] 

      expected_tree = ExprNode.new(
        TermNode.new(
          FactorNode.new(5), []
        ),
        [ AddOpNode.new(:plus), 
          TermNode.new(
            FactorNode.new(3), []), 
          AddOpNode.new(:minus), 
          TermNode.new(
            FactorNode.new(1), [])
        ] 
      )
      tree = Parser.new(tokens).parse
      expect(tree).to eql(expected_tree) 
    end

    it "parses expressions with multiplication and division" do
      tokens = [
        Token.new(:integer, 5), 
        Token.new(:star, '*'), 
        Token.new(:integer, 4)  
      ] 

      expected = ExprNode.new(
        TermNode.new(
          FactorNode.new(5), 
          [ MulOpNode.new(:star), 
            FactorNode.new(4)
          ]
        ),
        []
      ) 

      tree = Parser.new(tokens).parse
      expect(tree).to eql(expected) 
    end

    it "parses expressions with mixed precedence" do 
      tokens = [
        Token.new(:integer, 5), 
        Token.new(:star, '*'), 
        Token.new(:integer, 4), 
        Token.new(:plus, '+'), 
        Token.new(:integer, 3), 
      ] 

      expected = ExprNode.new(
        TermNode.new(
          FactorNode.new(5), 
          [ MulOpNode.new(:star), 
            FactorNode.new(4)
          ]), 
        [ AddOpNode.new(:plus), 
          TermNode.new(
            FactorNode.new(3), 
            [])
        ]) 

      tree = Parser.new(tokens).parse
      expect(tree).to eql(expected) 
    end

  end
end
