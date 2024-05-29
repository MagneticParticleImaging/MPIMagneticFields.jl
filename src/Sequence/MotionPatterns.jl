export MotionPattern
"""
Abstract type for motion patterns describing e.g. rotations or translations.
"""
abstract type MotionPattern end

export motionAtTime
"""
Calculate the state of the motion at a given time point `t`
"""
motionAtTime(mot::MotionPattern, t) = error("$(typeof(mot)) must implement `motionAtTime`.")

include("RotationPatterns.jl")
include("TranslationPatterns.jl")
