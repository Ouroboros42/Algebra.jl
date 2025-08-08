abstract type Derivation end

apply(::Derivation, literal::Literal) = zero(literal)
apply(derivation::Derivation, sum::Sum) = map(apply(derivation), sum)
apply(derivation::Derivation, ifelse::IfElse) = mapbranches(apply(derivation), ifelse)

function apply(derivation::Derivation, prod::Prod)
    Sum(map(iargs(prod)) do (i, arg)
        replaceat(prod, i, apply(derivation, arg))
    end)
end

function apply(derivation::Derivation, pow::Pow)
    basederiv, expderiv = map(apply(derivation), args(pow))
    base, exponent = pow

    baseterm = if iszero(basederiv)
        zero(pow)
    else
        if commutes(base, basederiv)
            exponent * basederiv * base ^ (exponent - 1)
        else
            throw("Non-commuting power derivatives not yet implemented")
        end
    end

    expterm = if iszero(expderiv)
        zero(pow)
    else
        expderiv * log(base) * pow
    end

    baseterm + expterm
end