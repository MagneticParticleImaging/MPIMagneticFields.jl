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



# value(::TimeConstant, ::RotationalMovement, field::AbstractMagneticField, r::PT, ϕ::RT; kwargs...) where {T <: Number, PT <: AbstractVector{T}, T2 <: Number, RT <: AbstractVector{T2}} = value_(field, r, ϕ; kwargs...)
# value(::TimeConstant, ::RotationalMovement, field::AbstractMagneticField, r::PT, ϕ::RT; kwargs...) where {T <: Union{<:AbstractRange, Number}, PT <: AbstractVector{T}, T2 <: Number, RT <: AbstractVector{T2}} = [value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, [r_...], ϕ; kwargs...) for r_ in Iterators.product(r...)]
# value(::TimeConstant, ::RotationalMovement, field::AbstractMagneticField, r::PT, ϕ::RT; kwargs...) where {T <: Any, PT <: AbstractVector{T}, T2 <: Number, RT <: AbstractVector{T2}} = value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ; kwargs...)

# value(::TimeConstant, ::TranslationalMovement, field::AbstractMagneticField, r::PT, δ::TT; kwargs...) where {T <: Number, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = value_(field, r, δ; kwargs...)
# value(::TimeConstant, ::TranslationalMovement, field::AbstractMagneticField, r::PT, δ::TT; kwargs...) where {T <: Union{<:AbstractRange, Number}, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = [value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, [r_...], δ; kwargs...) for r_ in Iterators.product(r...)]
# value(::TimeConstant, ::TranslationalMovement, field::AbstractMagneticField, r::PT, δ::TT; kwargs...) where {T <: Any, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, convert(Vector{Union{<:AbstractRange, Number}}, r), δ; kwargs...)

# value(::TimeConstant, ::RotationalTranslationalMovement, field::AbstractMagneticField, r::PT, ϕ::RT, δ::TT; kwargs...) where {T <: Number, PT <: AbstractVector{T}, T2 <: Number, RT <: AbstractVector{T2}, T3 <: Number, TT <: AbstractVector{T3}} = value_(field, r, ϕ, δ; kwargs...)
# value(::TimeConstant, ::RotationalTranslationalMovement, field::AbstractMagneticField, r::PT, ϕ::RT, δ::TT; kwargs...) where {T <: Union{<:AbstractRange, Number}, PT <: AbstractVector{T}, T2 <: Number, RT <: AbstractVector{T2}, T3 <: Number, TT <: AbstractVector{T3}} = [value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, [r_...], ϕ, δ; kwargs...) for r_ in Iterators.product(r...)]
# value(::TimeConstant, ::RotationalTranslationalMovement, field::AbstractMagneticField, r::PT, ϕ::RT, δ::TT; kwargs...) where {T <: Any, PT <: AbstractVector{T}, T2 <: Number, RT <: AbstractVector{T2}, T3 <: Number, TT <: AbstractVector{T3}} = value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ, δ; kwargs...)

# value(::TimeVarying, field::AbstractMagneticField, args...; kwargs...) = value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, args...; kwargs...)

# value(::TimeVarying, ::NoMovement, field::AbstractMagneticField, t::VT, r::PT; kwargs...) where {VT <: Number, T <: Number, PT <: AbstractVector{T}} = value_(field, t, r)
# value(::TimeVarying, ::NoMovement, field::AbstractMagneticField, t::VT, r::PT; kwargs...) where {VT <: Number, T <: Union{<:AbstractRange, Number}, PT <: AbstractVector{T}} = [value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, t, [r_...]; kwargs...) for r_ in Iterators.product(r...)]
# value(::TimeVarying, ::NoMovement, field::AbstractMagneticField, t::VT, r::PT; kwargs...) where {VT <: Number, T <: Any, PT <: AbstractVector{T}} = value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, t, convert(Vector{Union{<:AbstractRange, Number}}, r); kwargs...)

