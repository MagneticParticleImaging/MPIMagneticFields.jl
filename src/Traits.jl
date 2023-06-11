export FieldStyle, GradientField, HomogeneousField, ExcitationField, MixedField, OtherField
abstract type FieldStyle end
struct GradientField <: FieldStyle end
struct HomogeneousField <: FieldStyle end
struct ExcitationField <: FieldStyle end
struct MixedField <: FieldStyle end
struct OtherField <: FieldStyle end

export FieldStyle
FieldStyle(::AbstractMagneticField)::FieldStyle = OtherField()

export FieldDefinitionStyle,
  EquationBasedFieldDefinition,
  DataBasedFieldDefinition,
  MethodBasedFieldDefinition,
  SymbolicBasedFieldDefinition,
  CartesianDataBasedFieldDefinition,
  SphericalHarmonicsDataBasedFieldDefinition,
  MixedFieldDefinition,
  OtherFieldDefinition
abstract type FieldDefinitionStyle end
abstract type EquationBasedFieldDefinition <: FieldDefinitionStyle end
abstract type DataBasedFieldDefinition <: FieldDefinitionStyle end
struct MethodBasedFieldDefinition <: EquationBasedFieldDefinition end
struct SymbolicBasedFieldDefinition <: EquationBasedFieldDefinition end
struct CartesianDataBasedFieldDefinition <: DataBasedFieldDefinition end
struct SphericalHarmonicsDataBasedFieldDefinition <: DataBasedFieldDefinition end
struct MixedFieldDefinition <: FieldDefinitionStyle end
struct OtherFieldDefinition <: FieldDefinitionStyle end

export FieldDefinitionStyle
FieldDefinitionStyle(::AbstractMagneticField)::FieldDefinitionStyle =
  MethodBasedFieldDefinition()

export FieldTimeDependencyStyle, TimeVarying, TimeConstant
abstract type FieldTimeDependencyStyle end
struct TimeVarying <: FieldTimeDependencyStyle end
struct TimeConstant <: FieldTimeDependencyStyle end

# Base.length(::Type{TimeVarying}) = 1
# Base.length(::Type{TimeConstant}) = 0

export FieldTimeDependencyStyle
FieldTimeDependencyStyle(::AbstractMagneticField)::FieldTimeDependencyStyle = TimeConstant()

export isTimeVarying
isTimeVarying(field::AbstractMagneticField) = isTimeVarying(FieldTimeDependencyStyle(field))
isTimeVarying(::TimeVarying) = true
isTimeVarying(::TimeConstant) = false

export GradientFieldStyle,
  FFPGradientField, FFLGradientField, MixedGradientField, OtherGradientField
abstract type GradientFieldStyle end
struct FFPGradientField <: GradientFieldStyle end
struct FFLGradientField <: GradientFieldStyle end
struct MixedGradientField <: GradientFieldStyle end
struct OtherGradientField <: GradientFieldStyle end

export GradientFieldStyle
function GradientFieldStyle(field::AbstractMagneticField)
  return FieldStyle(field) == GradientField ? OtherGradientField() : nothing
end

export FieldMovementStyle,
  NoMovement, RotationalMovement, TranslationalMovement, RotationalTranslationalMovement
abstract type FieldMovementStyle end
struct NoMovement <: FieldMovementStyle end
struct RotationalMovement <: FieldMovementStyle end
struct TranslationalMovement <: FieldMovementStyle end
struct RotationalTranslationalMovement <: FieldMovementStyle end

export FieldMovementStyle
FieldMovementStyle(::AbstractMagneticField) = NoMovement()

export isRotatable
isRotatable(field::AbstractMagneticField) = isRotatable(FieldMovementStyle(field))
isRotatable(::FieldMovementStyle) = false
isRotatable(::RotationalMovement) = true
isRotatable(::RotationalTranslationalMovement) = true

export isTranslatable
isTranslatable(field::AbstractMagneticField) = isTranslatable(FieldMovementStyle(field))
isTranslatable(::FieldMovementStyle) = false
isTranslatable(::TranslationalMovement) = true
isTranslatable(::RotationalTranslationalMovement) = true

export DimensionalityStyle, ZeroDimensional, OneDimensional, TwoDimensional, ThreeDimensional
abstract type DimensionalityStyle end
struct ZeroDimensional <: DimensionalityStyle end
struct OneDimensional <: DimensionalityStyle end
struct TwoDimensional <: DimensionalityStyle end
struct ThreeDimensional <: DimensionalityStyle end

