module SkipLists

using Base
import ..AbstractDataStructure

export SkipList, ins!, del!, at, search, len, ordered_data_structure_p

struct _EOL end
struct _HEAD end

Base.:(==)(::_EOL, ::Any) = false
Base.:(<)(::_EOL, ::Any) = false
Base.:(<)(::Any, ::_EOL) = true
Base.:(>)(::_EOL, ::Any) = true
Base.:(>)(::Any, ::_EOL) = false

Base.:(==)(::_HEAD, ::Any) = true
Base.:(<)(::_HEAD, ::Any) = true
Base.:(<)(::Any, ::_HEAD) = false
Base.:(>)(::_HEAD, ::Any) = false
Base.:(>)(::Any, ::_HEAD) = true

EOL = _EOL()
HEAD = _HEAD()

mutable struct LaneNode{V}
    data::Union{V, _HEAD, _EOL}
    node_width::Int  # Number of nodes at the base lane until the next node at this lane
    next::Union{LaneNode, Nothing}
    lower_lane_node::Union{LaneNode, Nothing}
    higher_lane_node::Union{LaneNode, Nothing}
    function LaneNode{V}(
            data::Union{V, _HEAD, _EOL},
            node_width::Int,
            next::Union{LaneNode{V}, Nothing},
            lower_lane_node::Union{LaneNode{V}, Nothing},
            higher_lane_node::Union{LaneNode{V}, Nothing},
    ) where {V}
        @assert((data === EOL && next === nothing && node_width == 0) 
                || (data !== EOL && next !== nothing && node_width > 0))
        new{V}(data, node_width, next, lower_lane_node, higher_lane_node)
    end
end

lower_lane_repr(l::LaneNode)::String = l.lower_lane_node===nothing ? "⤈" : "↓"
higher_lane_repr(l::LaneNode)::String = l.higher_lane_node===nothing ? "⤉" : "↑"
width_repr(l::LaneNode)::String = "w:$(l.node_width)"

# Lane iteration over all data nodes
Base.iterate(l::LaneNode) = ((l.data, width_repr(l), lower_lane_repr(l), higher_lane_repr(l)), l.next)
Base.iterate(::LaneNode, state::LaneNode) = ((
    state.data, width_repr(state), lower_lane_repr(state), higher_lane_repr(state)), state.next)
Base.iterate(::LaneNode, ::Nothing) = nothing

mutable struct SkipList{V} <: AbstractDataStructure.DataStructure{Int, V}
    p::Real  # The lane promotion probability for new nodes
    lanes::Vector{LaneNode{V}}  # where lanes[1] is the full lane
    length::Int
    function SkipList{V}() where {V}
        end_node = LaneNode{V}(EOL, 0, nothing, nothing, nothing)
        start_node = LaneNode{V}(HEAD, 1, end_node, nothing, nothing)
        lanes::Vector{LaneNode{V}} = [start_node]
        new{V}(0.5, lanes, 0)
    end
end

SkipList{V}(::Array{Any, 1}) where {V} = SkipList{V}()

function SkipList{V}(vec::Vector{V}) where {V}
    l = SkipList{V}()
    adjust_lane_count!(l, length(vec))
    for e in vec
        insert_nodes, _ = search_last_lt(l, e)
        create_new_node!(l.p, insert_nodes, e)
    end
    l.length = length(vec)
    l
end

function Base.setproperty!(obj::SkipList, attr::Symbol, rhs)
    if attr == :p
        @assert(0 < rhs < 1)
    end
    setfield!(obj, attr, rhs)
end 

AbstractDataStructure.ordered_data_structure_p(::SkipList) = true

mutable struct SkipListPtr{V}
    skip_list::SkipList{V}
    lane::Int
    node::LaneNode{V}
    bottom_idx::Int
end

function hopn(l::SkipList, n::Int)::SkipListPtr
    @assert(n ≥ 0)
    i = 0
    # Iterate at highest lane, accummulating node_width while remaining under n.
    # Then go to the next lane and repeat until index n is found. 
    # Return to the corresponding node at lowest lane.
    error("unimplemented")
end

function to_bottom_node(n::LaneNode)::LaneNode 
    while n.lower_lane_node !== nothing
        n = n.lower_lane_node
    end
    n
end

function to_bottom_node!(ptr::Union{SkipListPtr, Nothing})
    while ptr.node.lower_lane_node !== nothing
        ptr.node = ptr.node.lower_lane_node
    end
    ptr.lane = 1
