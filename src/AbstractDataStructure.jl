module AbstractDataStructure

abstract type Ref end
abstract type Value end
abstract type DataStructure{Ref, Value} end

"""
insert!(ds::DataStructure, val::Value) -> Ref
"""
function insert! end

"""
delete!(ds::DataStructure, pos::Ref) -> Value
raises KeyError
"""
function delete! end

"""
get(ds::DataStructure, pos::Ref) -> Value
raises KeyError
"""
function get end

"""
search(ds::DataStructure, val::Value) -> Union{Ref, Nothing}
"""
function search end

end  # module AbstractDataStructure
