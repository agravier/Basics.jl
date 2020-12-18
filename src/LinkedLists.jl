module LinkedLists

using Base
import ..AbstractDataStructure

export LinkedList, ins!, del!, at, search, len, ordered_data_structure_p


struct _EOL end

EOL = _EOL()

mutable struct LinkedList{V} <: AbstractDataStructure.DataStructure{Int, V}
    data::Union{V, _EOL}
    tail::Union{LinkedList{V}, Nothing}
    function LinkedList{V}(data::Union{V, _EOL}, tail::Union{LinkedList{V}, Nothing}) where {V}
        @assert((data === EOL && tail === nothing) || (data !== EOL && tail !== nothing))
        new{V}(data, tail)
    end
end

LinkedList{V}() where {V} = LinkedList{V}(EOL, nothing)

LinkedList{V}(::Array{Any, 1}) where {V} = LinkedList{V}(EOL, nothing)

function LinkedList{V}(vec::Vector{V}) where {V}
    l = LinkedList{V}()
    for e in reverse(vec)
        l = LinkedList{V}(e, l)
    end
    l
end

AbstractDataStructure.ordered_data_structure_p(::LinkedList) = false

function hopn(l::LinkedList, n::Int)::LinkedList
    @assert(n ≥ 0)
    i = 0
    while i < n
        if l.data === EOL; throw(KeyError(n)) end
        l = l.tail
        i += 1
    end
    if l === nothing; throw(KeyError(n)) end
    l
end

Base.iterate(l::LinkedList) = l.data === EOL ? nothing : (l.data, l.tail)
Base.iterate(::LinkedList, state::LinkedList) = state.data === EOL ? nothing : (state.data, state.tail)
Base.iterate(::LinkedList, ::Nothing) = nothing

"""
ins!(ds::DataStructure, val::Value) -> Ref
"""
function AbstractDataStructure.ins!(l::LinkedList{V}, val::V)::Int where {V}
    l.tail = LinkedList{V}(l.data, l.tail)
    l.data = val
    1
end

"""
del!(ds::DataStructure, pos::Ref) -> Value
raises KeyError
"""
function AbstractDataStructure.del!(l::LinkedList{V}, pos::Int)::V where {V}
    @assert(pos > 0)
    to_delete = hopn(l, pos-1)
    if to_delete.data === EOL; throw(KeyError(pos)) end
    removed_data = to_delete.data
    to_delete.data = to_delete.tail.data
    to_delete.tail = to_delete.tail.tail
    removed_data
end

"""
at(ds::DataStructure, pos::Ref) -> Value
raises KeyError
"""
function AbstractDataStructure.at(l::LinkedList{V}, pos::Int)::V where {V}
    @assert(pos > 0)
    node = hopn(l, pos-1)
    if node.data === EOL; throw(KeyError(pos)) end
    node.data
end

"""
search(ds::DataStructure, val::Value) -> Vector{Ref}
"""
function AbstractDataStructure.search(ds::LinkedList{V}, val::V)::Vector{Int} where {V}
    return [i for (i, e) in enumerate(ds) if e == val]
end

"""
len(ds::DataStructure) -> Int
"""
function AbstractDataStructure.len(ds::LinkedList)::Int
    i = 0
    while ds.data != EOL; ds = ds.tail; i += 1 end
    i
end

_iobuf = IOBuffer()
printstyled(IOContext(_iobuf, :color => true), "[ ", color=:green)
_LIST_OPEN_COLOR = String(take!(_iobuf))
printstyled(IOContext(_iobuf, :color => true), " ]", color=:green)
_LIST_CLOSE_COLOR = String(take!(_iobuf))
printstyled(IOContext(_iobuf, :color => true), " → ", color=:light_green)
_LIST_SEP_COLOR = String(take!(_iobuf))
_iobuf = nothing


function Base.show(io::IO, x::LinkedList)
    if get(io, :color, false)
        open = _LIST_OPEN_COLOR
        close = _LIST_CLOSE_COLOR
        sep = _LIST_SEP_COLOR
    else
        open = "[ "
        close = " ]"
        sep = " → "
    end
    print(io, "LinkedList: " * open)
    join(io, x, sep)
    print(io, close)
end

end  # module LinkedLists