end

"""
Find all lanes's last nodes with a value that is strictly lower than val, and the bottom-lane 
index. If the search value is lower than any data in the list, it will be the vector of all 
HEADs, and an index of 0.
"""
function search_last_lt(l::SkipList{V}, val::V)::Tuple{Vector{LaneNode{V}}, Int} where {V}
    if l.lanes[1].next === missing
        throw("Corrupted SkipList, missing a HEAD or EOL node.")
    end
    result_vec = Vector{LaneNode{V}}(undef, length(l.lanes))
    search_last_lt(SkipListPtr(l, length(l.lanes), last(l.lanes), 1), result_vec, val)
end

function search_last_lt(
        ptr::SkipListPtr{V},
        result_vec::Vector{LaneNode{V}},
        val::V
)::Tuple{Vector{LaneNode{V}}, Int} where {V}
    previous = undef
    while ptr.node.data < val
        previous = ptr.node
        ptr.node = ptr.node.next
        ptr.bottom_idx += previous.node_width
    end
    # We have overshot: backtrack
    result_vec[ptr.lane] = previous
    if ptr.lane > 1
        # and go one lane lower if possible
        ptr.lane -= 1
        ptr.node = previous.lower_lane_node
        ptr.bottom_idx -= previous.node_width
    else  # ptr.lane == 1
        # We are at the bottom lane, we have our result
        @assert(ptr.node.lower_lane_node === nothing && !(undef in result_vec))
        return result_vec, ptr.bottom_idx
    end
    search_last_lt(ptr, result_vec, val)
end

Base.iterate(l::SkipList) = iterate(l, l.lanes[1].next)  # Skip the HEAD
Base.iterate(::SkipList, state::LaneNode) = state.data === EOL ? nothing : (state.data, state.next)
Base.iterate(::SkipList, ::Nothing) = nothing

function add_lanes!(l::SkipList{V}, how_many::Int) where {V}
    head_top_node = last(l.lanes)
    eol_top_node = head_top_node
    while eol_top_node.data !== EOL; eol_top_node = head_top_node.next end
    top_lane_idx = length(l.lanes)
    new_lanes_vector = Vector{LaneNode{V}}(undef, top_lane_idx + how_many)
    copyto!(new_lanes_vector, CartesianIndices(l.lanes), l.lanes, CartesianIndices(l.lanes))
    lower_lane_head = head_top_node
    lower_lane_eol = eol_top_node
    for i in top_lane_idx+1 : top_lane_idx+how_many
        eol = LaneNode{V}(EOL, 0, nothing, lower_lane_eol, nothing)
        lower_lane_eol.higher_lane_node = eol
        head = LaneNode{V}(HEAD, 1, eol, lower_lane_head, nothing)
        lower_lane_head.higher_lane_node = head
        lower_lane_eol = eol
        lower_lane_head = head
        new_lanes_vector[i] = head
    end
    # Run stochastic promotion on all nodes sticking out of the previous top lane
    for node in head_top_node
        # TODO(agravier)
    end
    l.lanes = new_lanes_vector
end


function delete_lanes!(l::SkipList{V}, how_many::Int) where {V}
    throw("not implemented")
end


function target_lane_count(lane_promotion_probability::Real, elem_count::Int)::Int
    Int(ceil(log(1/lane_promotion_probability, elem_count))) + 1
end

"""
elem_count: new number of elements
"""
function adjust_lane_count!(l::SkipList, elems_count::Int)
    lane_c = length(l.lanes)
    target_lane_c = target_lane_count(l.p, elems_count)
    δ = target_lane_c - lane_c
    if δ > 0
        add_lanes!(l, δ)
    elseif δ < 0
        delete_lanes!(l, abs(δ))
    end
end

function nhops(a::LaneNode, b::LaneNode)::Union{Int, Nothing}
    i = 0
    while a != b
        i += 1
        a = a.next
        if a === nothing
            return nothing
        end
    end
    i
end

