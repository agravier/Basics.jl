module SkipLists

using Base
import ..AbstractDataStructure

export SkipList, ins!, del!, at, search, len, ordered_data_structure_p

struct _EOL end

Base.:(==)(::_EOL, ::Any) = false
Base.:(<)(::_EOL, ::Any) = false
Base.:(<)(::Any, ::_EOL) = true
Base.:(>)(::_EOL, ::Any) = true
Base.:(>)(::Any, ::_EOL) = false

EOL = _EOL()

mutable struct LaneNode{V}
    data::Union{V, _EOL}
    node_width::Int  # Number of nodes at the base lane until the next node at this lane
    next::Union{LaneNode, Nothing}
    lower_lane_node::Union{LaneNode, Nothing}
    higher_lane_node::Union{LaneNode, Nothing}
    function LaneNode{V}(
            data::Union{V, _EOL},
            node_width::Int,
            next::Union{LaneNode{V}, Nothing},
            lower_lane_node::Union{LaneNode, Nothing}
    ) where {V}
        @assert((data === EOL && next === nothing && node_width == 0) 
                || (data !== EOL && next !== nothing && node_width > 0))
        new{V}(data, node_width, next, lower_lane_node, nothing)
    end
end

LaneNode{V}() where {V} = LaneNode{V}(EOL, 0, nothing, nothing)

mutable struct SkipList{V} <: AbstractDataStructure.DataStructure{Int, V}
    p::Real  # The node lane promotion probability
    lanes::Vector{LaneNode{V}}  # where lanes[1] is the full list
    length::Int
    function SkipList{V}() where {V}
        lanes::Vector{LaneNode{V}} = [LaneNode{V}()]
        new{V}(0.5, lanes, 0)
    end
end

SkipList{V}(::Array{Any, 1}) where {V} = SkipList{V}()

function SkipList{V}(vec::Vector{V}) where {V}
    l = SkipList{V}()
    for e in vec
        ins!(l, e)
    end
    l
end

function Base.setproperty!(obj::SkipList, attr::Symbol, rhs)
    if attr == :p
        @assert(0 ≤ rhs ≤ 1)
    setfield!(obj, attr, rhs)

AbstractDataStructure.ordered_data_structure_p(::SkipList) = true

mutable struct SkipListPtr{V}
    skip_list::SkipList{V}
    lane::Int
    node::LaneNode{V}
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
end

"""
Find the first bottom-lane node with a value that is greater or equal to the given parameter.
If the search value is higher than any data in the list, return the bottom EOL node marking the
end of the list).
"""
function search_first_ge(l::SkipList{V}, val::V)::SkipListPtr{V} where {V}
    search_first_ge(SkipListPtr(l, length(l.lanes), last(l.lanes)), val)
end

function search_first_ge(ptr::SkipListPtr{V}, val::V)::SkipListPtr{V} where {V}
    while ptr.node.data < val
        prev = ptr.node
        ptr.node = ptr.node.next
    end
    if ptr.node.data == val || ptr.node.data === EOL
        return SkipListPtr(l, lane_idx, to_bottom_node(node))
    end
    ptr.lane -= ptr.lane
    ptr.node = prev.lower_lane_node
    search_first_ge(ptr, val)
end

"""
Find the last bottom-lane node with a value that is strictly lower than the given parameter.
If the search value is lower than any data in the list, return the bottom EOL node amrking the
end of the list).
"""
function search_last_lt(l::SkipList{V}, val::V)::Union{SkipListPtr{V}, Nothing} where {V}
    search_last_lt(SkipListPtr(l, length(l.lanes), last(l.lanes)), nothing, val)
end

function search_last_lt(
        ptr::SkipListPtr{V}, 
        previous::Union{LaneNode{V}, Nothing}, 
        val::V
)::Union{SkipListPtr{V}, Nothing} where {V}
    while ptr.node.data < val
        previous = ptr.node
        ptr.node = ptr.node.next
    end
    if ptr.node.data === EOL || ptr.node.data == val
        to_bottom_node!(previous)
        return previous
    end
    ptr.lane -= ptr.lane
    ptr.node = prev.lower_lane_node
    previous = previous.lower_lane_node
    search_last_lt(ptr, previous, val)
end

Base.iterate(l::SkipList) = l.lanes[1].data === EOL ? nothing : (l.data, l.next)
Base.iterate(::SkipList, state::LaneNode) = state.data === EOL ? nothing : (state.data, state.next)
Base.iterate(::SkipList, ::Nothing) = nothing


function create_new_node!(l::SkipList{V}, after::Union{SkipListPtr{V}, Nothing}, val::V) where {V}
    lanes_c = length(l.lanes)
    # Add more lanes if lanes_c < log_{1/p}(l.length+1)
    # Use l.p to climb lanes
    error("not implemented")
end

"""
ins!(ds::DataStructure, val::Value) -> Ref
"""
function AbstractDataStructure.ins!(l::SkipList{V}, val::V)::Int where {V}
    insert_ptr = search_last_lt(l, val)
    create_new_node!(l, insert_ptr, val)
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

end  # module SkipLists
