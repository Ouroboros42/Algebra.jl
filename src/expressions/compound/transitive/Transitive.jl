struct Transitive{Op} <: Compound{Bool}
    arguments::Vector{Expression}
end

Transitive{Op}(args...) where Op = Transitive{Op}(collect(Iterators.map(Expression, args)))

optype(::Type{<:Transitive{Op}}) where Op = Transitive{Op}

args(relation::Transitive) = relation.arguments

function print(io::IO, transitive::Transitive{Op}) where Op
    if isempty(args(transitive))
        return print(io, "`EMPTY $Op`")
    end

    argstr = join(args(transitive), " $Op ")

    print(io, "($argstr)")
end