export TranslationPattern
"""
Abstract type describing translational motions.
"""
abstract type TranslationPattern <: MotionPattern end

export frequency, phase, amplitude, offset

export NoTranslationPattern
"""
Translational movement pattern describing a non-existing movement.
"""
struct NoTranslationPattern <: TranslationPattern end

motionAtTime(::NoTranslationPattern, t::T) where {T <: Number} = 0u"mT"
motionAtTime(::NoTranslationPattern, t::T) where {T <: AbstractVector} = fill(0u"mT", length(t))

# TODO: This is only 1D. Other cases will be added when need arises

export SinusoidalTranslationPattern
"""
Translational movement pattern describing a sinusoidal movement.
"""
@kwdef struct SinusoidalTranslationPattern{FT, T} <: TranslationPattern where {FT <: Unitful.Frequency, T <: Number}
  "Frequency of the sinusoidal movement"
  f::FT
  "Phase of the sinusoidal movement"
  ϕ::typeof(1.0u"rad") = 0.0u"rad"
  "Amplitude of the sinusoidal movement"
  amplitude::T
  "Offset of the sinusoidal movement"
  offset::T
end

function motionAtTime(trans::SinusoidalTranslationPattern, t)
  return trans.amplitude .* sin.(2π .* trans.f .* t .+ trans.ϕ) .+ trans.offset
end

"""
Frequency of the translation pattern.
"""
frequency(trans::SinusoidalTranslationPattern) = trans.f

"""
Phase of the translation pattern.
"""
phase(trans::SinusoidalTranslationPattern) = trans.ϕ

"""
Amplitude of the translation pattern.
"""
amplitude(trans::SinusoidalTranslationPattern) = trans.amplitude

"""
Offset of the translation pattern.
"""
offset(trans::SinusoidalTranslationPattern) = trans.offset

export SawtoothTranslationPattern
"""
Translational movement pattern describing a sawtooth-like movement.
"""
@kwdef struct SawtoothTranslationPattern{FT, T} <: TranslationPattern where {FT <: Unitful.Frequency, T <: Number}
  "Frequency of the sawtooth-like movement"
  f::FT
  "Phase of the sawtooth-like movement"
  ϕ::typeof(1.0u"rad") = 0.0u"rad"
  "Amplitude of the sawtooth-like movement"
  amplitude::T
  "Offset of the sawtooth-like movement"
  offset::T
end

function motionAtTime(trans::SawtoothTranslationPattern, t)
  return trans.amplitude .* sawtooth.(2π .* trans.f .* t .+ trans.ϕ) .+ trans.offset
end

"""
Frequency of the translation pattern.
"""
frequency(trans::SawtoothTranslationPattern) = trans.f

"""
Phase of the translation pattern.
"""
phase(trans::SawtoothTranslationPattern) = trans.ϕ

"""
Amplitude of the translation pattern.
"""
amplitude(trans::SawtoothTranslationPattern) = trans.amplitude

"""
Offset of the translation pattern.
"""
offset(trans::SawtoothTranslationPattern) = trans.offset

export TriangleTranslationPattern
"""
Translational movement pattern describing a triangle-like movement.
"""
@kwdef struct TriangleTranslationPattern{FT, T} <: TranslationPattern where {FT <: Unitful.Frequency, T <: Number}
  "Frequency of the triangle-like movement"
  f::FT
  "Phase of the triangle-like movement"
  ϕ::typeof(1.0u"rad") = 0.0u"rad"
  "Amplitude of the triangle-like movement"
  amplitude::T
  "Offset of the triangle-like movement"
  offset::T
end

function motionAtTime(trans::TriangleTranslationPattern, t)
  return trans.amplitude .* sawtooth.(2π .* trans.f .* t .+ trans.ϕ) .+ trans.offset
end

"""
Frequency of the translation pattern.
"""
frequency(trans::TriangleTranslationPattern) = trans.f

"""
Phase of the translation pattern.
"""
phase(trans::TriangleTranslationPattern) = trans.ϕ

"""
Amplitude of the translation pattern.
"""
amplitude(trans::TriangleTranslationPattern) = trans.amplitude

"""
Offset of the translation pattern.
"""
offset(trans::TriangleTranslationPattern) = trans.offset
