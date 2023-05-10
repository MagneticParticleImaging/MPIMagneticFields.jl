export IdealHomogeneousField
mutable struct IdealHomogeneousField{T, U} <: AbstractMagneticField where {T <: Number, U <: Number}
  amplitude::T
  direction::Vector{U}
end

fieldType(::IdealHomogeneousField) = HomogeneousField()
definitionType(::IdealHomogeneousField) = MethodBasedFieldDefinition()
timeDependencyType(::IdealHomogeneousField) = TimeConstant()

value(field::IdealHomogeneousField, ::PT) where {T <: Number, PT <: AbstractVector{T}} = normalize(field.direction).*field.amplitude

# TODO: Define other combinations
export IdealXYRotatedHomogeneousField
mutable struct IdealXYRotatedHomogeneousField{T} <: AbstractMagneticField where {T <: Number}
  amplitude::T
end

fieldType(::IdealXYRotatedHomogeneousField) = HomogeneousField()
definitionType(::IdealXYRotatedHomogeneousField) = MethodBasedFieldDefinition()
timeDependencyType(::IdealXYRotatedHomogeneousField) = TimeConstant()
fieldMovementType(::IdealXYRotatedHomogeneousField) = RotationalMovement()

value(field::IdealXYRotatedHomogeneousField, r::PT) where {T <: Number, PT <: AbstractVector{T}} = value(field, r, 0.0) # Defaults to angle 0
value(field::IdealXYRotatedHomogeneousField, r::PT, ϕ::RT) where {T <: Number, PT <: AbstractVector{T}, RT <: Number} = [sin(ϕ), cos(ϕ), 0].*field.amplitude
