struct Transitive{Op} <: Compound{Bool}
    arguments::Vector{Expression}
end

Transitive{Op}(args::Expression...) where Op = Transitive{Op}(collect(Expression, args))
(T::Type{<:Transitive})(arguments...) = T(map(Expression, arguments)...)

logicaltype(::Type{<:Transitive{Op}}) where Op = Transitive{Op}
op(relation::Transitive) = op(typeof(relation))
op(::Type{<:Transitive{Op}}) where Op = Op

args(relation::Transitive) = relation.arguments

print(io::IO, relation::Transitive) = print(io, infixstr(relation))

issymmetric(relation::Transitive) = issymmetric(logicaltype(relation))
issymmetric(::Type{<:Transitive}) = false

isreflexive(relation::Transitive) = isreflexive(logicaltype(relation))
isreflexive(::Type{<:Transitive}) = false