Base.length(::Type{ZeroDimensional}) = 0
Base.length(::Type{OneDimensional}) = 1
Base.length(::Type{TwoDimensional}) = 2
Base.length(::Type{ThreeDimensional}) = 3

export MovementDimensionalityStyle
abstract type MovementDimensionalityStyle{T <: DimensionalityStyle} end
function Base.length(::Type{<:MovementDimensionalityStyle{T}}) where {T <: DimensionalityStyle}
  return length(T)
end

export RotationalDimensionalityStyle
struct RotationalDimensionalityStyle{T <: DimensionalityStyle} <: MovementDimensionalityStyle{T} end
function RotationalDimensionalityStyle(field::AbstractMagneticField)
  return RotationalDimensionalityStyle(FieldMovementStyle(field), field)
end
function RotationalDimensionalityStyle(::FieldMovementStyle, field::AbstractMagneticField)
  return RotationalDimensionalityStyle{ZeroDimensional}()
end
function RotationalDimensionalityStyle(::RotationalMovement, field::AbstractMagneticField)
  return RotationalDimensionalityStyle{OneDimensional}()
end
function RotationalDimensionalityStyle(::RotationalTranslationalMovement, field::AbstractMagneticField)
  return RotationalDimensionalityStyle{OneDimensional}()
end

export TranslationalDimensionalityStyle
struct TranslationalDimensionalityStyle{T <: DimensionalityStyle} <: MovementDimensionalityStyle{T} end
function TranslationalDimensionalityStyle(field::AbstractMagneticField)
  return TranslationalDimensionalityStyle(FieldMovementStyle(field), field)
end
function TranslationalDimensionalityStyle(::FieldMovementStyle, field::AbstractMagneticField)
  return TranslationalDimensionalityStyle{ZeroDimensional}()
end
function TranslationalDimensionalityStyle(::TranslationalMovement, field::AbstractMagneticField)
  return TranslationalDimensionalityStyle{ThreeDimensional}()
end
function TranslationalDimensionalityStyle(::RotationalTranslationalMovement, field::AbstractMagneticField)
  return TranslationalDimensionalityStyle{ThreeDimensional}()
end

# Note: The followig functions are not needed atm but I will leave them here for the case of future needs
# listNumAdditionalParameters(field::AbstractMagneticField) = listNumAdditionalParameters(FieldTimeDependencyStyle(field), field)
# listNumAdditionalParameters(::TimeConstant, field::AbstractMagneticField) = listNumAdditionalParameters(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field)
# listNumAdditionalParameters(::TimeConstant, ::NoMovement, field::AbstractMagneticField) = []
# listNumAdditionalParameters(::TimeConstant, ::RotationalMovement, field::AbstractMagneticField) = [length(RotationalDimensionalityStyle(field))]
# listNumAdditionalParameters(::TimeConstant, ::TranslationalMovement, field::AbstractMagneticField) = [length(TranslationalDimensionalityStyle(field))]
# listNumAdditionalParameters(::TimeConstant, ::RotationalTranslationalMovement, field::AbstractMagneticField) = [length(TranslationalDimensionalityStyle(field)), length(TranslationalDimensionalityStyle(field))]

# listNumAdditionalParameters(::TimeVarying, field::AbstractMagneticField) = listNumAdditionalParameters(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field)
# listNumAdditionalParameters(::TimeVarying, ::NoMovement, field::AbstractMagneticField) = [1]
# listNumAdditionalParameters(::TimeVarying, ::RotationalMovement, field::AbstractMagneticField) = [1, length(RotationalDimensionalityStyle(field))]
# listNumAdditionalParameters(::TimeVarying, ::TranslationalMovement, field::AbstractMagneticField) = [1, length(TranslationalDimensionalityStyle(field))]
# listNumAdditionalParameters(::TimeVarying, ::RotationalTranslationalMovement, field::AbstractMagneticField) = [1, length(TranslationalDimensionalityStyle(field)), length(TranslationalDimensionalityStyle(field))]

# numAdditionalParameters(field::AbstractMagneticField) = sum(listNumAdditionalParameters(field))

# numMovementParameters(field::AbstractMagneticField) = numMovementParameters(FieldMovementStyle(field), field)
# numMovementParameters(::NoMovement, field::AbstractMagneticField) = 0
# numMovementParameters(::RotationalMovement, field::AbstractMagneticField) = 1
# numMovementParameters(::TranslationalMovement, field::AbstractMagneticField) = 1
# numMovementParameters(::RotationalTranslationalMovement, field::AbstractMagneticField) = 2