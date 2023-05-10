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
    return value(field, r, δ)
  elseif isRotatable(field)
    return value(field, r, ϕ)
  else
    value(field, r)
  end
end

# With time dimension
value(::AbstractMagneticField, t::VT, r::PT) where {VT <: Number, T <: Number, PT <: AbstractVector{T}} = isTimeVarying(field) ? error("Not yet implemented") : value(field, r)
value(field::AbstractMagneticField, t::VT, r::PT, ϕ::RT) where {VT <: Number, T <: Number, PT <: AbstractVector{T}, RT <: Number} = isTimeVarying(field) && isRotatable(field) ? error("Not yet implemented") : value(field, t, r)
value(field::AbstractMagneticField, t::VT, r::PT, δ::TT) where {VT <: Number, T <: Number, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = isTimeVarying(field) && isTranslatable(field) ? error("Not yet implemented") : value(field, t, r)
function value(field::AbstractMagneticField, t::VT, r::PT, ϕ::RT, δ::TT) where {VT <: Number, T <: Number, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} 
  if isTimeVarying(field) && isTranslatable(field) && isRotatable(field)
    error("Not yet implemented")
  elseif isTimeVarying(field) && isTranslatable(field)
    return value(field, t, r, δ)
  elseif isTimeVarying(field) && isRotatable(field)
    return value(field, t, r, ϕ)
  else
    value(field, t, r)
  end
end

value(field::AbstractMagneticField, r::PT) where {T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}} = [value(field, [r_...]) for r_ in Iterators.product(r...)]
value(field::AbstractMagneticField, r::PT, ϕ::RT) where {T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, RT <: Number} = [value(field, [r_...], ϕ) for r_ in Iterators.product(r...)]
value(field::AbstractMagneticField, r::PT, δ::TT) where {T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = [value(field, [r_...], δ) for r_ in Iterators.product(r...)]
value(field::AbstractMagneticField, r::PT, ϕ::RT, δ::TT) where {T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} = [value(field, [r_...], ϕ, δ) for r_ in Iterators.product(r...)]

# With time dimension
value(field::AbstractMagneticField, t::VT, r::PT) where {VT <: Number, T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}} = [value(field, t, [r_...]) for r_ in Iterators.product(r...)]
value(field::AbstractMagneticField, t::VT, r::PT, ϕ::RT) where {VT <: Number, T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, RT <: Number} = [value(field, t, [r_...], ϕ) for r_ in Iterators.product(r...)]
value(field::AbstractMagneticField, t::VT, r::PT, δ::TT) where {VT <: Number, T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = [value(field, t, [r_...], δ) for r_ in Iterators.product(r...)]
value(field::AbstractMagneticField, t::VT, r::PT, ϕ::RT, δ::TT) where {VT <: Number, T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} = [value(field, t, [r_...], ϕ, δ) for r_ in Iterators.product(r...)]

value(field::AbstractMagneticField, t::VT, r::PT) where {VT <: AbstractRange, T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}} = [value(field, tr[1], [tr[2:end]...]) for tr in Iterators.product(t, r...)]
value(field::AbstractMagneticField, t::VT, r::PT, ϕ::RT) where {VT <: AbstractRange, T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, RT <: Number} = [value(field, tr[1], [tr[2:end]...], ϕ) for tr in Iterators.product(t, r...)]
value(field::AbstractMagneticField, t::VT, r::PT, δ::TT) where {VT <: AbstractRange, T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = [value(field, tr[1], [tr[2:end]...], δ) for tr in Iterators.product(t, r...)]
value(field::AbstractMagneticField, t::VT, r::PT, ϕ::RT, δ::TT) where {VT <: AbstractRange, T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} = [value(field, t[1], [tr[2:end]...], ϕ, δ) for tr in Iterators.product(t, r...)]

# Mixed vectors of ranges and scalars are Vector{Any} which does not have a dispatch yet; anything else will fail
value(field::AbstractMagneticField, r::PT) where {T <: Any, PT <: AbstractVector{T}} = value(field, convert(Vector{Union{<:AbstractRange, Number}}, r))
value(field::AbstractMagneticField, r::PT, ϕ::RT) where {T <: Any, PT <: AbstractVector{T}, RT <: Number} = value(field, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ)
value(field::AbstractMagneticField, r::PT, δ::TT) where {T <: Any, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = value(field, convert(Vector{Union{<:AbstractRange, Number}}, r), δ)
value(field::AbstractMagneticField, r::PT, ϕ::RT, δ::TT) where {T <: Any, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} = value(field, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ, δ)

value(field::AbstractMagneticField, t::VT, r::PT) where {VT <: Number, T <: Any, PT <: AbstractVector{T}} = value(field, t, convert(Vector{Union{<:AbstractRange, Number}}, r))
value(field::AbstractMagneticField, t::VT, r::PT, ϕ::RT) where {VT <: Number, T <: Any, PT <: AbstractVector{T}, RT <: Number} = value(field, t, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ)
value(field::AbstractMagneticField, t::VT, r::PT, δ::TT) where {VT <: Number, T <: Any, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = value(field, t, convert(Vector{Union{<:AbstractRange, Number}}, r), δ)
value(field::AbstractMagneticField, t::VT, r::PT, ϕ::RT, δ::TT) where {VT <: Number, T <: Any, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} = value(field, t, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ, δ)

value(field::AbstractMagneticField, t::VT, r::PT) where {VT <: AbstractRange, T <: Any, PT <: AbstractVector{T}} = value(field, t, convert(Vector{Union{<:AbstractRange, Number}}, r))
value(field::AbstractMagneticField, t::VT, r::PT, ϕ::RT) where {VT <: AbstractRange, T <: Any, PT <: AbstractVector{T}, RT <: Number} = value(field, t, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ)
value(field::AbstractMagneticField, t::VT, r::PT, δ::TT) where {VT <: AbstractRange, T <: Any, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = value(field, t, convert(Vector{Union{<:AbstractRange, Number}}, r), δ)
value(field::AbstractMagneticField, t::VT, r::PT, ϕ::RT, δ::TT) where {VT <: AbstractRange, T <: Any, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} = value(field, t, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ, δ)

include("Traits.jl")
include("Common.jl")
include("Superposition.jl")
include("Grid.jl")
include("CommonFields/CommonFields.jl")

end