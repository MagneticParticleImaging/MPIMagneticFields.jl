using MPIMagneticFields
using PyPlot
using LinearAlgebra

mutable struct MatrixDefinedField{V} <: AbstractMagneticField where {T <: Number, U <: AbstractVector{T}, V <: AbstractArray{U}}
  matrix::V
  xStart::Float64
  xStop::Float64
  yStart::Float64
  yStop::Float64
  zStart::Float64
  zStop::Float64

  function MatrixDefinedField(matrix::V, xStart, xStop, yStart, yStop, zStart, zStop) where {T <: Number, U <: AbstractVector{T}, V <: AbstractArray{U}}
    return new{V}(matrix, xStart, xStop, yStart, yStop, zStart, zStop)
  end
end

MPIMagneticFields.FieldStyle(::MatrixDefinedField) = OtherField()
MPIMagneticFields.FieldDefinitionStyle(::MatrixDefinedField) = MethodBasedFieldDefinition()
MPIMagneticFields.FieldTimeDependencyStyle(::MatrixDefinedField) = TimeConstant()

function MPIMagneticFields.value_(field::MatrixDefinedField, r)
  xRange = range(start=field.xStart, stop=field.xStop, length=size(field.matrix, 1))
  yRange = range(start=field.yStart, stop=field.yStop, length=size(field.matrix, 2))
  zRange = range(start=field.zStart, stop=field.zStop, length=size(field.matrix, 1))

  xIdx = findfirst(xRange .== r[1])
  yIdx = findfirst(yRange .== r[2])
  zIdx = findfirst(zRange .== r[3])
  
  return field.matrix[xIdx, yIdx, zIdx]
end

test = MatrixDefinedField([[x, y, z] for x ∈ -0.2:0.01:0.2, y ∈ -0.2:0.01:0.2, z ∈ -0.2:0.01:0.2], -0.2, 0.2, -0.2, 0.2, -0.2, 0.2)
focusfield = IdealHomogeneousField([0.01, 0, 0])
superimposed = test + focusfield

imshow(norm.(superimposed[-0.05:0.01:0.05, -0.05:0.01:0.05, 0]))