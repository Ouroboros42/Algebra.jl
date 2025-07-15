@testset "jointuples" begin
    using Algebra: jointuples

    @test jointuples() == ()
    @test jointuples((1,), (2, 3), (4, 5, 6)) == (1, 2, 3, 4, 5, 6)
end

@testset "adjacent" begin
    using Algebra: adjacent

    @test [(1, 2), (2, 3), (3, 4), (4, 5)] == collect(adjacent(1:5))
end

@testset "single_difference" begin
    using Algebra: map_single_difference

    @test isnothing(map_single_difference((x, y) -> x, [1, 2, 3], [1, 2]))
    @test isnothing(map_single_difference((x, y) -> x, [1, 2, 3], [1, 2, 3]))
    @test isnothing(map_single_difference((x, y) -> x, [1, 3, 2], [1, 2, 3]))
    @test isnothing(map_single_difference((x, y) -> nothing, [1, 2, 3, 5], [1, 2, 4, 5]))
    @test [1, 2, 7, 5] == map_single_difference(+, [1, 2, 3, 5], [1, 2, 4, 5])
end

@testset "map_one_extra" begin
    using Algebra: map_one_extra

    @test [1, 2, 9] == map_one_extra(x -> x - 1, [1, 2, 10], [1, 2])
    @test [1, 2, 11] == map_one_extra(x -> x + 1, [1, 2], [1, 2, 10])
    @test isnothing(map_one_extra(x -> x, [1, 2, 3], [1, 2, 3]))
    @test isnothing(map_one_extra(x -> x, [1, 2, 3], [1, 2, 3, 4, 5]))
    @test 1:5 == map_one_extra(x -> x, [1, 2, 3, 5], [1, 2, 3, 4, 5])
    @test isnothing(map_one_extra(x -> nothing, [1, 3, 4], [1, 5, 3, 4]))
end