export @var

macro var(name::QuoteNode, type = :Real, equality_by_name = :true)
    quote
        global $(esc(name.value)) = Variable{$(esc(type))}($name, $(esc(equality_by_name)))
    end
end

macro var(name::Symbol, type = :Real, equality_by_name = :true)
    quote
        @var($(QuoteNode(name)), $type, $equality_by_name)
    end
end