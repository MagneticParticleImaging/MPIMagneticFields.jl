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
value(::AbstractMagneticField, r::PT) where {T <: Number, PT <: AbstractVector{T}} = error("Not yet implemented")
value(field::AbstractMagneticField, r::PT, ϕ::RT) where {T <: Number, PT <: AbstractVector{T}, RT <: Number} = isRotatable(field) ? error("Not yet implemented") : value(field, r)
value(field::AbstractMagneticField, r::PT, δ::TT) where {T <: Number, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = isTranslatable(field) ? error("Not yet implemented") : value(field, r)
function value(field::AbstractMagneticField, r::PT, ϕ::RT, δ::TT) where {T <: Number, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} 
  if isTranslatable(field) && isRotatable(field)
    error("Not yet implemented")
  elseif isTranslatable(field)
    return value(field, δ)
  elseif isRotatable(field)
    return value(field, ϕ)
  else
    value(field, r)
  end
end

include("Traits.jl")
include("Common.jl")
include("Superposition.jl")
include("Grid.jl")
include("CommonFields.jl")

end