def compute_fibonacci(index)
  if index <= 1
    index
  else
    compute_fibonacci(index - 1) + compute_fibonacci(index - 2)
  end
end

def compute_lucas(index)
  if index <= 1
    2
  elsif index == 2
    1
  else
    compute_lucas(index - 1) + compute_lucas(index - 2)
  end
end

def series(sequence, index)
  case sequence
  when "fibonacci" then compute_fibonacci(index)
  when "lucas"     then compute_lucas(index)
  else compute_fibonacci(index) + compute_lucas(index)
  end
end