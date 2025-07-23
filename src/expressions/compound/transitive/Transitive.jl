struct Transitive{Op} <: Compound{Bool}
    arguments::Vector{Expression}
end

Transitive{Op}(args...) where Op = Transitive{Op}(collect(Iterators.map(Expression, args)))
(T::Type{<:Transitive})(arguments...) = T(map(Expression, arguments)...)

logicaltype(::Type{<:Transitive{Op}}) where Op = Transitive{Op}
op(operation::Transitive) = op(typeof(operation))
op(::Type{<:Transitive{Op}}) where Op = Op

args(relation::Transitive) = relation.arguments

print(io::IO, transitive::Transitive) = print(io, infixstr(transitive))

issymmetric(::Transitive) = false
isreflexive(::Transitive) = false