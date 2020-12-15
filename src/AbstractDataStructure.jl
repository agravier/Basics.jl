module AbstractDataStructure

abstract type DataStructure{Ref, Value} end

"""
ins!(ds::DataStructure, val::Value) -> Ref
"""
function ins! end

"""
del!(ds::DataStructure, pos::Ref) -> Value
raises KeyError
"""
function del! end

"""
at(ds::DataStructure, pos::Ref) -> Value
raises KeyError
"""
function at end

"""
search(ds::DataStructure, val::Value) -> Vector{Ref}
"""
function search end

"""
len(ds::DataStructure) -> Integer
"""
function len end

end  # module AbstractDataStructure
