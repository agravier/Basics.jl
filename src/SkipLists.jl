module SkipLists

using Base
import ..AbstractDataStructure: DataStructure

export SkipList, ins!, del!, at, search, len, ordered_data_structure_p

struct _EOL end

EOL = _EOL()

mutable struct LaneNode{V}
    data::Union{V, _EOL}
    node_width::Int  # Number of nodes at the base lane until the tail at this lane
    tail::Union{LaneNode, Nothing}
    lower_lane_node::Union{LaneNode, Nothing}
    higher_lane_node::Union{LaneNode, Nothing}
    function LaneNode{V}(
            data::Union{V, _EOL},
            node_width::Int,
            tail::Union{LaneNode{V}, Nothing},
            lower_lane_node::Union{LaneNode, Nothing}
    ) where {V}
        @assert((data === EOL && tail === nothing && node_width == 0) 
                || (data !== EOL && tail !== nothing && node_width > 0))
        new{V}(data, node_width, tail, lower_lane_node, nothing)
    end
end

mutable struct SkipList{V} <: DataStructure{Int, V}
    lanes::Vector{LaneNode{V}}  # where lanes[1] is the full list
    length::Int
    function SkipList{V}() where {V}
        lanes::Vector{LaneNone{V}} = []
        new{V}(lanes, 0)
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

ordered_data_structure_p(::SkipList) = true

mutable struct SkipListPtr{V}
    skip_list::SkipList{V}
    lane::Int
    node::LaneNode{V}
end

function hopn(l::SkipList, n::Int)::SkipListPtr
    @assert(n ≥ 0)
    i = 0
    # Iterate at highest lane, accummulating node_width while remaining under n.
    # Then go to the next lane and repeat until index n is found
    error("unimplemented")
end

Base.iterate(l::SkipList) = l.lanes[1].data === EOL ? nothing : (l.data, l.tail)
Base.iterate(::SkipList, state::LaneNode) = state.data === EOL ? nothing : (state.data, state.tail)
Base.iterate(::SkipList, ::Nothing) = nothing

"""
ins!(ds::DataStructure, val::Value) -> Ref
"""
function ins!(l::SkipList{V}, val::V)::Int where {V}
    error("unimplemented")
end

"""
del!(ds::DataStructure, pos::Ref) -> Value
raises KeyError
"""
function del!(l::SkipList{V}, pos::Int)::V where {V}
    @assert(pos > 0)
    to_delete = hopn(l, pos-1)
    error("unimplemented")
end

"""
at(ds::DataStructure, pos::Ref) -> Value
raises KeyError
"""
function at(l::SkipList{V}, pos::Int)::V where {V}
    @assert(pos > 0)
    ptr = hopn(l, pos-1)
    if ptr.node.data === EOL; throw(KeyError(pos)) end
    ptr.node.data
end

"""
search(ds::DataStructure, val::Value) -> Vector{Ref}
"""
function search(ds::SkipList{V}, val::V)::Vector{Int} where {V}
    error("unimplemented")
end

"""
len(ds::DataStructure) -> Int
"""
function len(ds::SkipList)::Int
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
    print(io, "SkipList with $(x.length) elements and $(length(x.lanes)) lanes: " * open)
    join(io, x, sep)
    print(io, close)
end

end  # module SkipLists
