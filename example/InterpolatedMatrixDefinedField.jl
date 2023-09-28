# This example describes how to define a field based on a matrix (e.g. measurement data) and apply an interpolation to it
# Note: This field implementation is not included in the common fields of this package since it would add a dependency on Interpolations.
using MPIMagneticFields
using Interpolations
using PyPlot
using LinearAlgebra
using Unitful

export InterpolatedMatrixDefinedField
mutable struct InterpolatedMatrixDefinedField{T} <: AbstractMagneticField where {T <: AbstractInterpolation}
  itp::T
  fieldStyle::FieldStyle

  function InterpolatedMatrixDefinedField(matrix::V, fov::Vector{W}, center::Vector{W}; fieldStyle=OtherField(), interpolationStyle=BSpline(Linear()), extrapolationValue=missing) where {T <: Number, U <: AbstractVector{T}, V <: AbstractArray{U}, W <: Number}
    @assert ndims(matrix) == length(fov) == length(center)

    matrixReshaped = reshape(reduce(hcat, matrix), (:, size(matrix)...)) # Array of Vectors can't be interpolated
    ranges = [dim == 0 ? (1:length(first(matrix))) : (size(matrix, dim) > 1 ? range(start=-fov[dim]/2+center[dim], stop=fov[dim]/2+center[dim], length=size(matrix, dim)) : center[dim]:oneunit(eltype(center)):center[dim]) for dim in 0:ndims(matrix)]

    itpSettings = Tuple([length(range) == 1 || i == 1 ? NoInterp() : interpolationStyle for (i, range) in enumerate(ranges)])
    itp = extrapolate(interpolate(matrixReshaped, itpSettings), extrapolationValue)
    sitp = scale(itp, ranges...)

    return new{typeof(sitp)}(sitp, fieldStyle)
  end
end

MPIMagneticFields.FieldStyle(field::InterpolatedMatrixDefinedField) = field.fieldStyle
MPIMagneticFields.FieldDefinitionStyle(::InterpolatedMatrixDefinedField) = MethodBasedFieldDefinition()
MPIMagneticFields.FieldTimeDependencyStyle(::InterpolatedMatrixDefinedField) = TimeConstant()

function MPIMagneticFields.value_(field::InterpolatedMatrixDefinedField, r)
  return field.itp[field.itp.ranges[1], r...]
end

matrix = [[x, y, z] for x ∈ (-0.2:0.01:0.2)u"T", y ∈ (-0.2:0.01:0.2)u"T", z ∈ (-0.2:0.01:0.2)u"T"]
fov = [40, 40, 40]u"mm"
center = [0, 0, 0]u"mm"
field = InterpolatedMatrixDefinedField(matrix, fov, center)

imshow(ustrip.(u"T", norm.(field[(-5:0.1:5)u"mm", (-5:0.1:5)u"mm", 0u"mm"])))