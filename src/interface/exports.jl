# Core interface
export @var, Variable, Literal
export simplify

# Expressions types - ideally rarely needed
export Expression
export Sum, Prod, Pow

# Simplifiers
export NoSimplify, Trivial
export MergeSame
export StandardSimplifiers