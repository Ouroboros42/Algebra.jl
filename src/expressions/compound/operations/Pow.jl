const Pow = NFunc{^, 2}

base(power::Pow) = args(power)[1]
exponent(power::Pow) = args(power)[2]

print(io::IO, power::Pow) = print(io, "$(base(power))^$(exponent(power))")