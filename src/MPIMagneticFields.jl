module MPIMagneticFields

using DocStringExtensions
using LinearAlgebra

"""
    $(TYPEDEF)

Abstract supertype for magnetic fields.

#The type is defined by `T`, the number of dimensions by `N` and the vector field dimension by `M`.
"""
abstract type AbstractMagneticField end

include("Traits.jl")
include("Common.jl")
include("Superposition.jl")
include("Grid.jl")
include("CommonFields.jl")

end