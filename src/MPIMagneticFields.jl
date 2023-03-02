module MPIMagneticFields

using DocStringExtensions

"""
    $(TYPEDEF)

Abstract supertype for magnetic fields.

The type is defined by `T`, the number of dimensions by `N` and the vector field dimension by `M`.
"""
abstract type AbstractMagneticField{T, N, M} where {T <: Number, N <: Integer, M <: Integer} end

include("Traits.jl")
include("Common.jl")
include("Superposition.jl")
include("Grid.jl")
#include("SpecialFields.jl")

end