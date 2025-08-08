tryimply(assumptions::Statement, expression::Expression) = firstresult(andargs(assumptions)) do assumption
    if assumption isa Equality && !isconst(expression) && any(isequal(expression), args(assumption))
        firstornothing(isconst, args(assumption))
    end
end

tryimply(assumptions::Statement, statement::Statement) = firstresult(andargs(assumptions)) do assumption
    if isequal(assumption, statement)
        return TRUE
    end

    if isequal(assumption, statement)
        return FALSE
    end

    @invoke tryimply(assumptions, statement::Expression)
end