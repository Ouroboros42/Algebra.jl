const TYPE_SHORTHANDS = Dict(
    :R => :Real,
    :C => :Complex,
    :Z => :Signed,
    :N => :Unsigned,
    :Q => :Rational,
    :B => :Bool
)

macro var(name::QuoteNode, type = :Real, equality_by_name = :true)
    vartype = get(TYPE_SHORTHANDS, type, esc(type))

    quote
        global $(esc(name.value)) = Variable{$(vartype)}($name, $(esc(equality_by_name)))
    end
end

macro var(name::Symbol, args...)
    quote
        @var($(QuoteNode(name)), $(args...))
    end
end

macro var(names::Expr, args...)
    if names.head != :tuple; throw(ArgumentError("names must be a symbol or tuple of symbols, got $names")) end

    Expr(:tuple, map(names.args) do name
        :( @var($name, $(args...)) )
    end...)
end