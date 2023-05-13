export AbstractSuperimposedField
"""
    $(TYPEDEF)

Abstract supertype for superimposed fields.
"""
abstract type AbstractSuperimposedField <: AbstractMagneticField end

export SuperimposedField
"""
    $(TYPEDEF)

Container for superimposed fields.

The fields in `fieldA` and `fieldB` are interpreted as being linearily superimposed.
"""
struct SuperimposedField <: AbstractSuperimposedField
  fieldA::AbstractMagneticField
  fieldB::AbstractMagneticField
end

FieldStyle(field::SuperimposedField) = FieldStyle(field.fieldA) == FieldStyle(field.fieldB) ? FieldStyle(field.fieldA) : MixedField()
FieldDefinitionStyle(field::SuperimposedField) = FieldDefinitionStyle(field.fieldA) == FieldDefinitionStyle(field.fieldB) ? FieldDefinitionStyle(field.fieldA) : MixedFieldDefinition()
FieldTimeDependencyStyle(field::SuperimposedField) = isTimeVarying(field.fieldA) || isTimeVarying(field.fieldB) ? TimeVarying() : TimeConstant()
GradientFieldStyle(field::SuperimposedField) = GradientFieldStyle(field.fieldA) == GradientFieldStyle(field.fieldB) ? GradientFieldStyle(field.fieldA) : MixedGradientField()

export superimpose
superimpose(fieldA::AbstractMagneticField, fieldB::AbstractMagneticField) = SuperimposedField(fieldA, fieldB)

value(field::SuperimposedField, args...) = value(field.fieldA, args...) .+ value(field.fieldB, args...)

isRotatable(field::SuperimposedField) = isRotatable(field.fieldA) || isRotatable(field.fieldB)
isTranslatable(field::SuperimposedField) = isTranslatable(field.fieldA) || isTranslatable(field.fieldB)
isTimeVarying(field::SuperimposedField) = isTimeVarying(field.fieldA) || isTimeVarying(field.fieldB)

export AbstractNegativeField
"""
    $(TYPEDEF)

Abstract supertype for negative fields.
"""
abstract type AbstractNegativeField <: AbstractMagneticField end

export NegativeField
"""
    $(TYPEDEF)

Container for negative fields.

The field of this container is interpreted as being the negative of `field`.
"""
struct NegativeField <: AbstractNegativeField
  field::AbstractMagneticField
end

FieldStyle(field::NegativeField) = FieldStyle(field.field)
FieldDefinitionStyle(field::NegativeField) = FieldDefinitionStyle(field.field)
FieldTimeDependencyStyle(field::NegativeField) = FieldTimeDependencyStyle(field.field)
GradientFieldStyle(field::NegativeField) = GradientFieldStyle(field.field)

export negative
negative(field::AbstractMagneticField) = NegativeField(field)

value(field::NegativeField, args...) = .-value(field.field, args...)

isRotatable(field::NegativeField) = isRotatable(field.field)
isTranslatable(field::NegativeField) = isTranslatable(field.field)
isTimeVarying(field::NegativeField) = isTimeVarying(field.field)

import Base.+, Base.-

(+)(fieldA::AbstractMagneticField, fieldB::AbstractMagneticField) = superimpose(fieldA, fieldB)
(-)(fieldA::AbstractMagneticField, fieldB::AbstractMagneticField) = superimpose(fieldA, -fieldB)
(-)(field::AbstractMagneticField) = negative(field)