"""
`after` is a slice of the lanes after which the new node should be introduced.
This DOES NOT increase the `length` attribute of the skiplist.
This DOES NOT create new lanes when necessary.
""" 
function create_new_node!(promotion_p::Real, after::Vector{LaneNode{V}}, val::V) where {V}
    lower_node = nothing
    promote = true
    for i in 1:length(after)
        if promote
            # Insert node: update all links and counts
            prev = after[i]
            next = prev.next
            lower_prev_node = prev.lower_lane_node
            lower_next_node = next.lower_lane_node
            lower_prev_width_to_anchor = lower_node === nothing ? 1 : nhops(lower_prev_node, lower_node)
            lower_next_width_from_anchor = lower_node === nothing ? 1 : nhops(lower_node, lower_next_node)
            new_node = LaneNode{V}(val, lower_next_width_from_anchor, next, lower_node, nothing)
            prev.next = new_node
            prev.node_width = lower_prev_width_to_anchor
            if lower_node !== nothing
                lower_node.higher_lane_node = new_node
            end
            lower_node = new_node
            promote = rand(Float64) < promotion_p
        else
            # No more node promotion: update upper lanes's previous node width 
            after[i].node_width += 1      
        end
    end
end

"""
ins!(ds::DataStructure, val::Value) -> Ref
"""
function AbstractDataStructure.ins!(l::SkipList{V}, val::V)::Int where {V}
adjust_lane_count!(l, l.length+1)
    insert_nodes, bottom_prev_idx = search_last_lt(l, val)
    create_new_node!(l.p, insert_nodes, val)
    l.length += 1
    bottom_prev_idx + 1
end

"""
del!(ds::DataStructure, pos::Ref) -> Value
raises KeyError
"""
function AbstractDataStructure.del!(l::SkipList{V}, pos::Int)::V where {V}
    @assert(pos > 0)
    to_delete = hopn(l, pos-1)
    error("unimplemented")
end

"""
at(ds::DataStructure, pos::Ref) -> Value
raises KeyError
"""
function AbstractDataStructure.at(l::SkipList{V}, pos::Int)::V where {V}
    @assert(pos > 0)
    ptr = hopn(l, pos-1)
    if ptr.node.data === EOL; throw(KeyError(pos)) end
    ptr.node.data
end

"""
search(ds::DataStructure, val::Value) -> Vector{Ref}
"""
function AbstractDataStructure.search(ds::SkipList{V}, val::V)::Vector{Int} where {V}
    error("unimplemented")
end

"""
len(ds::DataStructure) -> Int
"""
function AbstractDataStructure.len(ds::SkipList)::Int
    return ds.length
end

_iobuf = IOBuffer()
printstyled(IOContext(_iobuf, :color => true), "[ ", color=:green)
_LIST_OPEN_COLOR = String(take!(_iobuf))
printstyled(IOContext(_iobuf, :color => true), " ]", color=:green)
_LIST_CLOSE_COLOR = String(take!(_iobuf))
printstyled(IOContext(_iobuf, :color => true), " → ", color=:light_green)
_LIST_SEP_COLOR = String(take!(_iobuf))
_iobuf = nothing

function Base.show(io::IO, x::SkipList)
    if get(io, :color, false)
        open = _LIST_OPEN_COLOR
        close = _LIST_CLOSE_COLOR
        sep = _LIST_SEP_COLOR
    else
        open = "[ "
        close = " ]"
        sep = " → "
    end
    lane_c = length(x.lanes)
    el_word = "element" * (x.length>1 ? "s" : "")
    l_word = "lane" * (lane_c>1 ? "s" : "")
    print(io, "SkipList with $(x.length) $el_word and $(lane_c) $l_word: " * open)
    join(io, x, sep)
    print(io, close)
end

_iobuf = IOBuffer()
printstyled(IOContext(_iobuf, :color => true), "⟦ ", color=:red)
_LANE_NODE_OPEN_COLOR = String(take!(_iobuf))
printstyled(IOContext(_iobuf, :color => true), " ⟧", color=:red)
_LANE_NODE_CLOSE_COLOR = String(take!(_iobuf))
printstyled(IOContext(_iobuf, :color => true), " → ", color=:light_red)
_LANE_NODE_SEP_COLOR = String(take!(_iobuf))
_iobuf = nothing

function Base.show(io::IO, x::LaneNode)
    if get(io, :color, false)
        open = _LANE_NODE_OPEN_COLOR
        close = _LANE_NODE_CLOSE_COLOR
        sep = _LANE_NODE_SEP_COLOR
    else
        open = "⟦ "
        close = " ⟧"
        sep = " → "
    end
    print(io, open)
    join(io, x, sep)
    print(io, close)
end

end  # module SkipLists
