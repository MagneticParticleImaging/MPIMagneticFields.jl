export FieldStyle, GradientField, HomogeneousField, ExcitationField, MixedField, OtherField
abstract type FieldStyle end
struct GradientField <: FieldStyle end
struct HomogeneousField <: FieldStyle end
struct ExcitationField <: FieldStyle end
struct MixedField <: FieldStyle end
struct OtherField <: FieldStyle end

export FieldStyle
FieldStyle(::AbstractMagneticField)::FieldStyle = OtherField()

export FieldDefinitionStyle, EquationBasedFieldDefinition, DataBasedFieldDefinition,
       MethodBasedFieldDefinition, SymbolicBasedFieldDefinition, CartesianDataBasedFieldDefinition,
       SphericalHarmonicsDataBasedFieldDefinition, MixedFieldDefinition, OtherFieldDefinition
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
FieldDefinitionStyle(::AbstractMagneticField)::FieldDefinitionStyle = MethodBasedFieldDefinition()

export FieldTimeDependencyStyle, TimeVarying, TimeConstant
abstract type FieldTimeDependencyStyle end
struct TimeVarying <: FieldTimeDependencyStyle end
struct TimeConstant <: FieldTimeDependencyStyle end

export FieldTimeDependencyStyle
FieldTimeDependencyStyle(::AbstractMagneticField)::FieldTimeDependencyStyle = TimeConstant()

export isTimeVarying
isTimeVarying(field::AbstractMagneticField) = isTimeVarying(FieldTimeDependencyStyle(field))
isTimeVarying(::TimeVarying) = true
isTimeVarying(::TimeConstant) = false

export GradientFieldStyle, FFPGradientField, FFLGradientField, MixedGradientField, OtherGradientField
abstract type GradientFieldStyle end
struct FFPGradientField <: GradientFieldStyle end
struct FFLGradientField <: GradientFieldStyle end
struct MixedGradientField <: GradientFieldStyle end
struct OtherGradientField <: GradientFieldStyle end

export GradientFieldStyle
GradientFieldStyle(field::AbstractMagneticField) = FieldStyle(field) == GradientField ? OtherGradientField() : nothing

export FieldMovementStyle, NoMovement, RotationalMovement, TranslationalMovement, RotationalTranslationalMovement
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

abstract type DimensionalityStyle end
struct OneDimensional <: DimensionalityStyle end
struct TwoDimensional <: DimensionalityStyle end
struct ThreeDimensional <: DimensionalityStyle end

Base.length(::OneDimensional) = 1
Base.length(::TwoDimensional) = 2
Base.length(::ThreeDimensional) = 3

export RotationalDimensionalityStyle
struct RotationalDimensionalityStyle{T <: DimensionalityStyle} end
RotationDimensionalityStyle(::AbstractMagneticField) = RotationalDimensionalityStyle{OneDimensional}()

export TranslationalDimensionalityStyle
struct TranslationalDimensionalityStyle{T <: DimensionalityStyle} end
TranslationDimensionalityStyle(::AbstractMagneticField) = TranslationalDimensionalityStyle{ThreeDimensional}()