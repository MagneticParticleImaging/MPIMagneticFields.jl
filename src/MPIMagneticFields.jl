module MPIMagneticFields

using DocStringExtensions
using LinearAlgebra

export AbstractMagneticField
"""
    $(TYPEDEF)

Abstract supertype for magnetic fields.
"""
abstract type AbstractMagneticField end

export value
"""
    $(SIGNATURES)

Retrieve the value of a magnetic field at position `r`.
"""
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

value(field::AbstractMagneticField, r::PT) where {T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}} = [value(field, [r_...]) for r_ in Iterators.product(r...)]
value(field::AbstractMagneticField, r::PT, ϕ::RT) where {T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, RT <: Number} = [value(field, [r_...], ϕ) for r_ in Iterators.product(r...)]
value(field::AbstractMagneticField, r::PT, δ::TT) where {T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = [value(field, [r_...], δ) for r_ in Iterators.product(r...)]
value(field::AbstractMagneticField, r::PT, ϕ::RT, δ::TT) where {T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} = [value(field, [r_...], ϕ, δ) for r_ in Iterators.product(r...)]

# Mixed vectors of ranges and scalars are Vector{Any} which does not have a dispatch yet; anything else will fail
value(field::AbstractMagneticField, r::PT) where {T <: Any, PT <: AbstractVector{T}} = value(field, convert(Vector{Union{<:AbstractRange, Number}}, r))
value(field::AbstractMagneticField, r::PT, ϕ::RT) where {T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, RT <: Number} = value(field, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ)
value(field::AbstractMagneticField, r::PT, δ::TT) where {T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = value(field, convert(Vector{Union{<:AbstractRange, Number}}, r), δ)
value(field::AbstractMagneticField, r::PT, ϕ::RT, δ::TT) where {T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} = value(field, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ, δ)

include("Traits.jl")
include("Common.jl")
include("Superposition.jl")
include("Grid.jl")
include("CommonFields.jl")

end