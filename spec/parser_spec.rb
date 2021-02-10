require './lib/token.rb' 
require './lib/parser.rb' 

describe Parser do 
  describe "#parse" do 
    it "raises error when parsing no tokens" do 
      expect { Parser.new([]).parse }.to raise_error(RuntimeError) 
    end

    it "raises RuntimeError when first part of expression is not an integer" do
      expect { Parser.new([Token.new(:plus, '+')]).parse }.to raise_error(RuntimeError) 
    end

    it "parses single number expressions" do 
      tokens = [Token.new(:integer, 1)]
      tree = Parser.new(tokens).parse
      expected_tree = 
        {expr: {term: {factor: 1}}}

      expect(tree).to eql(expected_tree)
    end

    it "parses simple addition" do 
      tokens = [
        Token.new(:integer, 5), 
        Token.new(:plus, '+'), 
        Token.new(:integer, 2)
      ]

      expected = 
        {expr: 
         [{term: {factor: 5}}, 
          {operation: :addition}, 
          {term: {factor: 2}}]}
  
      expect(Parser.new(tokens).parse).to eql(expected) 
    end

    it "parses simple subtraction" do
      tokens = [
        Token.new(:integer, 10), 
        Token.new(:minus, '-'), 
        Token.new(:integer, 3)
      ]

      expected = 
        {expr: 
         [{term: {factor: 10}},
          {operation: :subtraction}, 
          {term: {factor: 3}}]}

      expect(Parser.new(tokens).parse).to eql(expected)
    end

    it "parses expressions with multiple terms" do 
      tokens = [
        Token.new(:integer, 5), 
        Token.new(:plus, '+'), 
        Token.new(:integer, 3), 
        Token.new(:minus, '-'), 
        Token.new(:integer, 1) 
      ] 

      expected = 
        {expr: 
         [{term: {factor: 5}},
          {operation: :addition},
          {term: {factor: 3}},
          {operation: :subtraction},
          {term: {factor: 1}}]}

      expect(Parser.new(tokens).parse).to eql(expected) 
    end

    it "parses simple multiplication" do
      tokens = [
        Token.new(:integer, 5), 
        Token.new(:star, '*'), 
        Token.new(:integer, 4)  
      ] 
    
      expected = 
        {expr: 
         {term: 
          [{factor: 5},
           {operation: :multiplication},
           {factor: 4}]}}
      
      expect(Parser.new(tokens).parse).to eql(expected)

    end
    it "parses simple division" do
    
      tokens = [
        Token.new(:integer, 77), 
        Token.new(:slash, '/'), 
        Token.new(:integer, 11) 
      ]

      expected = 
        {expr: 
         {term: 
          [{factor: 77},
           {operation: :division},
           {factor: 11}]}}

      expect(Parser.new(tokens).parse).to eql(expected) 
    end

    it "parses expressions with mixed precedence" do 
      tokens = [
        Token.new(:integer, 5), 
        Token.new(:star, '*'), 
        Token.new(:integer, 4), 
        Token.new(:plus, '+'), 
        Token.new(:integer, 3), 
      ] 

      expected = 
        {expr: 
         [{term: 
           [{factor: 5},
            {operation: :multiplication},
            {factor: 4}]},
          {operation: :addition},
          {term: {factor: 3}}]}

      tree = Parser.new(tokens).parse
      expect(tree).to eql(expected) 
    end

    it "parses expressions with parentheses" do 
      tokens = [ 
        Token.new(:lparen, '('),
        Token.new(:integer, 3),
        Token.new(:plus, '+'),
        Token.new(:integer, 4),
        Token.new(:rparen, ')'),
        Token.new(:star, '*'),
        Token.new(:integer, 5)
      ] 

      expected = 
        {expr: 
         {term: 
          [{factor: 
            {expr: 
             [{term: {factor: 3}}, 
              {operation: :addition}, 
              {term: {factor: 4}}]}}, 
           {operation: :multiplication},
           {factor: 5}]}}

      expect(Parser.new(tokens).parse).to eql(expected) 
    end
  end
end
