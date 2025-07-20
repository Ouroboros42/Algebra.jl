const Equality = @operator Transitive{==}

# Prevent `isequal` fallback to `==` which is now non-boolean
isequal(expr::Expression, other) = false
isequal(other, expr::Expression) = false
isequal(expr1::Expression, expr2::Expression) = false