# value(::TimeVarying, ::RotationalMovement, field::AbstractMagneticField, t::VT, r::PT, ϕ::RT; kwargs...) where {VT <: Number, T <: Number, PT <: AbstractVector{T}, T2 <: Number, RT <: AbstractVector{T2}} = value_(field, t, r, ϕ; kwargs...)
# value(::TimeVarying, ::RotationalMovement, field::AbstractMagneticField, t::VT, r::PT, ϕ::RT; kwargs...) where {VT <: Number, T <: Union{<:AbstractRange, Number}, PT <: AbstractVector{T}, T2 <: Number, RT <: AbstractVector{T2}} = [value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, t, [r_...], ϕ; kwargs...) for r_ in Iterators.product(r...)]
# value(::TimeVarying, ::RotationalMovement, field::AbstractMagneticField, t::VT, r::PT, ϕ::RT; kwargs...) where {VT <: Number, T <: Any, PT <: AbstractVector{T}, T2 <: Number, RT <: AbstractVector{T2}} = value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, t, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ; kwargs...)

# value(::TimeVarying, ::TranslationalMovement, field::AbstractMagneticField, t::VT, r::PT, δ::TT; kwargs...) where {VT <: Number, T <: Number, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = value_(field, t, r, δ; kwargs...)
# value(::TimeVarying, ::TranslationalMovement, field::AbstractMagneticField, t::VT, r::PT, δ::TT; kwargs...) where {VT <: Number, T <: Union{<:AbstractRange, Number}, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = [value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, t, [r_...], δ; kwargs...) for r_ in Iterators.product(r...)]
# value(::TimeVarying, ::TranslationalMovement, field::AbstractMagneticField, t::VT, r::PT, δ::TT; kwargs...) where {VT <: Number, T <: Any, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, t, convert(Vector{Union{<:AbstractRange, Number}}, r), δ; kwargs...)

# value(::TimeVarying, ::RotationalTranslationalMovement, field::AbstractMagneticField, t::VT, r::PT, ϕ::RT, δ::TT; kwargs...) where {VT <: Number, T <: Number, PT <: AbstractVector{T}, T2 <: Number, RT <: AbstractVector{T2}, T3 <: Number, TT <: AbstractVector{T3}} = value_(field, t, r, ϕ, δ; kwargs...)
# value(::TimeVarying, ::RotationalTranslationalMovement, field::AbstractMagneticField, t::VT, r::PT, ϕ::RT, δ::TT; kwargs...) where {VT <: Number, T <: Union{<:AbstractRange, Number}, PT <: AbstractVector{T}, T2 <: Number, RT <: AbstractVector{T2}, T3 <: Number, TT <: AbstractVector{T3}} = [value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, t, [r_...], ϕ, δ; kwargs...) for r_ in Iterators.product(r...)]
# value(::TimeVarying, ::RotationalTranslationalMovement, field::AbstractMagneticField, t::VT, r::PT, ϕ::RT, δ::TT; kwargs...) where {VT <: Number, T <: Any, PT <: AbstractVector{T}, T2 <: Number, RT <: AbstractVector{T2}, T3 <: Number, TT <: AbstractVector{T3}} = value(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, t, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ, δ; kwargs...)


# function value(field::AbstractMagneticField, args::Vararg{VT, N}) where {T <: Number, VT <: AbstractVector{T}, N <: Integer}
#   if isTimeVarying(field)
#     t = args[1]
#     r = args[2]
#     if isRotatable(field)
#       ϕ = args[3]
#       if isTranslatable(field)
#         δ = args[4]
#         if N == 4
#           return value(t, r, ϕ, δ)
#         else
#           throw(ArgumentError("The field of type `$(typeof(field))` is time-varying, rotatable and translatable but the number of arguments is not 4."))
#         end
#       else
#         if N == 3
#           return value(t, r, ϕ)
#         else
#           throw(ArgumentError("The field of type `$(typeof(field))` is time-varying, rotatable and not translatable but the number of arguments is not 3."))
#         end
#       end
#     else
#       if isTranslatable(field)
#         δ = args[3]
#         if N == 3
#           return value(t, r, zeros(Float64, NVT), δ)
#         else
#           throw(ArgumentError("The field of type `$(typeof(field))` is time-varying, not rotatable and translatable but the number of arguments is not 3."))
#         end
#       else
#         if N == 2
#           return value(t, r, zeros(Float64, NVT), zeros(Float64, NVT))
#         else
#           throw(ArgumentError("The field of type `$(typeof(field))` is time-varying, not rotatable and not translatable but the number of arguments is not 2."))
#         end
#       end
#     end
#   else
#     r = args[1]
#     if isRotatable(field)
#       ϕ = args[2]
#       if isTranslatable(field)
#         δ = args[3]
#         if N == 3
#           return value(t, r, ϕ, δ)
#         else
#           throw(ArgumentError("The field of type `$(typeof(field))` is not time-varying, rotatable and translatable but the number of arguments is not 3."))
#         end
#       else
#         if N == 2
#           return value(t, r, ϕ, zeros(Float64, NVT))
#         else
#           throw(ArgumentError("The field of type `$(typeof(field))` is not time-varying, rotatable and not translatable but the number of arguments is not 2."))
#         end
#       end
#     else
#       if isTranslatable(field)
#         δ = args[3]
#         if N == 3
#           return value(t, r, zeros(Float64, NVT), δ)
#         else
#           throw(ArgumentError("The field of type `$(typeof(field))` is not time-varying, not rotatable and translatable but the number of arguments is not 2."))
#         end
#       else
#         if N == 2
#           return value(t, r, zeros(Float64, NVT), zeros(Float64, NVT))
#         else
#           throw(ArgumentError("The field of type `$(typeof(field))` is not time-varying, not rotatable and not translatable but the number of arguments is not 1."))
#         end
#       end
#     end
#   end
# end

