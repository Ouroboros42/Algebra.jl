macro tryreturn(expr)
    quote
        local value = $(esc(expr))
        
        if !isnothing(value)
            return value
        end
    end
end

macro returnnothing(expr)
    quote
        local value = $(esc(expr))
        
        if isnothing(value); return end

        value
    end
end

macro ordefault(expr, default)
    quote
        local value = $(esc(expr))

        if isnothing(value)
            $(esc(default))
        else
            value
        end
    end
end

mapsome(f, ::Nothing) = nothing
mapsome(f, arg) = f(arg)

mapsome(f, args...) = if !any(isnothing, args)
    f(args...)
end

forsome(f, ::Nothing) = nothing
function forsome(f, arg)
    f(arg)
    arg
end

onlyornothing(collection) = isone(length(collection)) ? only(collection) : nothing
firstornothing(collection) = onlyornothing(first(collection, 1))
firstornothing(f, collection) = firstornothing(Iterators.filter(f, collection))
firstresult(f, collection) = for item in collection
    @tryreturn f(item)
end

maybeinteger(n) = if isinteger(n); convert(Integer, n) end