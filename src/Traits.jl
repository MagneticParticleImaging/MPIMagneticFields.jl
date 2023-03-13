export FieldType, GradientField, HomogeneousField, ExcitationField, MixedField, OtherField
abstract type FieldType end
struct GradientField <: FieldType end
struct HomogeneousField <: FieldType end
struct ExcitationField <: FieldType end
struct MixedField <: FieldType end
struct OtherField <: FieldType end

export fieldType
fieldType(::AbstractMagneticField)::FieldType = error("Not yet implemented")

export FieldDefinitionType, EquationBasedFieldDefinition, DataBasedFieldDefinition,
       MethodBasedFieldDefinition, SymbolicBasedFieldDefinition, CartesianDataBasedFieldDefinition,
       SphericalHarmonicsDataBasedFieldDefinition, MixedFieldDefinition
abstract type FieldDefinitionType end
abstract type EquationBasedFieldDefinition <: FieldDefinitionType end
abstract type DataBasedFieldDefinition <: FieldDefinitionType end
struct MethodBasedFieldDefinition <: EquationBasedFieldDefinition end
struct SymbolicBasedFieldDefinition <: EquationBasedFieldDefinition end
struct CartesianDataBasedFieldDefinition <: DataBasedFieldDefinition end
struct SphericalHarmonicsDataBasedFieldDefinition <: DataBasedFieldDefinition end
struct MixedFieldDefinition <: FieldDefinitionType end

export definitionType
definitionType(::AbstractMagneticField)::FieldDefinitionType = error("Not yet implemented")

export FieldTimeDependencyType, TimeVarying, TimeConstant
abstract type FieldTimeDependencyType end
struct TimeVarying <: FieldTimeDependencyType end
struct TimeConstant <: FieldTimeDependencyType end

export timeDependencyType
timeDependencyType(::AbstractMagneticField)::FieldTimeDependencyType = error("Not yet implemented")

export isTimeVarying
isTimeVarying(field::AbstractMagneticField) = timeDependencyType(field) isa TimeVarying

export GradientFieldType, FFPGradientField, FFLGradientField
abstract type GradientFieldType end
struct FFPGradientField <: GradientFieldType end
struct FFLGradientField <: GradientFieldType end

export gradientFieldType
gradientFieldType(field::AbstractMagneticField) = fieldType(field) == GradientField ? (error("Not yet implemented")) : nothing

export FieldMovementType, NoMovement, RotationalMovement, TranslationalMovement
abstract type FieldMovementType end
struct NoMovement <: FieldMovementType end
struct RotationalMovement <: FieldMovementType end
struct TranslationalMovement <: FieldMovementType end

export fieldMovementType
fieldMovementType(::AbstractMagneticField) = NoMovement() # Default

function compareFieldMovementType_(fieldMovementType, compareTo::CT) where {CT <: Type{<:FieldMovementType}}
  return any([fieldMovementType_ isa compareTo for fieldMovementType_ in fieldMovementType])
end
compareFieldMovementType_(fieldMovementType::T, compareTo::CT) where {T <: FieldMovementType, CT <: Type{<:FieldMovementType}} = fieldMovementType isa compareTo

export isRotatable
isRotatable(field::AbstractMagneticField) = compareFieldMovementType_(fieldMovementType(field), RotationalMovement)

export isTranslatable
isTranslatable(field::AbstractMagneticField) = compareFieldMovementType_(fieldMovementType(field), TranslationalMovement)