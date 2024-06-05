include("MotionPatterns.jl")

export Sequence
"""
Abstract type for describing a sequence.
"""
abstract type Sequence end

export fieldOverTime
"""
Calculate the field for a given position `r` and at a given time point `t`
"""
fieldOverTime(seq::Sequence, field::AbstractMagneticField, t, r) =
  error("$(typeof(seq)) must implement `fieldOverTime`.")

export totalSequenceTime
"""
Total trajectory duration
"""
totalSequenceTime(seq::Sequence) = error("$(typeof(seq)) must implement `totalSequenceTime`.")

export MotionPatternSequence
"""
Abstract type for describing a sequence based on motion patterns.
"""
abstract type MotionPatternSequence <: Sequence end

export rotation
"""
Rotation pattern of the sequence
"""
rotation(seq::MotionPatternSequence) = error("$(typeof(seq)) must implement `rotation`.")

export translation
"""
Translation pattern of the sequence
"""
translation(seq::MotionPatternSequence) = error("$(typeof(seq)) must implement `translation`.")


export SequenceTemplate
"""
Abstract type for sequence templates which are a convenient way to construct sequences.
"""
abstract type SequenceTemplate end

export sequence
"""
Convert a sequence template to a regular sequence
"""
sequence(template::SequenceTemplate) = error("$(typeof(template)) must implement `sequence`.")

# Base.convert(::Type{<: Sequence}, template::SequenceTemplate) = sequence(template)

export RotationalSequence
struct RotationalSequence{TT, RPT} <: MotionPatternSequence where {TT <: Unitful.Time, RPT <: RotationPattern}
  "Total trajectory duration"
  T::TT
  "Rotation pattern of the sequence"
  rotationPattern::RPT
end

totalSequenceTime(seq::RotationalSequence) = seq.T
rotation(seq::RotationalSequence) = seq.rotationPattern
translation(seq::RotationalSequence) = NoTranslationPattern()

fieldOverTime(seq::RotationalSequence, field::AbstractMagneticField, t, r) = fieldOverTime(FieldMovementStyle(field), seq, field, t, r)
fieldOverTime(::NoMovement, seq::RotationalSequence, field::AbstractMagneticField, t, r) = error("The field `$(typeof(field))` does not support non-moving sequences.")
fieldOverTime(::RotationalMovement, seq::RotationalSequence, field::AbstractMagneticField, t, r) = isTimeVarying(field) ? value(field, t, r, motionAtTime(seq.rotationPattern, t)) : value(field, r, motionAtTime(seq.rotationPattern, t))
fieldOverTime(::TranslationalMovement, seq::RotationalSequence, field::AbstractMagneticField, t, r) = error("The field `$(typeof(field))` does not support solely translational sequences.")
fieldOverTime(::RotationalTranslationalMovement, seq::RotationalSequence, field::AbstractMagneticField, t, r) = error("The field `$(typeof(field))` does not support rotational plus translational sequences.")

export TranslationalSequence
struct TranslationalSequence{TT, TPT} <: MotionPatternSequence where {TT <: Unitful.Time, TPT <: TranslationPattern}
  "Total trajectory duration"
  T::TT
  "Translation pattern of the sequence"
  translationPattern::TPT
end

totalSequenceTime(seq::TranslationalSequence) = seq.T
rotation(seq::TranslationalSequence) = NoRotationPattern()
translation(seq::TranslationalSequence) = seq.translationPattern

fieldOverTime(seq::TranslationalSequence, field::AbstractMagneticField, t, r) = fieldOverTime(FieldMovementStyle(field), seq, field, t, r)
fieldOverTime(::NoMovement, seq::TranslationalSequence, field::AbstractMagneticField, t, r) = error("The field `$(typeof(field))` does not support non-moving sequences.")
fieldOverTime(::RotationalMovement, seq::TranslationalSequence, field::AbstractMagneticField, t, r) = error("The field `$(typeof(field))` does not support solely rotational sequences.")
fieldOverTime(::TranslationalMovement, seq::TranslationalSequence, field::AbstractMagneticField, t, r) = isTimeVarying(field) ? value(field, t, r, motionAtTime(seq.translationPattern, t)) : value(field, r, motionAtTime(seq.translationPattern, t))
fieldOverTime(::RotationalTranslationalMovement, seq::TranslationalSequence, field::AbstractMagneticField, t, r) = error("The field `$(typeof(field))` does not support rotational plus translational sequences.")

export RotationalTranslationalSequence
struct RotationalTranslationalSequence{TT, RPT, TPT} <: MotionPatternSequence where {TT <: Unitful.Time, RPT <: RotationPattern, TPT <: TranslationPattern}
  "Total trajectory duration"
  T::TT
  "Rotation pattern of the sequence"
  rotationPattern::RPT
  "Translation pattern of the sequence"
  translationPattern::TPT
end

totalSequenceTime(seq::RotationalTranslationalSequence) = seq.T
rotation(seq::RotationalTranslationalSequence) = seq.rotationPattern
translation(seq::RotationalTranslationalSequence) = seq.translationPattern

fieldOverTime(seq::RotationalTranslationalSequence, field::AbstractMagneticField, t, r) = fieldOverTime(FieldMovementStyle(field), seq, field, t, r)
fieldOverTime(::NoMovement, seq::RotationalTranslationalSequence, field::AbstractMagneticField, t, r) = error("The field `$(typeof(field))` does not support non-moving sequences.")
fieldOverTime(::RotationalMovement, seq::RotationalTranslationalSequence, field::AbstractMagneticField, t, r) = error("The field `$(typeof(field))` does not support solely rotational sequences.")
fieldOverTime(::TranslationalMovement, seq::RotationalTranslationalSequence, field::AbstractMagneticField, t, r) = error("The field `$(typeof(field))` does not support solely translational sequences.")
fieldOverTime(::RotationalTranslationalMovement, seq::RotationalTranslationalSequence, field::AbstractMagneticField, t, r) = isTimeVarying(field) ? value(field, t, r, motionAtTime(seq.rotationPattern, t), motionAtTime(seq.translationPattern, t)) : value(field, r, motionAtTime(seq.rotationPattern, t), motionAtTime(seq.translationPattern, t))

include("SequencedField.jl")