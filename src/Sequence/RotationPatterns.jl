
export RotationPattern
"""
Abstract type describing rotational motions.
"""
abstract type RotationPattern <: MotionPattern end

export NoRotationPattern
"""
Rotational movement pattern describing a non-existing movement.
"""
struct NoRotationPattern <: RotationPattern end

motionAtTime(::NoRotationPattern, t::T) where {T <: Number} = 0
motionAtTime(::NoRotationPattern, t::T) where {T <: AbstractVector} = zeros(T, length(t))

# TODO: This is only 1D. Other cases will be added when need arises

export StandardRotationPattern
"""
Standard rotational movement defined by an angular frequency `ω` and a phase `ϕ`
"""
@kwdef struct StandardRotationPattern <: RotationPattern
  "Angular frequency"
  ω::typeof(1.0u"rad/s")
  "Phase of the rotation"
  ϕ::typeof(1.0u"rad") = 0.0u"rad"
end

motionAtTime(rot::StandardRotationPattern, t) = sawtoothwave.(upreferred.(t .* rot.ω .+ rot.ϕ)) .* π

export NoisyRotationPattern
"""
Rotational movement extending the [`StandardRotationPattern`](@ref) by a random deviation.
"""
struct NoisyRotationPattern <: RotationPattern
  standardRotation::StandardRotationPattern
  noiseAmplitude::Real
  seed::Float64

  function NoisyRotationPattern(; ω, ϕ = 0.0u"rad", noiseAmplitude, seed = 0)
    return new(StandardRotationPattern(ω, ϕ), noiseAmplitude, seed)
  end
end

function motionAtTime(rot::NoisyRotationPattern, t)
  rng = MersenneTwister(rot.seed)
  return motionAtTime(rot.standardRotation, t) .+
         rot.noiseAmplitude .* randn(rng, Float64, length(t), rot.seed)
end

# @kwdef struct LaggingRotation <: RotationPattern
#   ω::typeof(1.0u"rad/s") = 2π*u"rad/s"
#   ϕ::typeof(1.0u"rad") = 0.0u"rad"
#   numLags::Integer = 3
#   plateauFraction::Real = 0.9
# end

# function rotationAtTime(rot::LaggingRotation, t)
#   steps = length(t)
#   lagDistance = round(Int64, (steps-rot.numLags*lagSteps)/(numLags+1))
#   plateauSteps = round(Int64, lagSteps*plateauFraction)
#   rampSteps = lagSteps-plateauSteps

#   for i = 1:numLags
#     lagStart = i*lagDistance+(i-1)*lagSteps
#     lagStop = lagStart+lagSteps-1
#     t[lagStart:lagStart+plateauSteps] .= t[lagStart-1]
#     t[lagStart+plateauSteps:lagStop] = collect(range(t[lagStart-1], t[lagStop], rampSteps))
#   end

#   return t
# end

# export stickSlipRotation
# function stickSlipRotation(steps::Integer; waveform::Symbol=:sine, amplitude::Real=π/16, periods::Integer=5)
#   t = collect(range(0, 2π, steps))

#   if waveform == :sine
#     t = t .+ amplitude.*sin.(periods*t)
#   elseif waveform == :triangle
#     t = t .+ amplitude.*trianglewave.(periods*t)
#   else
#     error("Unknown waveform `$waveform`.")
#   end

#   return t
# end
