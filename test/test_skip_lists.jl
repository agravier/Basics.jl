using Test
using Random
using Basics.AbstractDataStructure: DataStructure, ins!, del!, at, search, len, ordered_data_structure_p
using Basics.SkipLists: HEAD, EOL, SkipList, SkipListPtr, LaneNode, add_lanes!, adjust_lane_count!, create_new_node!, delete_lanes!, hopn, nhops, search_last_lt, target_lane_count

TestType = Union{Float64, Int, String}

function create_skip_list(t::T, lane_structure::Matrix{Bool})::SkipList{T} where {T <: TestType}
    lane_count, elem_count = size(lane_structure)
    if T == String
        elems = Vector{T}(undef, elem_count)
        for i in 1:length(elems)
            elems[i] = randstring()
        end
    else
        elems = rand(T, elem_count)
    end
    sort!(elems)
    lanes = Vector{LaneNode{T}}(undef, lane_count)
    lower_lane_node = nothing
    for i in 1:lane_count
        lanes[i] = LaneNode{T}(HEAD, 1, nothing, lower_lane_node, nothing)
        if lower_lane_node !== nothing
            lower_lane_node.higher_lane_node = lanes[i]
        end
        lower_lane_node = lanes[i]
    end
    current_nodes::Vector{LaneNode{T}} = copy(lanes)
    for (j, e) in enumerate(elems)
        lower_lane_node = nothing
        for (i, flag) in enumerate(lane_structure[:, j])
            if flag
                new_node = LaneNode{T}(e, 1, nothing, lower_lane_node, nothing)
                if lower_lane_node !== nothing
                    lower_lane_node.higher_lane_node = new_node
                end
                current_nodes[i].next = new_node
                current_nodes[i] = new_node
                lower_lane_node = new_node
            else
                current_nodes[i].node_width += 1
            end
        end
    end
    lower_lane_node = nothing
    for i in 1:lane_count
        new_node = LaneNode{T}(EOL, 0, nothing, lower_lane_node, nothing)
        if lower_lane_node !== nothing
            lower_lane_node.higher_lane_node = new_node
        end
        current_nodes[i].next = new_node
        lower_lane_node = new_node
    end
    sl = SkipList{T}(elems)
    sl.lanes = lanes
    sl
end

# function hopn(l::SkipList, n::Int)::Vector{LaneNode}

# function hopn(ptr::SkipListPtr, result_vec::Vector{LaneNode}, n::Int)::Vector{LaneNode}

function test_hopn()
    int_3_0 = create_skip_list(0, [true true true; false false false])
    float_3_3 = create_skip_list(0.1, [true true true; true true true])
    string_3_1 = create_skip_list("", [true true true; false true false])
    # int_3_0
    @test hopn(int_3_0, 0) == int_3_0.lanes
    hopn__int_3_0__1 = hopn(int_3_0, 1)
    @test hopn__int_3_0__1[1] == int_3_0.lanes[1].next
    @test hopn__int_3_0__1[2] == int_3_0.lanes[2]
    hopn__int_3_0__2 = hopn(int_3_0, 2)
    @test hopn__int_3_0__2[1] == int_3_0.lanes[1].next.next
    @test hopn__int_3_0__2[2] == int_3_0.lanes[2]
    hopn__int_3_0__3 = hopn(int_3_0, 3)
    @test hopn__int_3_0__3[1] == int_3_0.lanes[1].next.next.next
    @test hopn__int_3_0__3[2] == int_3_0.lanes[2]
    hopn__int_3_0__4 = hopn(int_3_0, 4)
    @test hopn__int_3_0__4[1].data === EOL
    @test hopn__int_3_0__4[2].data === EOL
    # float_3_3
    @test hopn(float_3_3, 0) == float_3_3.lanes
    hopn__float_3_3__1 = hopn(float_3_3, 1)
    @test hopn__float_3_3__1[1] == float_3_3.lanes[1].next
    @test hopn__float_3_3__1[2] == float_3_3.lanes[2].next
    hopn__float_3_3__2 = hopn(float_3_3, 2)
    @test hopn__float_3_3__2[1] == float_3_3.lanes[1].next.next
    @test hopn__float_3_3__2[2] == float_3_3.lanes[2].next.next
    hopn__float_3_3__3 = hopn(float_3_3, 3)
    @test hopn__float_3_3__3[1] == float_3_3.lanes[1].next.next.next
    @test hopn__float_3_3__3[2] == float_3_3.lanes[2].next.next.next
    hopn__float_3_3__4 = hopn(float_3_3, 4)
    @test hopn__float_3_3__4[1].data === EOL
    @test hopn__float_3_3__4[2].data === EOL
    # string_3_1
    @test hopn(string_3_1, 0) == string_3_1.lanes
    hopn__string_3_1__1 = hopn(string_3_1, 1)
    @test hopn__string_3_1__1[1] == string_3_1.lanes[1].next
    @test hopn__string_3_1__1[2] == string_3_1.lanes[2]
    hopn__string_3_1__2 = hopn(string_3_1, 2)
    @test hopn__string_3_1__2[1] == string_3_1.lanes[1].next.next
    @test hopn__string_3_1__2[2] == string_3_1.lanes[2].next
    hopn__string_3_1__3 = hopn(string_3_1, 3)
    @test hopn__string_3_1__3[1] == string_3_1.lanes[1].next.next.next
    @test hopn__string_3_1__3[2] == string_3_1.lanes[2].next
    hopn__string_3_1__4 = hopn(string_3_1, 4)
    @test hopn__string_3_1__4[1].data === EOL
    @test hopn__string_3_1__4[2].data === EOL
end

# function search_last_lt(l::SkipList{V}, val::V)::Tuple{Vector{LaneNode{V}}, Int} where {V}

# function search_last_lt(
#         ptr::SkipListPtr{V},
#         result_vec::Vector{LaneNode{V}},
#         val::V
# )::Tuple{Vector{LaneNode{V}}, Int} where {V}

function test_search_last_lt()

end

# function add_lanes!(l::SkipList{V}, how_many::Int) where {V}

function test_add_lanes!()

end


# function delete_lanes!(l::SkipList{V}, how_many::Int) where {V}

function test_delete_lanes!()

end

# function target_lane_count(lane_promotion_probability::Real, elem_count::Int)::Int

function test_target_lane_count()

end

# function adjust_lane_count!(l::SkipList, elem_count::Int)

function test_adjust_lane_count!()

end

# function nhops(a::LaneNode, b::LaneNode)::Union{Int, Nothing}

function test_create_new_node!()

end


# function create_new_node!(promotion_p::Real, after::Vector{LaneNode{V}}, val::V) where {V}

function test_create_new_node!()

end


@testset "SkipLists.jl" begin
    test_hopn()
    test_search_last_lt()
    test_add_lanes!()
    test_delete_lanes!()
    test_target_lane_count()
    test_adjust_lane_count!()
    test_create_new_node!()
    test_create_new_node!()
end

