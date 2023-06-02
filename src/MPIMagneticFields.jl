module MPIMagneticFields

using DocStringExtensions
using LinearAlgebra

export μ₀
"Vacuum magnetic permeability for usage within the field definitions"
const μ₀ = 1.25663706212e-6

export AbstractMagneticField
"""
    $(TYPEDEF)

Abstract supertype for magnetic fields.
"""
abstract type AbstractMagneticField end

include("Traits.jl")

"""
    $(SIGNATURES)

Retrieve the value of a magnetic field.

The order of arguments varies depending on the traits of the actual type.
With a time varying field, the first argument is the time `t`.
Otherwise the position `r` is the first parameter.
The rotation angle `ϕ` is the next parameter if the field is rotatable,
otherwise it is the shift vektor `δ`.
Note: The underscore is important!
"""
function value_(field::AbstractMagneticField, args...; kargs...)
  return error(
    "Field type `$(typeof(field))` must implement internal function `value_`. Note: The underscore is important!",
  )
end

export value
"""
    $(SIGNATURES)

Retrieve the value of a magnetic field.

# The order of arguments varies depending on the traits of the actual type.
# With a time varying field, the first argument is the time `t`.
# Otherwise the position `r` is the first parameter.
# The rotation angle `ϕ` is the next parameter if the field is rotatable,
# otherwise it is the shift vektor `δ`.
"""
function value(field::AbstractMagneticField, args...; kwargs...)
  return value(FieldTimeDependencyStyle(field), field, args...; kwargs...)
end

#TODO: Shorten by generator function
function value(::TimeConstant, field::AbstractMagneticField, args...; kwargs...)
  return value(
    FieldTimeDependencyStyle(field),
    FieldMovementStyle(field),
    field,
    args...;
    kwargs...,
  )
end

function value(
  ::TimeConstant,
  ::NoMovement,
  field::AbstractMagneticField,
  r::PT;
  kwargs...,
) where {T <: Number, PT <: AbstractVector{T}}
  return value_(field, r)
end
function value(
  ::TimeConstant,
  ::NoMovement,
  field::AbstractMagneticField,
  r::PT;
  kwargs...,
) where {T <: Any, PT <: AbstractVector{T}}
  return [
    value(
      FieldTimeDependencyStyle(field),
      FieldMovementStyle(field),
      field,
      [r_...];
      kwargs...,
    ) for r_ ∈ Iterators.product(r...)
  ]
end

function value(
  ::TimeConstant,
  ::RotationalMovement,
  field::AbstractMagneticField,
  r::PT,
  ϕ;
  kwargs...,
) where {T <: Number, PT <: AbstractVector{T}}
  return value_(field, r, ϕ; kwargs...)
end
function value(
  ::TimeConstant,
  ::RotationalMovement,
  field::AbstractMagneticField,
  r::PT,
  ϕ;
  kwargs...,
) where {T <: Any, PT <: AbstractVector{T}}
  return [
    value(
      FieldTimeDependencyStyle(field),
      FieldMovementStyle(field),
      field,
      [r_...],
      ϕ;
      kwargs...,
    ) for r_ ∈ Iterators.product(r...)
  ]
end

function value(
  ::TimeConstant,
  ::TranslationalMovement,
  field::AbstractMagneticField,
  r::PT,
  δ;
  kwargs...,
) where {T <: Number, PT <: AbstractVector{T}}
  return value_(field, r, δ; kwargs...)
end
function value(
  ::TimeConstant,
  ::TranslationalMovement,
  field::AbstractMagneticField,
  r::PT,
  δ;
  kwargs...,
) where {T <: Any, PT <: AbstractVector{T}}
  return [
    value(
      FieldTimeDependencyStyle(field),
      FieldMovementStyle(field),
      field,
      [r_...],
      δ;
      kwargs...,
    ) for r_ ∈ Iterators.product(r...)
  ]
end

function value(
  ::TimeConstant,
  ::RotationalTranslationalMovement,
  field::AbstractMagneticField,
  r::PT,
  ϕ,
  δ;
  kwargs...,
) where {T <: Number, PT <: AbstractVector{T}}
  return value_(field, r, ϕ, δ; kwargs...)
end
function value(
  ::TimeConstant,
  ::RotationalTranslationalMovement,
  field::AbstractMagneticField,
  r::PT,
  ϕ,
  δ;
  kwargs...,
) where {T <: Any, PT <: AbstractVector{T}}
  return [
    value(
      FieldTimeDependencyStyle(field),
      FieldMovementStyle(field),
      field,
      [r_...],
      ϕ,
      δ;
      kwargs...,
    ) for r_ ∈ Iterators.product(r...)
  ]
