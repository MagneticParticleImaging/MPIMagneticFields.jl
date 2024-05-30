export IdealHomogeneousField
mutable struct IdealHomogeneousField{U} <: AbstractMagneticField where {T <: Number, U <: AbstractVector{T}}
  value::U

  IdealHomogeneousField(value::U) where {T <: Number, U <: AbstractVector{T}} = new{U}(value)
end

FieldStyle(::IdealHomogeneousField) = HomogeneousField()
FieldDefinitionStyle(::IdealHomogeneousField) = MethodBasedFieldDefinition()
FieldTimeDependencyStyle(::IdealHomogeneousField) = TimeConstant()

value_(field::IdealHomogeneousField, r) = field.value

export FunctionDefinedHomogeneousField
mutable struct FunctionDefinedHomogeneousField{F} <: AbstractMagneticField where {F <: Function}
  function_::F
end

FieldStyle(::FunctionDefinedHomogeneousField) = HomogeneousField()
FieldDefinitionStyle(::FunctionDefinedHomogeneousField) = MethodBasedFieldDefinition()
FieldTimeDependencyStyle(::FunctionDefinedHomogeneousField) = TimeVarying()

value_(field::FunctionDefinedHomogeneousField, t, r) = field.function_(t)

export OneDimensionalVariableTranslationHomogeneousField
mutable struct OneDimensionalVariableTranslationHomogeneousField <: AbstractMagneticField
  direction::Direction
end

FieldStyle(::OneDimensionalVariableTranslationHomogeneousField) = HomogeneousField()
FieldDefinitionStyle(::OneDimensionalVariableTranslationHomogeneousField) = MethodBasedFieldDefinition()
FieldTimeDependencyStyle(::OneDimensionalVariableTranslationHomogeneousField) = TimeVarying()
FieldMovementStyle(::OneDimensionalVariableTranslationHomogeneousField) = TranslationalMovement()

value_(field::OneDimensionalVariableTranslationHomogeneousField, t, r, δ) = value_(field.direction, field, t, r, δ)
value_(direction::XDirection, field::OneDimensionalVariableTranslationHomogeneousField, t, r, δ) = [δ, zero(eltype(δ)), zero(eltype(δ))]
value_(direction::YDirection, field::OneDimensionalVariableTranslationHomogeneousField, t, r, δ) = [zero(eltype(δ)), δ, zero(eltype(δ))]
value_(direction::ZDirection, field::OneDimensionalVariableTranslationHomogeneousField, t, r, δ) = [zero(eltype(δ)), zero(eltype(δ)), δ]

export IdealRotatedHomogeneousField
mutable struct IdealRotatedHomogeneousField{RT, T} <: AbstractMagneticField where {RT <: RotationPlane, T <: Number}
  rotationPlane::RT
  amplitude::T
end

export IdealXYRotatedHomogeneousField
IdealXYRotatedHomogeneousField(amplitude::T) where T <: Number = IdealRotatedHomogeneousField(XYRotationPlane(), amplitude)

export IdealXZRotatedHomogeneousField
IdealXZRotatedHomogeneousField(amplitude::T) where T <: Number = IdealRotatedHomogeneousField(XZRotationPlane(), amplitude)

export IdealYZRotatedHomogeneousField
IdealYZRotatedHomogeneousField(amplitude::T) where T <: Number = IdealRotatedHomogeneousField(YZRotationPlane(), amplitude)

FieldStyle(::IdealRotatedHomogeneousField) = HomogeneousField()
FieldDefinitionStyle(::IdealRotatedHomogeneousField) = MethodBasedFieldDefinition()
FieldTimeDependencyStyle(::IdealRotatedHomogeneousField) = TimeConstant()
FieldMovementStyle(::IdealRotatedHomogeneousField) = RotationalMovement()

value_(field::IdealRotatedHomogeneousField{XYRotationPlane, T}, r, ϕ) where {T <: Number} = [sin(ϕ), cos(ϕ), 0] .* field.amplitude
value_(field::IdealRotatedHomogeneousField{XZRotationPlane, T}, r, ϕ) where {T <: Number} = [sin(ϕ), 0, cos(ϕ)] .* field.amplitude
value_(field::IdealRotatedHomogeneousField{YZRotationPlane, T}, r, ϕ) where {T <: Number} = [0, sin(ϕ), cos(ϕ)] .* field.amplitude

export IdealRotatedTranslatedHomogeneousField
mutable struct IdealRotatedTranslatedHomogeneousField{RT} <: AbstractMagneticField where {RT <: RotationPlane}
  rotationPlane::RT
end

export IdealXYRotatedTranslatedHomogeneousField
IdealXYRotatedTranslatedHomogeneousField() = IdealRotatedTranslatedHomogeneousField(XYRotationPlane())

export IdealXZRotatedTranslatedHomogeneousField
IdealXZRotatedTranslatedHomogeneousField() = IdealRotatedTranslatedHomogeneousField(XZRotationPlane())

export IdealYZRotatedTranslatedHomogeneousField
IdealYZRotatedTranslatedHomogeneousField() = IdealRotatedTranslatedHomogeneousField(YZRotationPlane())

FieldStyle(::IdealRotatedTranslatedHomogeneousField) = HomogeneousField()
FieldDefinitionStyle(::IdealRotatedTranslatedHomogeneousField) = MethodBasedFieldDefinition()
FieldTimeDependencyStyle(::IdealRotatedTranslatedHomogeneousField) = TimeConstant()
FieldMovementStyle(::IdealRotatedTranslatedHomogeneousField) = RotationalTranslationalMovement()
RotationalDimensionalityStyle(::IdealRotatedTranslatedHomogeneousField) = RotationalDimensionalityStyle{OneDimensional}()
TranslationalDimensionalityStyle(::IdealRotatedTranslatedHomogeneousField) = TranslationalDimensionalityStyle{OneDimensional}()

value_(field::IdealRotatedTranslatedHomogeneousField{XYRotationPlane}, r, ϕ, δ) = [sin(ϕ), cos(ϕ), 0] .* δ
value_(field::IdealRotatedTranslatedHomogeneousField{XZRotationPlane}, r, ϕ, δ) = [sin(ϕ), 0, cos(ϕ)] .* δ
value_(field::IdealRotatedTranslatedHomogeneousField{YZRotationPlane}, r, ϕ, δ) = [0, sin(ϕ), cos(ϕ)] .* δ
