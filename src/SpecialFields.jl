
struct IdealFFP{GT, T, N, M} <: AbstractMagneticField{T, N, M} where {GT <: Number, T <: Number, N <: Integer, M <: Integer}
  gradient::GT
end

fieldType(::IdealFFP) = GradientField()
definitionType(::IdealFFP) = MethodBasedFieldDefinition()
timeDependencyType(::IdealFFP) = TimeConstant()
gradientFieldType(::IdealFFP) = FFPGradientField()

value(field::IdealFFP, r) = r.*field.gradient




struct IdealFFL{GT, T, N, M} <: AbstractMagneticField{T, N, M} where {GT <: Number, T <: Number, N <: Integer, M <: Integer}
  gradient::GT
end

fieldType(::IdealFFL) = GradientField()
definitionType(::IdealFFL) = MethodBasedFieldDefinition()
timeDependencyType(::IdealFFL) = TimeConstant()
gradientFieldType(::IdealFFL) = FFLGradientField()

value(field::IdealFFL, r, ϕ) = [-sin(ϕ)^2 -sin(ϕ)*cos(ϕ) 0; -sin(ϕ)*cos(ϕ) -cos(ϕ)^2 0; 0 0 1]*r.*field.gradient





# B_FFL(ϕ::T, r::U, gradient::Real) where {T <: Real, V <: Real, U <: SVector{3, V}} = [-sin(ϕ)^2 -sin(ϕ)*cos(ϕ) 0; -sin(ϕ)*cos(ϕ) -cos(ϕ)^2 0; 0 0 1]*r.*gradient
# B_FFL(ϕ::T, r::U, gradient::Real) where {T <: Real, V <: Real, U <: SVector{2, V}} = B_FFL(ϕ, SVector(r..., zero(eltype(r))), gradient)

# B_rot(ϕ::T, r::U, amplitude::W) where {T <: Real, V <: Unitful.Length, U <: SVector{3, V}, W <: Unitful.BField} = [sin(ϕ), cos(ϕ), 0].*amplitude
# B_rot(ϕ::T, r::U, amplitude::W) where {T <: Real, V <: Unitful.Length, U <: SVector{2, V}, W <: Unitful.BField} = B_rot(ϕ, SVector{3}(r..., zero(eltype(r))), amplitude)

# B_rot(ϕ::T, r::U, amplitude::W) where {T <: Real, V <: Real, U <: SVector{3, V}, W <: Real} = [sin(ϕ), cos(ϕ), 0].*amplitude
# B_rot(ϕ::T, r::U, amplitude::W) where {T <: Real, V <: Real, U <: SVector{2, V}, W <: Real} = B_rot(ϕ, SVector{3}(r..., zero(eltype(r))), amplitude)

# B_DF(ϕ::T, r::U, amplitude::W, direction=[0, 0, 1]) where {T <: Real, V <: Unitful.Length, U <: SVector{3, V}, W <: Unitful.BField} = SVector{3}(direction.*amplitude)
# #B_DF(ϕ::T, r::U, amplitude::W) where {T <: Real, V <: Unitful.Length, U <: SVector{2, V}, W <: Unitful.BField} = B_rot(ϕ, SVector{3}(r..., zero(eltype(r))), amplitude)

# #B_slow(ϕ, r, FF_amplitude, FFL_gradient) = B_FFL(ϕ, r, FFL_gradient) .+ B_rot(ϕ, r, FF_amplitude)
# B(ϕ, r, DF_amplitude, FF_amplitude, FFL_gradient) = B_DF(ϕ, r, DF_amplitude) .+ B_slow(ϕ, r, FF_amplitude, FFL_gradient)




# # TODO: This should be externalized

# mutable struct KolibriGradientField{T, N, M} <: AbstractMagneticField{T, N, M}
#   gradient::typeof(1.0u"T/m")
#   equation::Function
#   grid::RegularGridDefinition  
# end

# function KolibriGradientField(gradient = 5.0u"T/m", equation = nothing)
#   if isnothing(equation)
#     equation = (x, t) -> [0, 0, x[2]] # TODO: Specialize for M
#   end

#   return KolibriGradientField{Unitful.BField, 3, 3}(gradient, equation, RegularGridDefinition())
# end

# fieldType(::Type{KolibriGradientField}) = GradientField()
# gradientFieldType(::Type{KolibriGradientField}) = FFLGradientField()
# definitionType(::Type{KolibriGradientField}) = EquationBasedFieldDefinition()
# timeDependencyType(::Type{KolibriGradientField}) = TimeVarying()

# gradient(field::KolibriGradientField) = field.gradient

# Base.size(field::KolibriGradientField) = shape(grid)