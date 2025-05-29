export @var

const TYPE_SHORTHANDS = Dict(
    :R => :Real,
    :C => :Complex,
    :Z => :Signed,
    :N => :Unsigned,
)

macro var(name::QuoteNode, type = :Real, equality_by_name = :true)
    vartype = get(TYPE_SHORTHANDS, type, esc(type))

    quote
        global $(esc(name.value)) = Variable{$(vartype)}($name, $(esc(equality_by_name)))
    end
end

macro var(name::Symbol, type = :Real, equality_by_name = :true)
    quote
        @var($(QuoteNode(name)), $type, $equality_by_name)
    end
end