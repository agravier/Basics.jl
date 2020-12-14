module LinkedLists

include("./AbstractDataStructure.jl")

using Base
import .AbstractDataStructure: DataStructure

# export LinkedList, insert!, delete!, get, search

struct _EOL end

EOL = _EOL()

mutable struct LinkedList{V} <: DataStructure{Integer, V}
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


function hopn(l::LinkedList, n::Integer) :: LinkedList
    @assert(n ≥ 0)
    i = 0
    while i < n
        if l.data === EOL; throw(KeyError(n)) end
        next = l.tail
        i += 1
    end
    if  l === nothing; throw(KeyError(n)) end
    l
end

Base.iterate(l::LinkedList) = l.data === EOL ? nothing : (l.data, l.tail)
Base.iterate(::LinkedList, state::LinkedList) = state.data === EOL ? nothing : (state.data, state.tail)
Base.iterate(::LinkedList, ::Nothing) = nothing

"""
insert!(ds::DataStructure, val::Value) -> Ref
"""
function insert!(l::LinkedList{V}, val::V) :: Integer where {V}
    l.tail = LinkedList{V}(l.data, l.tail)
    l.data = val
    1
end

"""
delete!(ds::DataStructure, pos::Ref) -> Value
raises KeyError
"""
function delete!(l::LinkedList{V}, pos::Integer) :: V where {V}
    @assert(pos > 0)
    to_delete = hopn(l, pos-1)
    if to_delete.data === EOL; throw(KeyError(pos)) end
    removed_data = to_delete.data
    println(to_delete)
    println(to_delete.tail)
    to_delete.data = to_delete.tail.data
    to_delete.tail = to_delete.tail.tail
    removed_data
end

"""
getat(ds::DataStructure, pos::Ref) -> Value
raises KeyError
"""
function getat(l::LinkedList{V}, pos::Integer) :: V where {V}
    @assert(pos > 0)
    hopn(l, pos-1).data
end

"""
search(ds::DataStructure, val::Value) -> Union{Ref, Nothing}
"""
function search end

_iobuf = IOBuffer()
printstyled(IOContext(_iobuf, :color => true), "[ ", color=:green)
_LIST_OPEN_COLOR = String(take!(_iobuf))
printstyled(IOContext(_iobuf, :color => true), " ]", color=:green)
_LIST_CLOSE_COLOR = String(take!(_iobuf))
printstyled(IOContext(_iobuf, :color => true), " → ", color=:light_green)
_LIST_SEP_COLOR = String(take!(_iobuf))
_iobuf = nothing


function Base.show(io::IO, x)
    if get(io, :color, false)
        open = _LIST_OPEN_COLOR
        close = _LIST_CLOSE_COLOR
        sep = _LIST_SEP_COLOR
    else
        open = "[ "
        close = " ]"
        sep = " → "
    end
    print(io, "LinkedList" * open)
    join(io, x, sep)
    print(io, close)
end

end  # module LinkedLists
