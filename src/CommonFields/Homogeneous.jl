export IdealHomogeneousField
mutable struct IdealHomogeneousField{U} <: AbstractMagneticField where {T <: Number, U <: AbstractVector{T}}
  value::U

  function IdealHomogeneousField(value::U) where {T <: Number, U <: AbstractVector{T}}
    return new{U}(value)
  end
end

FieldStyle(::IdealHomogeneousField) = HomogeneousField()
FieldDefinitionStyle(::IdealHomogeneousField) = MethodBasedFieldDefinition()
FieldTimeDependencyStyle(::IdealHomogeneousField) = TimeConstant()

value_(field::IdealHomogeneousField, r) = field.value

# TODO: Define other combinations
export IdealXYRotatedHomogeneousField
mutable struct IdealXYRotatedHomogeneousField{T} <: AbstractMagneticField where {T <: Number}
  amplitude::T
end

FieldStyle(::IdealXYRotatedHomogeneousField) = HomogeneousField()
FieldDefinitionStyle(::IdealXYRotatedHomogeneousField) = MethodBasedFieldDefinition()
FieldTimeDependencyStyle(::IdealXYRotatedHomogeneousField) = TimeConstant()
FieldMovementStyle(::IdealXYRotatedHomogeneousField) = RotationalMovement()

value_(field::IdealXYRotatedHomogeneousField, r, ϕ) = [sin(ϕ), cos(ϕ), 0] .* field.amplitude

export IdealXYRotatedShiftedHomogeneousField
mutable struct IdealXYRotatedShiftedHomogeneousField <: AbstractMagneticField end

FieldStyle(::IdealXYRotatedShiftedHomogeneousField) = HomogeneousField()
FieldDefinitionStyle(::IdealXYRotatedShiftedHomogeneousField) = MethodBasedFieldDefinition()
FieldTimeDependencyStyle(::IdealXYRotatedShiftedHomogeneousField) = TimeConstant()
FieldMovementStyle(::IdealXYRotatedShiftedHomogeneousField) = RotationalTranslationalMovement()
RotationalDimensionalityStyle() = RotationalDimensionalityStyle{OneDimensional}()
TranslationalDimensionalityStyle() = TranslationalDimensionalityStyle{OneDimensional}()

value_(field::IdealXYRotatedShiftedHomogeneousField, r, ϕ, δ) = [sin(ϕ), cos(ϕ), 0] .* δ
