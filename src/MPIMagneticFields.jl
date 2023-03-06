module MPIMagneticFields

using DocStringExtensions
using LinearAlgebra

export AbstractMagneticField
"""
    $(TYPEDEF)

Abstract supertype for magnetic fields.
"""
abstract type AbstractMagneticField end

# TODO: Document functions
export value
value(::AbstractMagneticField, r) = error("Not yet implemented")

export rotate!
rotate!(::AbstractMagneticField, ϕ) = error("Not yet implemented")

export translate!
translate!(::AbstractMagneticField, r) = error("Not yet implemented")

include("Traits.jl")
include("Common.jl")
include("Superposition.jl")
include("Grid.jl")
include("CommonFields.jl")

end