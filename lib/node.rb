
# File containing all of the defined node types.
# Used in parser.rb and code_generator.rb

IntegerNode = Struct.new(:value) 
AddOpNode = Struct.new(:type) # :plus or :minus
ExprNode = Struct.new(:op1, :addop, :op2) 
