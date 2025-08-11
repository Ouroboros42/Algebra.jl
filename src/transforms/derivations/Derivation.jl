abstract type Derivation end

apply(::Derivation, literal::Literal) = zero(literal)
apply(derivation::Derivation, sum::Sum) = map(apply(derivation), sum)
apply(derivation::Derivation, ifelse::IfElse) = mapbranches(apply(derivation), ifelse)

function apply(derivation::Derivation, prod::Prod)
    sum(iargs(prod)) do (i, arg)
        replaceat(prod, i, apply(derivation, arg))
    end
end

apply(derivation::Derivation, f::Sin) = apply(derivation, arg(f)) * cos(arg(f))
apply(derivation::Derivation, f::Cos) = -apply(derivation, arg(f)) * sin(arg(f))

function apply(derivation::Derivation, pow::Pow)
    basederiv, expderiv = map(apply(derivation), args(pow))
    base, exponent = pow

    baseterm = if iszero(basederiv)
        zero(pow)
    else
        if commutes(base, basederiv)
            exponent * basederiv * base ^ (exponent - one(exponent))
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