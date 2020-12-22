module AbstractDataStructure

"""
A mutable data structure addressed by type Ref, holding values of type Value.
"""
abstract type DataStructure{Ref, Value} end

"""
Predicate used to indicate that a data structure is inherently ordered.

ordered_data_structure_p(ds::DataStructure) -> Bool
"""
function ordered_data_structure_p end

"""
Insert a value in the data structure and return a reference to its location.
The reference is only valid in the current state of the data structure.

ins!(ds::DataStructure, val::Value) -> Ref
"""
function ins! end

"""
Delete an element from the data strucutre at lotation pos. 
Return the value that has been deleted

del!(ds::DataStructure, pos::Ref) -> Value
raises KeyError
"""
function del! end

"""
Return the value of the element at lotation pos. 

at(ds::DataStructure, pos::Ref) -> Value
raises KeyError
"""
function at end

"""
Find the locations of all elements with value val.
Return a vector of all found references.

search(ds::DataStructure, val::Value) -> Vector{Ref}
"""
function search end

"""
Return the number of elements in the data structure

len(ds::DataStructure) -> Integer
"""
function len end


Base.length(ds::DataStructure) = len(ds)

end  # module AbstractDataStructure
