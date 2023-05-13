export IdealHomogeneousField
mutable struct IdealHomogeneousField{T, U} <: AbstractMagneticField where {T <: Number, U <: Number}
  amplitude::T
  direction::Vector{U}
end

FieldStyle(::IdealHomogeneousField) = HomogeneousField()
FieldDefinitionStyle(::IdealHomogeneousField) = MethodBasedFieldDefinition()
FieldTimeDependencyStyle(::IdealHomogeneousField) = TimeConstant()

value_(field::IdealHomogeneousField, r) = normalize(field.direction).*field.amplitude

# TODO: Define other combinations
export IdealXYRotatedHomogeneousField
mutable struct IdealXYRotatedHomogeneousField{T} <: AbstractMagneticField where {T <: Number}
  amplitude::T
end

FieldStyle(::IdealXYRotatedHomogeneousField) = HomogeneousField()
FieldDefinitionStyle(::IdealXYRotatedHomogeneousField) = MethodBasedFieldDefinition()
FieldTimeDependencyStyle(::IdealXYRotatedHomogeneousField) = TimeConstant()
FieldMovementStyle(::IdealXYRotatedHomogeneousField) = RotationalMovement()

value_(field::IdealXYRotatedHomogeneousField, r, ϕ) = [sin(ϕ), cos(ϕ), 0].*field.amplitude
