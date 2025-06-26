macro tryreturn(expr)
    return quote
        local value = $(esc(expr))
        
        if !isnothing(value)
            return value
        end
    end
end

macro returnnothing(expr)
    return quote
        local value = $(esc(expr))
        
        if isnothing(value); return end

        value
    end
end

mapsome(f, ::Nothing) = nothing
mapsome(f, arg) = f(arg)

forsome(f, ::Nothing) = nothing
function forsome(f, arg)
    f(arg)
    arg
end

onlyornothing(collection) = isone(length(collection)) ? only(collection) : nothing
firstornothing(collection) = onlyornothing(first(collection, 1))
firstornothing(f, collection) = firstornothing(Iterators.filter(f, collection))

maybeinteger(n) = if isinteger(n); convert(Integer, n) end