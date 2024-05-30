module MPIMagneticFields

using DocStringExtensions
using LinearAlgebra
using StaticArrays
using Unitful
using Waveforms
using Random

export μ₀
"""
Vacuum magnetic permeability for usage within the field definitions
"""
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
  return value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, args...; kwargs...)
end

for fieldTimeDependencyStyle ∈ timeDependencyStylesCodeGeneration_
  for fieldMovementStyle ∈ movementStylesCodeGeneration_
    arguments = []
    parameters = []

    if fieldTimeDependencyStyle == :TimeVarying
      push!(parameters, :(t::VT))
    end

    push!(parameters, :(r::PT))

    if fieldMovementStyle in rotationalStyles_
      if fieldMovementStyle in translationalStyles_
        push!(arguments, :ϕ)
        push!(parameters, :ϕ)
        push!(arguments, :δ)
        push!(parameters, :δ)
      else
        push!(arguments, :ϕ)
        push!(parameters, :ϕ)
      end
    else
      if fieldMovementStyle in translationalStyles_
        push!(arguments, :δ)
        push!(parameters, :δ)
      else
        # NOP
      end
    end

    if fieldTimeDependencyStyle == :TimeVarying
      @eval begin
        function value(
          ::$fieldTimeDependencyStyle,
          ::$fieldMovementStyle,
          field::AbstractMagneticField,
          $(parameters...);
          kwargs...,
        ) where {VT <: Number, T <: Number, PT <: AbstractVector{T}}
          return value_(field, t, r, $(arguments...); kwargs...)
        end

        function value(
          ::$fieldTimeDependencyStyle,
          ::$fieldMovementStyle,
          field::AbstractMagneticField,
          $(parameters...);
          kwargs...,
        ) where {VT <: Number, T <: Any, PT <: AbstractVector{T}}
          return [
            value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, t, [r_...], $(arguments...); kwargs...) for
            r_ ∈ Iterators.product(r...)
          ]
        end

        function value(
          ::$fieldTimeDependencyStyle,
          ::$fieldMovementStyle,
          field::AbstractMagneticField,
          $(parameters...);
          kwargs...,
        ) where {TT <: Number, VT <: AbstractVector{TT}, T <: Any, PT <: AbstractVector{T}}
          return [value(field, t_, r, $(arguments...); kwargs...) for t_ ∈ t]
        end
      end
    else
      @eval begin
        function value(
          ::$fieldTimeDependencyStyle,
          ::$fieldMovementStyle,
          field::AbstractMagneticField,
          $(parameters...);
          kwargs...,
        ) where {T <: Number, PT <: AbstractVector{T}}
          return value_(field, r, $(arguments...); kwargs...)
        end

        function value(
          ::$fieldTimeDependencyStyle,
          ::$fieldMovementStyle,
          field::AbstractMagneticField,
          $(parameters...);
          kwargs...,
        ) where {T <: Any, PT <: AbstractVector{T}}
          return [
            value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, [r_...], $(arguments...); kwargs...) for
            r_ ∈ Iterators.product(r...)
          ]
        end
      end
    end
  end
end

include("Common.jl")
include("Superposition.jl")
include("Sequence/Sequence.jl")
include("CommonFields/CommonFields.jl")
include("Experimental.jl")

end
