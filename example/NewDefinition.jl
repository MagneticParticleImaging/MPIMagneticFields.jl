using MPIMagneticFields
using PyPlot
using LinearAlgebra

mutable struct IdealDipoleField{T, V} <: AbstractMagneticField where {T <: Number, V <: AbstractVector{T}}
  magneticMoment::V

  function IdealDipoleField(magneticMoment::V) where {T <: Number, V <: AbstractVector{T}}
    return new{T, V}(magneticMoment)
  end
end

MPIMagneticFields.FieldStyle(::IdealDipoleField) = OtherField()
MPIMagneticFields.FieldDefinitionStyle(::IdealDipoleField) = MethodBasedFieldDefinition()
MPIMagneticFields.FieldTimeDependencyStyle(::IdealDipoleField) = TimeConstant()

function MPIMagneticFields.value_(field::IdealDipoleField, r)
  if norm(r) == 0
    return zeros(eltype(field.magneticMoment), length(field.magneticMoment))
  else
    return μ₀ / (4 * π) * (3 .* r .* dot(field.magneticMoment, r) ./ norm(r)^5 .- field.magneticMoment * norm(r)^3)
  end
end

dipole = IdealDipoleField([0.1, 0.0, 0.0])

xyRange = -0.02:0.0001:0.02
quiverPoints = [(x, y) for x ∈ xyRange[1:50:end] for y ∈ xyRange[1:50:end]]
X = [x for (x, y) ∈ quiverPoints]
Y = [y for (x, y) ∈ quiverPoints]
U = [dipole[x, y, 0][1] for (x, y) ∈ quiverPoints]
V = [dipole[x, y, 0][2] for (x, y) ∈ quiverPoints]

figure(1)
imshow(
  log.(norm.(dipole[xyRange, xyRange, 0]));
  extent = (minimum(xyRange), maximum(xyRange), minimum(xyRange), maximum(xyRange)),
)
quiver(X, Y, U, V)
