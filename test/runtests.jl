using Basics.AbstractDataStructure: DataStructure
using Basics.LinkedLists
using Basics.SkipLists
using Test

function test_order_via_interface(ds::DataStructure{Int, Int})
    @test issorted([i for i in ds])
    inserted_zero = ins!(ds, 0)
    inserted_three = ins!(ds, 3)
    inserted_minus_two = ins!(ds, -2)
    inserted_zero = ins!(ds, 1)
    inserted_zero = ins!(ds, 0)
    @test issorted([i for i in ds])
    del!(ds, search(ds, 1)[1])
    @test issorted([i for i in ds])
end

function test_correctness_via_interface(ds::DataStructure{Int, Int})
    # Results when empty
    @test len(ds) == 0
    @test_throws KeyError at(ds, 1)
    @test search(ds, 1) == Int[]
    @test_throws KeyError del!(ds, 1)
    # Insert one 0
    first_inserted = ins!(ds, 0)
    @test first_inserted isa Int
    @test at(ds, first_inserted) == 0
    @test len(ds) == 1
    @test search(ds, 0) == [first_inserted]
    @test search(ds, 1) == Int[]
    @test_throws KeyError del!(ds, first_inserted + 1)
    # Delete it and run some tests
    @test del!(ds, first_inserted) == 0
    @test_throws KeyError at(ds, first_inserted)
    @test search(ds, 0) == Int[]
    @test len(ds) == 0
    # Insert 0, 3, -2
    inserted_zero = ins!(ds, 0)
    @test at(ds, inserted_zero) == 0
    inserted_three = ins!(ds, 3)
    @test at(ds, inserted_three) == 3
    inserted_minus_two = ins!(ds, -2)
    @test at(ds, inserted_minus_two) == -2
    @test search(ds, -2) == [inserted_minus_two]
    @test (inserted_zero, inserted_three, inserted_minus_two) isa Tuple{Int,Int,Int}
    @test len(ds) == 3
    @test search(ds, 1) == Int[]
    @test_throws KeyError del!(ds, search(ds, -2)[1] * search(ds, 0)[1] * search(ds, 3)[1])
    # Delete 3, check that 0 and -2 are left
    three = del!(ds, search(ds, 3)[1])
    @test three == 3
    @test len(ds) == 2
    @test at(ds, search(ds, -2)[1]) == -2
    @test at(ds, search(ds, 0)[1]) == 0
    @test search(ds, 3) == Int[]
    @test at(ds, search(ds, -2)[1]) == -2
    # Insert another -2, check that there are two of them
    inserted_second_minus_two = ins!(ds, -2)
    @test length(search(ds, -2)) == 2
    @test length(search(ds, 0)) == 1
    @test len(ds) == 3
    # Empty and run order tests
    if ordered_data_structure_p(ds)
        del!(ds, search(ds, -2)[1])
        del!(ds, search(ds, -2)[1])
        del!(ds, search(ds, 0)[1])
        @test len(ds) == 0
        test_order_via_interface(ds)
    end
end

@testset "Basics.jl" begin
    test_correctness_via_interface(LinkedList{Int}())
    test_correctness_via_interface(SkipList{Int}())
end
