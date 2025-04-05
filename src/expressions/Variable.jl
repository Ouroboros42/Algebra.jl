export Variable, @var

import Base: ==

abstract type Variable{T} <: Expression{T} end

mutable struct UniqueVariable{T, S <: AbstractString} <: Variable{T}
    name::S
end

struct VariableByName{T, S <: AbstractString} <: Variable{T}
    name::S
end

name(variable::Union{UniqueVariable, VariableByName}) = variable.name

Variable{T}(name::S, equality_by_name::Bool = false) where {T, S} = if equality_by_name
    VariableByName{T, S}(name)
else
    UniqueVariable{T, S}(name)
end

==(var1::VariableByName{T}, var2::VariableByName{T}) where T = name(var1) == name(var2) 

macro var(name::Symbol, type = :Real, equality_by_name = :true)
    varname = string(name)

    return :( $(esc(name)) = Variable{$(esc(type))}($varname, $(esc(equality_by_name))) )
end

print(io::IO, variable::Variable) = print(io, name(variable))
show(io::IO, ::MIME"text/plain", variable::VariableByName{T}) where T = print(io, "$(name(variable)) ∈ $T")
show(io::IO, ::MIME"text/plain", variable::UniqueVariable{T}) where T = print(io, "$(name(variable))#$(objectid(variable)) ∈ $T")
    



