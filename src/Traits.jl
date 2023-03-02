abstract type FieldType end
struct GradientField <: FieldType end
struct HomogeneousField <: FieldType end
struct ExcitationField <: FieldType end
struct MixedField <: FieldType end
struct OtherField <: FieldType end

fieldType(::AbstractMagneticField)::FieldType = @error "Not yet implemented"

abstract type FieldDefinitionType end
abstract type EquationBasedFieldDefinition <: FieldDefinitionType end
abstract type DataBasedFieldDefinition <: FieldDefinitionType end
struct MethodBasedFieldDefinition <: EquationBasedFieldDefinition end
struct SymbolicBasedFieldDefinition <: EquationBasedFieldDefinition end
struct CartesianDataBasedFieldDefinition <: DataBasedFieldDefinition end
struct SphericalHarmonicsDataBasedFieldDefinition <: DataBasedFieldDefinition end
struct MixedFieldDefinition <: FieldDefinitionType end

definitionType(::AbstractMagneticField)::FieldDefinitionType = @error "Not yet implemented"

abstract type FieldTimeDependencyType end
struct TimeVarying <: FieldTimeDependencyType end
struct TimeConstant <: FieldTimeDependencyType end

timeDependencyType(::AbstractMagneticField)::FieldTimeDependencyType = @error "Not yet implemented"
isTimeVarying(field::AbstractMagneticField) = timeDependencyType(field) isa TimeVarying

abstract type GradientFieldType end
struct FFPGradientField <: GradientFieldType end
struct FFLGradientField <: GradientFieldType end

gradientFieldType(field::AbstractMagneticField) = fieldType(field) isa GradientField ? @error "Not yet implemented" : nothing