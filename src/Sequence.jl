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

Attaches a function to a field defining the movement over time. 
"""
struct SequencedField{T <: AbstractMagneticField} <: AbstractSequencedField
  field::T
  rotation::Function
  translation::Function
end

function SequencedField(field::T; rotation=t->0, translation=t->0) where {T <: AbstractMagneticField}
  return SequencedField(field, rotation, translation)
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

value_(field::SequencedField, t, r) = value_(FieldTimeDependencyStyle(field.field), FieldMovementStyle(field.field), field, t, r)

for fieldTimeDependencyStyle ∈ timeDependencyStylesCodeGeneration_
  for fieldMovementStyle ∈ movementStylesCodeGeneration_
    arguments = []

    if fieldTimeDependencyStyle == :TimeVarying
      push!(arguments, :t)
    end
    push!(arguments, :r)

    rotationalStyles_ = [:RotationalMovement, :RotationalTranslationalMovement]
    translationalStyles_ = [:TranslationalMovement, :RotationalTranslationalMovement]
    if fieldMovementStyle in rotationalStyles_
      if fieldMovementStyle in translationalStyles_
        push!(arguments, :(field.rotation(t)))
        push!(arguments, :(field.translation(t)))
      else
        push!(arguments, :(field.rotation(t)))
      end
    else
      if fieldMovementStyle in translationalStyles_
        push!(arguments, :(field.translation(t)))
      else
        # NOP
      end
    end

    funcBody = Expr(:call, :value_, :(field.field), arguments...)
    funcBodyExpr = Expr(:return, funcBody)

    @eval begin
      function value_(::$fieldTimeDependencyStyle, ::$fieldMovementStyle, field::SequencedField, t, r; kwargs...)
        $funcBodyExpr
      end
    end
  end
end