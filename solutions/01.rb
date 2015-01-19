def compute_sequence(first, second, index)
  (index - 1).times do
    second = first + second
    first = second - first
  end
  first
end

def series(sequence, index)
  case sequence
  when "fibonacci" then compute_sequence(1, 1, index)
  when "lucas"     then compute_sequence(2, 1, index)
  else compute_sequence(1, 1, index) + compute_sequence(2, 1, index)
  end
end