# value(field::AbstractMagneticField, t::T, r::PT, ϕ::RT, δ::TT) where {T <: Number, T1 <: Number, PT <: AbstractVector{T1}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} 

# value(::AbstractMagneticField, r::PT) where {T <: Number, PT <: AbstractVector{T}} = error("Not yet implemented")
# value(field::AbstractMagneticField, r::PT, ϕ::RT) where {T <: Number, PT <: AbstractVector{T}, RT <: Number} = isRotatable(field) ? error("Not yet implemented") : value(field, r)
# value(field::AbstractMagneticField, r::PT, δ::TT) where {T <: Number, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = isTranslatable(field) ? error("Not yet implemented") : value(field, r)
# function value(field::AbstractMagneticField, r::PT, ϕ::RT, δ::TT) where {T <: Number, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} 
#   if isTranslatable(field) && isRotatable(field)
#     error("Not yet implemented")
#   elseif isTranslatable(field)
#     return value(field, r, δ)
#   elseif isRotatable(field)
#     return value(field, r, ϕ)
#   else
#     value(field, r)
#   end
# end

# # With time dimension
# value(field::AbstractMagneticField, t::VT, r::PT) where {VT <: Number, T <: Number, PT <: AbstractVector{T}} = isTimeVarying(field) ? error("Not yet implemented") : value(field, r)
# value(field::AbstractMagneticField, t::VT, r::PT, ϕ::RT) where {VT <: Number, T <: Number, PT <: AbstractVector{T}, RT <: Number} = isTimeVarying(field) && isRotatable(field) ? error("Not yet implemented") : value(field, t, r)
# value(field::AbstractMagneticField, t::VT, r::PT, δ::TT) where {VT <: Number, T <: Number, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = isTimeVarying(field) && isTranslatable(field) ? error("Not yet implemented") : value(field, t, r)
# function 
#   if isTimeVarying(field) && isTranslatable(field) && isRotatable(field)
#     error("Not yet implemented")
#   elseif isTimeVarying(field) && isTranslatable(field)
#     return value(field, t, r, δ)
#   elseif isTimeVarying(field) && isRotatable(field)
#     return value(field, t, r, ϕ)
#   else
#     value(field, t, r)
#   end
# end

# value(field::AbstractMagneticField, r::PT) where {T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}} = [value(field, [r_...]) for r_ in Iterators.product(r...)]
# value(field::AbstractMagneticField, r::PT, ϕ::RT) where {T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, RT <: Number} = [value(field, [r_...], ϕ) for r_ in Iterators.product(r...)]
# value(field::AbstractMagneticField, r::PT, δ::TT) where {T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = [value(field, [r_...], δ) for r_ in Iterators.product(r...)]
# value(field::AbstractMagneticField, r::PT, ϕ::RT, δ::TT) where {T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} = [value(field, [r_...], ϕ, δ) for r_ in Iterators.product(r...)]

