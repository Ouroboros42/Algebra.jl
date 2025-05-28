@var x Real
@var z Complex

@testset "associative" begin
    @test isequal((x + 1) + z, x + (1 + z))
    @test isequal((x * 2) * z, x * (2 * z))
end

@testset "commutative" begin
    @test isequal(x + 1 + z, z + 1 + x)
    @test isequal(x * 2 * z, z * 2 * x)
end

@testset "constants combine" begin
    @test isequal(x + z + 3, x + 2 + z + 1)
end
