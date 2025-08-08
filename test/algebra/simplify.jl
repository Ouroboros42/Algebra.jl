function simplify_test(condition, exprs::Expression...)
    simplified = simplify.(exprs)

    condition(simplified...) || "Failed $condition: $(join(simplified, ", "))"
end

simplify_equal(expr1, expr2) = simplify_test(isequal, expr1, expr2)
simplify_unequal(expr1, expr2) = simplify_test(!isequal, expr1, expr2)

@testset "associative" begin
    @test simplify_equal((x + 1) + z, x + (1 + z))
    @test simplify_equal((x * 2) * z, x * (2 * z))
end

@testset "commutative" begin
    @test simplify_equal(x + 1 + z, z + 1 + x)
    @test simplify_equal(x * 2 * z, z * 2 * x)
    @test simplify_unequal(A * B, B * A)
    @test simplify_equal(A * x^2 * B, A * x * B * x)
end

@testset "constants combine" begin
    @test simplify_equal(x + z + 3, x + 2 + z + 1)
    @test simplify_equal(x + π + z + 1, Sum(sort([x, z, Literal(π), Literal(1)])))
end

@testset "compound" begin
    @test simplify_equal(z * (2x + 2x), 4x*z)
end

@testset "square" begin
    @test simplify_equal(x * x, x^2)
    @test simplify_equal(x^2 * y * x^2, y * x^4)
    @test simplify_equal(x * x * x, x^3)
end

@testset "polynomials" begin
    @test simplify_equal(x^2 + x + x^2 + 3 + 2 * x^2, 4 * x^2 + x + 3)
end

@testset "equality" begin
    @test simplify_equal((x == y) & (y == 1), (x == y) & (x == 1))
    @test simplify_equal((x == 1) & (x == 2), Literal(false))
    @test simplify_equal(c == false, !c)
end

@testset "ifelse" begin
    @test simplify_equal(ifelse(c, x + 1, x - 1) + 10, ifelse(c, x + 11, x + 9))
    @test simplify_equal(ifelse(c, x, y) * ifelse(d, x^2, y^2) - 1, ifelse(c, ifelse(d, x^3 - 1, x * y^2 - 1), ifelse(d, x^2 * y - 1, y^3 - 1)))
    @test simplify_equal(ifelse(c, x + 2, x + 2), x + 2)
    @test simplify_equal(ifelse(x == 1, x + 1, 2x), 2x)
end