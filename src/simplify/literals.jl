import ..Algebra

macro implement_literal_op(Op, T1, T2 = T1, valueOp = Op)    
    return quote
        function Algebra.trycombine(::Trivial, ::typeof($(esc(Op))), literal1::Literal{<:$(esc(T1))}, literal2::Literal{<:$(esc(T2))})
            combined_value = $(esc(valueOp))(literal1.value, literal2.value)

            Literal(combined_value)
        end
    end
end

# macro implement_symmetric_literal_op(Op, T1, T2, valueOp = Op)    
#     return quote
#         @implement_literal_op($(esc(Op)), $(esc(T1)), $(esc(T2)), $(esc(valueOp)))
#         @implement_literal_op($(esc(Op)), $(esc(T2)), $(esc(T1)), $(esc(valueOp)))
#     end
# end

@implement_literal_op(+, CLinear)
@implement_literal_op(*, CLinear)
