using Basics.AbstractDataStructure: DataStructure, ins!, del!, at, search, len, ordered_data_structure_p
using Basics.LinkedLists #: LinkedList, ins!, del!, at, search, len, ordered_data_structure_p
using Basics.SkipLists #: SkipList, ins!, del!, at, search, len, ordered_data_structure_p

function test_order_via_interface(ds::DataStructure{Int, Int})
    println([i for i in ds])
    inserted_zero = ins!(ds, 0)
    inserted_three = ins!(ds, 3)
    inserted_minus_two = ins!(ds, -2)
    inserted_zero = ins!(ds, 1)
    inserted_zero = ins!(ds, 0)
    println(issorted([i for i in ds]))
    del!(ds, search(ds, 1)[1])
    println(issorted([i for i in ds]))
end

function test_correctness_via_interface(ds::DataStructure{Int, Int})
    # Results when empty
    println(len(ds) == 0)
    # @test_throws KeyError at(ds, 1)
    println(search(ds, 1) == Int[])
    # @test_throws KeyError del!(ds, 1)
    # Insert one 0
    first_inserted = ins!(ds, 0)
    println(first_inserted isa Int)
    println(at(ds, first_inserted) == 0)
    println(len(ds) == 1)
    println(search(ds, 0) == [first_inserted])
    println(search(ds, 1) == Int[])
    # @test_throws KeyError del!(ds, first_inserted + 1)
    # Delete it and run some tests
    println(del!(ds, first_inserted) == 0)
    # @test_throws KeyError at(ds, first_inserted)
    println(search(ds, 0) == Int[])
    println(len(ds) == 0)
    # Insert 0, 3, -2
    inserted_zero = ins!(ds, 0)
    println(at(ds, inserted_zero) == 0)
    inserted_three = ins!(ds, 3)
    println(at(ds, inserted_three) == 3)
    inserted_minus_two = ins!(ds, -2)
    println(at(ds, inserted_minus_two) == -2)
    println(search(ds, -2) == [inserted_minus_two])
    println((inserted_zero, inserted_three, inserted_minus_two) isa Tuple{Int,Int,Int})
    println(len(ds) == 3)
    println(search(ds, 1) == Int[])
    # @test_throws KeyError del!(ds, search(ds, -2)[1] * search(ds, 0)[1] * search(ds, 3)[1])
    # Delete 3, check that 0 and -2 are left
    three = del!(ds, search(ds, 3)[1])
    println(three == 3)
    println(len(ds) == 2)
    println(at(ds, search(ds, -2)[1]) == -2)
    println(at(ds, search(ds, 0)[1]) == 0)
    println(search(ds, 3) == Int[])
    println(at(ds, search(ds, -2)[1]) == -2)
    # Insert another -2, check that there are two of them
    inserted_second_minus_two = ins!(ds, -2)
    println(length(search(ds, -2)) == 2)
    println(length(search(ds, 0)) == 1)
    println(len(ds) == 3)
    # Empty and run order tests
    if ordered_data_structure_p(ds)
        del!(ds, search(ds, -2)[1])
        del!(ds, search(ds, -2)[1])
        del!(ds, search(ds, 0)[1])
        println(len(ds) == 0)
        test_order_via_interface(ds)
    end
end


test_correctness_via_interface(SkipList{Int}())


# l = Basics.SkipLists.SkipList{Int}([i for i in 1:3])
# for i in 1:20
#     println(l.lanes)
#     Basics.AbstractDataStructure.del!(l, 1)
#     Basics.AbstractDataStructure.ins!(l, 0)
# end