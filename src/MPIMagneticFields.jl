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
export fieldType
fieldType(::AbstractMagneticField) = @error "Not yet implemented"

export definitionType
definitionType(::AbstractMagneticField) = @error "Not yet implemented"

export timeDependencyType
timeDependencyType(::AbstractMagneticField) = @error "Not yet implemented"

export gradientFieldType
gradientFieldType(::AbstractMagneticField) = @error "Not yet implemented"

export value
value(::AbstractMagneticField, r) = @error "Not yet implemented"

export rotate!
rotate!(::AbstractMagneticField, ϕ) = @error "Not yet implemented"

export translate!
translate!(::AbstractMagneticField, r) = @error "Not yet implemented"

include("Traits.jl")
include("Common.jl")
include("Superposition.jl")
include("Grid.jl")
include("CommonFields.jl")

end