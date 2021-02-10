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
        {expr: {term: {factor: 1}}}

      iostream = MockIOStream.new
      generator = CodeGenerator.new(iostream) 
      generator.generate(tree)
      expect(iostream.lines[0]).to eql("\tMOVE #1, D0")
    end
  end 

  describe "#generate" do 
    it "generates code for simple addition" do 
      tree = 
        {expr: 
         [{term: {factor: 5}}, 
          {operation: :addition}, 
          {term: {factor: 2}}]}

      expected_output = [
        "\tMOVE #5, D0", 
        "\tMOVE D0, -(SP)", 
        "\tMOVE #2, D0", 
        "\tADD (SP)+, D0"
      ]

      iostream = MockIOStream.new
      generator = CodeGenerator.new(iostream) 
      generator.generate(tree)
      expect(iostream.lines).to eql(expected_output)
    end

    it "generates code for simple subtraction" do 
      tree = 
        {expr: 
         [{term: {factor: 10}},
          {operation: :subtraction}, 
          {term: {factor: 3}}]}

      expected_output = [
        "\tMOVE #10, D0", 
        "\tMOVE D0, -(SP)", 
        "\tMOVE #3, D0", 
        "\tSUB (SP)+, D0", 
        "\tNEG D0"
      ] 

      iostream = MockIOStream.new
      generator = CodeGenerator.new(iostream)
      generator.generate(tree) 
      expect(iostream.lines).to eql(expected_output) 
    end 

    it "generates code for expressions with multiple terms" do 

      tree = 
        {expr: 
         [{term: {factor: 5}},
          {operation: :addition},
          {term: {factor: 3}},
          {operation: :subtraction},
          {term: {factor: 1}}]}

      expected_output = [
        "\tMOVE #5, D0", 
        "\tMOVE D0, -(SP)", 
        "\tMOVE #3, D0", 
        "\tADD (SP)+, D0", 
        "\tMOVE D0, -(SP)", 
        "\tMOVE #1, D0", 
        "\tSUB (SP)+, D0", 
        "\tNEG D0" 
      ] 

      iostream = MockIOStream.new
      generator = CodeGenerator.new(iostream)
      generator.generate(tree)
      expect(iostream.lines).to eql(expected_output) 
    end 

    it "generates code for multiplication" do 
      tree = 
        {expr: 
         {term: 
          [{factor: 5},
           {operation: :multiplication},
           {factor: 4}]}}

      expected_output = [
        "\tMOVE #5, D0", 
        "\tMOVE D0, -(SP)",
        "\tMOVE #4, D0",
        "\tMULS (SP)+, D0",
      ] 

      iostream = MockIOStream.new
      generator = CodeGenerator.new(iostream)
      generator.generate(tree) 
      expect(iostream.lines).to eql(expected_output)
    end

    it "generates code for division" do 
      tree = 
        {expr: 
         {term: 
          [{factor: 77},
           {operation: :division},
           {factor: 11}]}}

      expected_output = [
        "\tMOVE #77, D0", 
        "\tMOVE D0, -(SP)",
        "\tMOVE #11, D0",
        "\tMOVE (SP)+, D1", 
        "\tDIVS D1, D0",
      ] 

      iostream = MockIOStream.new
      generator = CodeGenerator.new(iostream)
      generator.generate(tree) 
      expect(iostream.lines).to eql(expected_output)
    end

    it "generates code for expressions with parentheses" do 
      tree = 
        {expr: 
         {term: 
          [{factor: 
            {expr: 
             [{term: {factor: 3}}, 
              {operation: :addition}, 
              {term: {factor: 4}}]}}, 
           {operation: :multiplication},
           {factor: 5}]}}

      expected_output = [
        "\tMOVE #3, D0",
        "\tMOVE D0, -(SP)",
        "\tMOVE #4, D0",
        "\tADD (SP)+, D0",
        "\tMOVE D0, -(SP)",
        "\tMOVE #5, D0",
        "\tMULS (SP)+, D0"
      ]
 
      iostream = MockIOStream.new
      generator = CodeGenerator.new(iostream)
      generator.generate(tree)
      expect(iostream.lines).to eql(expected_output) 
    end
  end
end