# # With time dimension
# value(field::AbstractMagneticField, t::VT, r::PT) where {VT <: Number, T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}} = [value(field, t, [r_...]) for r_ in Iterators.product(r...)]
# value(field::AbstractMagneticField, t::VT, r::PT, ϕ::RT) where {VT <: Number, T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, RT <: Number} = [value(field, t, [r_...], ϕ) for r_ in Iterators.product(r...)]
# value(field::AbstractMagneticField, t::VT, r::PT, δ::TT) where {VT <: Number, T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = [value(field, t, [r_...], δ) for r_ in Iterators.product(r...)]
# value(field::AbstractMagneticField, t::VT, r::PT, ϕ::RT, δ::TT) where {VT <: Number, T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} = [value(field, t, [r_...], ϕ, δ) for r_ in Iterators.product(r...)]

# # value(field::AbstractMagneticField, t::VT, r::PT) where {VT <: AbstractRange, T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}} = [value(field, tr[1], [tr[2:end]...]) for tr in Iterators.product(t, r...)]
# # value(field::AbstractMagneticField, t::VT, r::PT, ϕ::RT) where {VT <: AbstractRange, T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, RT <: Number} = [value(field, tr[1], [tr[2:end]...], ϕ) for tr in Iterators.product(t, r...)]
# # value(field::AbstractMagneticField, t::VT, r::PT, δ::TT) where {VT <: AbstractRange, T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = [value(field, tr[1], [tr[2:end]...], δ) for tr in Iterators.product(t, r...)]
# # value(field::AbstractMagneticField, t::VT, r::PT, ϕ::RT, δ::TT) where {VT <: AbstractRange, T <: Union{AbstractRange, Number}, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} = [value(field, t[1], [tr[2:end]...], ϕ, δ) for tr in Iterators.product(t, r...)]

# # Mixed vectors of ranges and scalars are Vector{Any} which does not have a dispatch yet; anything else will fail
# value(field::AbstractMagneticField, r::PT) where {T <: Any, PT <: AbstractVector{T}} = value(field, convert(Vector{Union{<:AbstractRange, Number}}, r))
# value(field::AbstractMagneticField, r::PT, ϕ::RT) where {T <: Any, PT <: AbstractVector{T}, RT <: Number} = value(field, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ)
# value(field::AbstractMagneticField, r::PT, δ::TT) where {T <: Any, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = value(field, convert(Vector{Union{<:AbstractRange, Number}}, r), δ)
# value(field::AbstractMagneticField, r::PT, ϕ::RT, δ::TT) where {T <: Any, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} = value(field, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ, δ)

# value(field::AbstractMagneticField, t::VT, r::PT) where {VT <: Number, T <: Any, PT <: AbstractVector{T}} = value(field, t, convert(Vector{Union{<:AbstractRange, Number}}, r))
# value(field::AbstractMagneticField, t::VT, r::PT, ϕ::RT) where {VT <: Number, T <: Any, PT <: AbstractVector{T}, RT <: Number} = value(field, t, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ)
# value(field::AbstractMagneticField, t::VT, r::PT, δ::TT) where {VT <: Number, T <: Any, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = value(field, t, convert(Vector{Union{<:AbstractRange, Number}}, r), δ)
# value(field::AbstractMagneticField, t::VT, r::PT, ϕ::RT, δ::TT) where {VT <: Number, T <: Any, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} = value(field, t, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ, δ)

# # value(field::AbstractMagneticField, t::VT, r::PT) where {VT <: AbstractRange, T <: Any, PT <: AbstractVector{T}} = value(field, t, convert(Vector{Union{<:AbstractRange, Number}}, r))
# # value(field::AbstractMagneticField, t::VT, r::PT, ϕ::RT) where {VT <: AbstractRange, T <: Any, PT <: AbstractVector{T}, RT <: Number} = value(field, t, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ)
# # value(field::AbstractMagneticField, t::VT, r::PT, δ::TT) where {VT <: AbstractRange, T <: Any, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = value(field, t, convert(Vector{Union{<:AbstractRange, Number}}, r), δ)
# # value(field::AbstractMagneticField, t::VT, r::PT, ϕ::RT, δ::TT) where {VT <: AbstractRange, T <: Any, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} = value(field, t, convert(Vector{Union{<:AbstractRange, Number}}, r), ϕ, δ)

include("Common.jl")
include("Superposition.jl")
include("Grid.jl")
include("CommonFields/CommonFields.jl")

end