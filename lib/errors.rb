class Error
  def self.expected(x) 
    raise "Expected: '#{x}'" 
  end

  def self.abort(msg)
    raise msg 
  end
end
