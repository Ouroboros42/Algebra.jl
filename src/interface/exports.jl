# Core interface
export @var, Variable, Literal
export simplify

# Expressions types - ideally rarely needed
export Expression, valtype, args

export Sum, Prod
export Pow, base, exponent

# Simplifiers
export NoSimplify, Trivial
export MergeSame
export StandardSimplifiers