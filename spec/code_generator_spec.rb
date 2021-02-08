require './lib/node.rb' 
require './lib/code_generator.rb' 

class MockIOStream 
  attr_reader :lines

  def initialize()
    @lines = []
  end

  def puts(s)  
    @lines << s
  end 
end 

describe CodeGenerator do 
  describe "#generate" do 
    it "generates code for a single number expression" do 
      tree = 
        ExprNode.new(
          TermNode.new(
            FactorNode.new(1), []
          ), 
          []
        )

      iostream = MockIOStream.new
      generator = CodeGenerator.new(iostream) 
      generator.generate(tree)
      expect(iostream.lines[0]).to eql("\tMOVE #1, D0")
    end
  end 

  describe "#generate" do 
    it "generates code for expressions like '1+1'" do 
      tree = 
        ExprNode.new(
          TermNode.new(
            FactorNode.new(1), 
            []
          ),
          [
            AddOpNode.new(:plus),
            TermNode.new(
              FactorNode.new(1), 
              []
            )
          ]
        )

      expected_output = [
        "\tMOVE #1, D0", 
        "\tMOVE D0, D1", 
        "\tMOVE #1, D0", 
        "\tADD D1, D0"
      ]

      iostream = MockIOStream.new
      generator = CodeGenerator.new(iostream) 
      generator.generate(tree)
      expect(iostream.lines).to eql(expected_output)
    end

    it "generates code for expressions like '2-1'" do 
      tree = 
        ExprNode.new(
          TermNode.new(
            FactorNode.new(2), []
          ), 
          [
            AddOpNode.new(:minus), 
            TermNode.new(
              FactorNode.new(1), [] 
            )
          ]
        )

      expected_output = [
        "\tMOVE #2, D0", 
        "\tMOVE D0, D1", 
        "\tMOVE #1, D0", 
        "\tSUB D1, D0", 
        "\tNEG D0"
      ] 

      iostream = MockIOStream.new
      generator = CodeGenerator.new(iostream)
      generator.generate(tree) 
      expect(iostream.lines).to eql(expected_output) 
    end 

    it "generates code for expressions like '5+3-1'" do 
      tree = ExprNode.new(
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
      expected_output = [
        "\tMOVE #5, D0", 
        "\tMOVE D0, D1", 
        "\tMOVE #3, D0", 
        "\tADD D1, D0", 
        "\tMOVE D0, D1", 
        "\tMOVE #1, D0", 
        "\tSUB D1, D0", 
        "\tNEG D0" 
      ] 

      iostream = MockIOStream.new
      generator = CodeGenerator.new(iostream)
      generator.generate(tree)
      expect(iostream.lines).to eql(expected_output) 
    end 
  end
end
