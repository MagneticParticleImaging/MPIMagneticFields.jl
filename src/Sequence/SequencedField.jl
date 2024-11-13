export AbstractSequencedField
"""
    $(TYPEDEF)

Abstract supertype for sequenced fields.
"""
abstract type AbstractSequencedField <: AbstractMagneticField end

export SequencedField
"""
    $(TYPEDEF)

Container for sequenced fields.

Attaches a sequence to a field defining the movement over time.
"""
struct SequencedField{FT <: AbstractMagneticField, ST <: Sequence} <: AbstractSequencedField
  field::FT
  sequence::ST
end

FieldStyle(field::SequencedField)::FieldStyle = FieldStyle(field.field)
FieldDefinitionStyle(field::SequencedField)::FieldDefinitionStyle = FieldDefinitionStyle(field.field)
FieldTimeDependencyStyle(::SequencedField)::FieldTimeDependencyStyle = TimeVarying()
GradientFieldStyle(field::SequencedField)::GradientFieldStyle = GradientFieldStyle(field.field)
FieldMovementStyle(::SequencedField)::FieldMovementStyle = SequencedMovement()

isRotatable(field::SequencedField) = false # isRotatable(field.field)
isTranslatable(field::SequencedField) = false # isTranslatable(field.field)

RotationalDimensionalityStyle(field::SequencedField) = RotationalDimensionalityStyle{ZeroDimensional}() # RotationalDimensionalityStyle(field.field)
TranslationalDimensionalityStyle(field::SequencedField) = TranslationalDimensionalityStyle{ZeroDimensional}() # TranslationalDimensionalityStyle(field.field)

value_(field::SequencedField, t, r) = fieldOverTime(field.sequence, field.field, t, r)

include("LimitedSequencedField.jl")