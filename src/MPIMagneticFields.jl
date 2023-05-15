module MPIMagneticFields

using DocStringExtensions
using LinearAlgebra

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
value_(field::AbstractMagneticField, args...; kargs...) = error("Field type `$(typeof(field))` must implement internal function `value_`. Note: The underscore is important!")

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
value(field::AbstractMagneticField, args...; kwargs...) = value(FieldTimeDependencyStyle(field), field, args...; kwargs...)

value(::TimeConstant, field::AbstractMagneticField, args...; kwargs...) = value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, args...; kwargs...)

value(::TimeConstant, ::NoMovement, field::AbstractMagneticField, r::PT; kwargs...) where {T <: Number, PT <: AbstractVector{T}} = value_(field, r)
value(::TimeConstant, ::NoMovement, field::AbstractMagneticField, r::PT; kwargs...) where {T <: Union{<:AbstractRange, Number}, PT <: AbstractVector{T}} = [value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, [r_...]; kwargs...) for r_ in Iterators.product(r...)]
value(::TimeConstant, ::NoMovement, field::AbstractMagneticField, r::PT; kwargs...) where {T <: Any, PT <: AbstractVector{T}} = value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, convert(Vector{Union{<:AbstractRange, Number}}, r); kwargs...)

value(::TimeConstant, ::RotationalMovement, field::AbstractMagneticField, r::PT, ϕ; kwargs...) where {T <: Number, PT <: AbstractVector{T}} = value_(field, r, ϕ; kwargs...)
value(::TimeConstant, ::RotationalMovement, field::AbstractMagneticField, r::PT, ϕ; kwargs...) where {T <: Union{<:AbstractRange, Number}, PT <: AbstractVector{T}} = [value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, [r_...], ϕ; kwargs...) for r_ in Iterators.product(r...)]
value(::TimeConstant, ::RotationalMovement, field::AbstractMagneticField, r::PT, ϕ; kwargs...) where {T <: Any, PT <: AbstractVector{T}} = value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ; kwargs...)

value(::TimeConstant, ::TranslationalMovement, field::AbstractMagneticField, r::PT, δ; kwargs...) where {T <: Number, PT <: AbstractVector{T}} = value_(field, r, δ; kwargs...)
value(::TimeConstant, ::TranslationalMovement, field::AbstractMagneticField, r::PT, δ; kwargs...) where {T <: Union{<:AbstractRange, Number}, PT <: AbstractVector{T}} = [value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, [r_...], δ; kwargs...) for r_ in Iterators.product(r...)]
value(::TimeConstant, ::TranslationalMovement, field::AbstractMagneticField, r::PT, δ; kwargs...) where {T <: Any, PT <: AbstractVector{T}} = value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, convert(Vector{Union{<:AbstractRange, Number}}, r), δ; kwargs...)

value(::TimeConstant, ::RotationalTranslationalMovement, field::AbstractMagneticField, r::PT, ϕ, δ; kwargs...) where {T <: Number, PT <: AbstractVector{T}} = value_(field, r, ϕ, δ; kwargs...)
value(::TimeConstant, ::RotationalTranslationalMovement, field::AbstractMagneticField, r::PT, ϕ, δ; kwargs...) where {T <: Union{<:AbstractRange, Number}, PT <: AbstractVector{T}} = [value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, [r_...], ϕ, δ; kwargs...) for r_ in Iterators.product(r...)]
value(::TimeConstant, ::RotationalTranslationalMovement, field::AbstractMagneticField, r::PT, ϕ, δ; kwargs...) where {T <: Any, PT <: AbstractVector{T}} = value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ, δ; kwargs...)

value(::TimeVarying, field::AbstractMagneticField, args...; kwargs...) = value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, args...; kwargs...)

value(::TimeVarying, ::NoMovement, field::AbstractMagneticField, t::VT, r::PT; kwargs...) where {VT <: Number, T <: Number, PT <: AbstractVector{T}} = value_(field, t, r)
value(::TimeVarying, ::NoMovement, field::AbstractMagneticField, t::VT, r::PT; kwargs...) where {VT <: Number, T <: Union{<:AbstractRange, Number}, PT <: AbstractVector{T}} = [value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, t, [r_...]; kwargs...) for r_ in Iterators.product(r...)]
value(::TimeVarying, ::NoMovement, field::AbstractMagneticField, t::VT, r::PT; kwargs...) where {VT <: Number, T <: Any, PT <: AbstractVector{T}} = value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, t, convert(Vector{Union{<:AbstractRange, Number}}, r); kwargs...)

value(::TimeVarying, ::RotationalMovement, field::AbstractMagneticField, t::VT, r::PT, ϕ; kwargs...) where {VT <: Number, T <: Number, PT <: AbstractVector{T}} = value_(field, t, r, ϕ; kwargs...)
value(::TimeVarying, ::RotationalMovement, field::AbstractMagneticField, t::VT, r::PT, ϕ; kwargs...) where {VT <: Number, T <: Union{<:AbstractRange, Number}, PT <: AbstractVector{T}} = [value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, t, [r_...], ϕ; kwargs...) for r_ in Iterators.product(r...)]
value(::TimeVarying, ::RotationalMovement, field::AbstractMagneticField, t::VT, r::PT, ϕ; kwargs...) where {VT <: Number, T <: Any, PT <: AbstractVector{T}} = value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, t, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ; kwargs...)

value(::TimeVarying, ::TranslationalMovement, field::AbstractMagneticField, t::VT, r::PT, δ; kwargs...) where {VT <: Number, T <: Number, PT <: AbstractVector{T}} = value_(field, t, r, δ; kwargs...)
value(::TimeVarying, ::TranslationalMovement, field::AbstractMagneticField, t::VT, r::PT, δ; kwargs...) where {VT <: Number, T <: Union{<:AbstractRange, Number}, PT <: AbstractVector{T}} = [value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, t, [r_...], δ; kwargs...) for r_ in Iterators.product(r...)]
value(::TimeVarying, ::TranslationalMovement, field::AbstractMagneticField, t::VT, r::PT, δ; kwargs...) where {VT <: Number, T <: Any, PT <: AbstractVector{T}} = value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, t, convert(Vector{Union{<:AbstractRange, Number}}, r), δ; kwargs...)

value(::TimeVarying, ::RotationalTranslationalMovement, field::AbstractMagneticField, t::VT, r::PT, ϕ, δ; kwargs...) where {VT <: Number, T <: Number, PT <: AbstractVector{T}} = value_(field, t, r, ϕ, δ; kwargs...)
value(::TimeVarying, ::RotationalTranslationalMovement, field::AbstractMagneticField, t::VT, r::PT, ϕ, δ; kwargs...) where {VT <: Number, T <: Union{<:AbstractRange, Number}, PT <: AbstractVector{T}} = [value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, t, [r_...], ϕ, δ; kwargs...) for r_ in Iterators.product(r...)]
value(::TimeVarying, ::RotationalTranslationalMovement, field::AbstractMagneticField, t::VT, r::PT, ϕ, δ; kwargs...) where {VT <: Number, T <: Any, PT <: AbstractVector{T}} = value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, t, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ, δ; kwargs...)

include("Common.jl")
include("Superposition.jl")
include("CommonFields/CommonFields.jl")

end