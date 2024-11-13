export LimitedSequencedField
"""
    $(TYPEDEF)

Container for limited sequenced fields.

Applies field limits to a sequenced field.
"""
struct LimitedSequencedField{SFT <: AbstractSequencedField, T <: Number} <: AbstractSequencedField
  sequencedField::SFT
  lowerLimit::NTuple{3, T}
  upperLimit::NTuple{3, T}
end

FieldStyle(field::LimitedSequencedField)::FieldStyle = FieldStyle(field.sequencedField)
FieldDefinitionStyle(field::LimitedSequencedField)::FieldDefinitionStyle = FieldDefinitionStyle(field.sequencedField)
FieldTimeDependencyStyle(::LimitedSequencedField)::FieldTimeDependencyStyle = TimeVarying()
GradientFieldStyle(field::LimitedSequencedField)::GradientFieldStyle = GradientFieldStyle(field.sequencedField)
FieldMovementStyle(::LimitedSequencedField)::FieldMovementStyle = SequencedMovement()

isRotatable(field::LimitedSequencedField) = false # isRotatable(field.field)
isTranslatable(field::LimitedSequencedField) = false # isTranslatable(field.field)

RotationalDimensionalityStyle(field::LimitedSequencedField) = RotationalDimensionalityStyle{ZeroDimensional}() # RotationalDimensionalityStyle(field.field)
TranslationalDimensionalityStyle(field::LimitedSequencedField) = TranslationalDimensionalityStyle{ZeroDimensional}() # TranslationalDimensionalityStyle(field.field)

function value_(field::LimitedSequencedField, t, r)
  val = value(field.sequencedField, t, r)

  if eltype(val) <: AbstractVector
    val = [SVector{3}([val_[dim] < field.lowerLimit[dim] ? field.lowerLimit[dim] : (val_[dim] > field.upperLimit[dim] ? field.upperLimit[dim] : val_[dim]) for dim ∈ 1:3]) for val_ ∈ val]
  else
    val_ = val
    val = SVector{3}([val_[dim] < field.lowerLimit[dim] ? field.lowerLimit[dim] : (val_[dim] > field.upperLimit[dim] ? field.upperLimit[dim] : val_[dim]) for dim ∈ 1:3])
  end
  
  return val isa AbstractVector ? val : val[1]
end