import Base: exponent

"""
Expression representing `base^exponent`.
Complex values are allowed, defined by the standard branch cut in log, to match julia arithmetic.
"""
const Pow = Simple{^, 2}

@implement_binary_op(^)

base(power::Pow) = args(power)[1]
exponent(power::Pow) = args(power)[2]

print(io::IO, power::Pow) = print(io, "$(base(power))^$(exponent(power))")