end

function value(::TimeVarying, field::AbstractMagneticField, args...; kwargs...)
  return value(
    FieldTimeDependencyStyle(field),
    FieldMovementStyle(field),
    field,
    args...;
    kwargs...,
  )
end

function value(
  ::TimeVarying,
  ::NoMovement,
  field::AbstractMagneticField,
  t::VT,
  r::PT;
  kwargs...,
) where {VT <: Number, T <: Number, PT <: AbstractVector{T}}
  return value_(field, t, r)
end
function value(
  ::TimeVarying,
  ::NoMovement,
  field::AbstractMagneticField,
  t::VT,
  r::PT;
  kwargs...,
) where {VT <: Number, T <: Any, PT <: AbstractVector{T}}
  return [
    value(
      FieldTimeDependencyStyle(field),
      FieldMovementStyle(field),
      field,
      t,
      [r_...];
      kwargs...,
    ) for r_ ∈ Iterators.product(r...)
  ]
end

function value(
  ::TimeVarying,
  ::RotationalMovement,
  field::AbstractMagneticField,
  t::VT,
  r::PT,
  ϕ;
  kwargs...,
) where {VT <: Number, T <: Number, PT <: AbstractVector{T}}
  return value_(field, t, r, ϕ; kwargs...)
end
function value(
  ::TimeVarying,
  ::RotationalMovement,
  field::AbstractMagneticField,
  t::VT,
  r::PT,
  ϕ;
  kwargs...,
) where {VT <: Number, T <: Any, PT <: AbstractVector{T}}
  return [
    value(
      FieldTimeDependencyStyle(field),
      FieldMovementStyle(field),
      field,
      t,
      [r_...],
      ϕ;
      kwargs...,
    ) for r_ ∈ Iterators.product(r...)
  ]
end

function value(
  ::TimeVarying,
  ::TranslationalMovement,
  field::AbstractMagneticField,
  t::VT,
  r::PT,
  δ;
  kwargs...,
) where {VT <: Number, T <: Number, PT <: AbstractVector{T}}
  return value_(field, t, r, δ; kwargs...)
end
function value(
  ::TimeVarying,
  ::TranslationalMovement,
  field::AbstractMagneticField,
  t::VT,
  r::PT,
  δ;
  kwargs...,
) where {VT <: Number, T <: Any, PT <: AbstractVector{T}}
  return [
    value(
      FieldTimeDependencyStyle(field),
      FieldMovementStyle(field),
      field,
      t,
      [r_...],
      δ;
      kwargs...,
    ) for r_ ∈ Iterators.product(r...)
  ]
end

function value(
  ::TimeVarying,
  ::RotationalTranslationalMovement,
  field::AbstractMagneticField,
  t::VT,
  r::PT,
  ϕ,
  δ;
  kwargs...,
) where {VT <: Number, T <: Number, PT <: AbstractVector{T}}
  return value_(field, t, r, ϕ, δ; kwargs...)
end
function value(
  ::TimeVarying,
  ::RotationalTranslationalMovement,
  field::AbstractMagneticField,
  t::VT,
  r::PT,
  ϕ,
  δ;
  kwargs...,
) where {VT <: Number, T <: Any, PT <: AbstractVector{T}}
  return [
    value(
      FieldTimeDependencyStyle(field),
      FieldMovementStyle(field),
      field,
      t,
      [r_...],
      ϕ,
      δ;
      kwargs...,
    ) for r_ ∈ Iterators.product(r...)
  ]
end

export AbstractFieldNode
"""
    $(TYPEDEF)

Abstract supertype for evaluated nodes of magnetic fields.
"""
abstract type AbstractFieldNode end

export FieldNode
"""
    $(TYPEDEF)

Evaluated node of magnetic field.
"""
struct FieldNode{T, V} <: AbstractFieldNode
  value::T
  position::V
end

export nodes
nodes(field::AbstractMagneticField, args...; kwargs...) = nodes(FieldTimeDependencyStyle(field), field, args...; kwargs...)
# TODO: Use generator for functions
function nodes(::TimeConstant, field::AbstractMagneticField, args...; kwargs...)
  return [FieldNode(value(field, [r_...], args[2:end]...; kwargs...), r_) for r_ ∈ Iterators.product(args[1]...)]
end
function nodes(::TimeVarying, field::AbstractMagneticField, args...; kwargs...)
  return [FieldNode(value(field, args[1], [r_...], args[3:end]...; kwargs...), r_) for r_ ∈ Iterators.product(args[2]...)]
end


include("Common.jl")
include("Superposition.jl")
include("CommonFields/CommonFields.jl")

end
