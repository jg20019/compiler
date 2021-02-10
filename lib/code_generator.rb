class CodeGenerator
  def initialize(iostream=STDOUT) 
    @iostream = iostream
  end

  def expr?(tree)
    tree.class == Hash && tree.key?(:expr)
  end

  def term?(tree)
    tree.class == Hash && tree.key?(:term)
  end

  def factor?(tree)
    tree.class == Hash && tree.key?(:factor)
  end

  def generate(tree) 
    if expr? tree
      generateExpr tree
    elsif term? tree
      generateTerm tree
    elsif factor? tree
      generateFactor tree
    else 
      Error.abort "Unexpected tree '#{tree}'" 
    end
  end

  def generateExpr(tree) 
    if tree[:expr].class == Array
       generateTerm tree[:expr].first
       addition_operation_terms = tree[:expr].drop 1 
       until addition_operation_terms.empty? 
         operation, term = addition_operation_terms.shift 2
         emitLn "MOVE D0, -(SP)" 
         generateAdditionOperation operation[:operation], term
       end
    else 
      generateTerm(tree[:expr])
    end
  end

  def generateTerm(tree) 
    if tree[:term].class == Array
      generateFactor tree[:term].first 
      multiplication_operation_factors = tree[:term].drop 1
      until multiplication_operation_factors.empty? 
        operation, factor = multiplication_operation_factors.shift(2) 
        emitLn "MOVE D0, -(SP)" 
        generateMultiplicationOperation operation[:operation], factor
      end
    else 
      generateFactor tree[:term] 
    end
  end

  def generateFactor(tree) 
    if expr? tree[:factor]
      generateExpr(tree[:factor]) 
    else
      emitLn "MOVE ##{tree[:factor]}, D0" 
    end
  end

  def generateMultiplicationOperation(operation, factor) 
    case operation
    when :multiplication 
      generateMultiply factor
    when :division 
      generateDivide factor
    else 
      Error.expected "Mulop" 
    end 
  end

  def generateMultiply(factor) 
    generateFactor(factor) 
    emitLn "MULS (SP)+, D0" 
  end

  def generateDivide(factor) 
    generateFactor(factor) 
    emitLn "MOVE (SP)+, D1" 
    emitLn "DIVS D1, D0" 
  end

  def generateAdditionOperation(operation, term)  
    case operation
    when :addition
      generateAdd term
    when :subtraction
      generateSubtract term
    else 
      Error.expected "Addop" 
    end
  end

  def generateAdd(term) 
    generateTerm(term) 
    emitLn 'ADD (SP)+, D0'
  end

  def generateSubtract(term)
    generateTerm(term)
    emitLn 'SUB (SP)+, D0'
    emitLn 'NEG D0'
  end

  private 
  def emitLn(str)
    @iostream.puts("\t#{str}")
  end
end
