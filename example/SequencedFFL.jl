using PyPlot
using LinearAlgebra
using Unitful

using MPIMagneticFields

field_ = IdealXYRotatedTranslatedFFL(5u"T/m")

f_ff = 200u"Hz"
A_ff = 80.0u"mT"
f_rot = 1u"Hz"
ωᵣₒₜ = 2π * u"rad" * f_rot
ϕᵣₒₜ = 0u"rad"
T = 1.0u"s"

sequence_ = RotationalTranslationalSequence(
  T,
  StandardRotationPattern(; ω = ωᵣₒₜ, ϕ = ϕᵣₒₜ),
  SinusoidalTranslationPattern(; f = f_ff, amplitude = A_ff, offset = 0.0u"mT"),
)

sequencedField = SequencedField(field_, sequence_)

figure()
for t in range(0, 1, 20)u"s"
  imshow(ustrip.(u"T", norm.(MPIMagneticFields.value(sequencedField, t, [-0.03:0.001:0.03, -0.03:0.001:0.03, 0.0]u"m"))))
  sleep(0.1)
end