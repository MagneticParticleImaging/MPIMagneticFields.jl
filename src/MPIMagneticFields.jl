module MPIMagneticFields

using StaticArrays
using Waveforms
using LinearAlgebra
using TOML
using Unitful
using Symbolics
using DocStringExtensions
using GeometryBasics
using Graphics: @mustimplement

"""
    $(TYPEDEF)

Abstract supertype for magnetic fields.

The type is defined by `T`, the number of dimensions by `N` and the vector field dimension by `M`.
"""
abstract type AbstractMagneticField{T, N, M} <: AbstractArray{T, N} end

#Base.size(S::SquaresVector) = (S.count,)
Base.IndexStyle(::Type{<:AbstractMagneticField}) = IndexCartesian()
Base.getindex(mf::FT, i) where FT <: AbstractMagneticField = getindex(definitionType(typeof(mf)), i)

abstract type FieldType end
struct GradientField <: FieldType end
struct HomogeneousField <: FieldType end
struct ExcitationField <: FieldType end
struct MixedField <: FieldType end
struct OtherField <: FieldType end

@mustimplement fieldType(::AbstractMagneticField)::FieldType

abstract type FieldDefinitionType end
abstract type EquationBasedFieldDefinition <: FieldDefinitionType end
abstract type DataBasedFieldDefinition <: FieldDefinitionType end
struct MethodBasedFieldDefinition <: EquationBasedFieldDefinition end
struct SymbolicBasedFieldDefinition <: EquationBasedFieldDefinition end
struct CartesianDataBasedFieldDefinition <: DataBasedFieldDefinition end
struct SphericalHarmonicsDataBasedFieldDefinition <: DataBasedFieldDefinition end
struct MixedFieldDefinition <: FieldDefinitionType end

@mustimplement definitionType(::AbstractMagneticField)::FieldDefinitionType

abstract type FieldTimeDependencyType end
struct TimeVarying <: FieldTimeDependencyType end
struct TimeConstant <: FieldTimeDependencyType end

@mustimplement timeDependencyType(::AbstractMagneticField)::FieldTimeDependencyType

abstract type GradientFieldType end
struct FFPGradientField <: GradientFieldType end
struct FFLGradientField <: GradientFieldType end

@mustimplement gradientFieldType(::AbstractMagneticField)::GradientFieldType

LinearAlgebra.norm(field::FT) where FT <: AbstractMagneticField = [norm(field[i]) for i ∈ eachindex(field)]

abstract type FieldDefinitionVolume end

struct RegularGridDefinition{T, N} <: FieldDefinitionVolume where {T <: Unitful.Length, N <: Integer}
  shape::SVector{N, Int}
  fov::SVector{N, T}
  center::SVector{N, T}
end

# data function for DataBasedFieldDefinition
# equation for struct EquationBasedFieldDefinition

# Frage: Wie können mehrere Felder superpositioniert werden?
# TODO: Typen, damit man per trait dispatchend kann
# Idee_ Drei Felder für die einzelnen Definitionsarten -> Skaliert nicht, falls Dispatch erweitert werden soll
struct SuperimposedField{T, N, M} <: AbstractMagneticField{T, N, M}
  fields::SVector{AbstractMagneticField{T, N, M}}
end

# TODO: Compile-time definition of this
fieldType(::Type{SuperimposedField}) = MixedField()
definitionType(::Type{SuperimposedField}) = MixedFieldDefinition()
timeDependencyType(::Type{SuperimposedField}) = TimeVarying()
#gradientFieldType(::Type{SuperimposedField}) = gradientFieldType(field.field)

#TODO: Use dispatch here instead of if
function superimpose(field1::T1, field2::T2) where {T1, T2 <: AbstractMagneticField}
  if definitionType(T1) isa EquationBasedFieldDefinition
    
  elseif definitionType(T1) isa DataBasedFieldDefinition

  else
    error("Case not defined")
  end
end

# TODO: Properly specify type of field
struct NegativeField{T, N, M} <: AbstractMagneticField{T, N, M}
  field::AbstractMagneticField{T, N, M}

  function NegativeField(field::FT) where FT <: AbstractMagneticField
    if definitionType(FT) isa DataBasedFieldDefinition
      # TODO: Iterate and negate all vectors in field
      return field
    elseif definitionType(FT) isa EquationBasedFieldDefinition
      return NegativeField(FT)
    else
      error("Not yet implemented")
    end
  end
end



fieldType(::Type{NegativeField}) = fieldType(field.field)
definitionType(::Type{NegativeField}) = definitionType(field.field)
timeDependencyType(::Type{NegativeField}) = timeDependencyType(field.field)
gradientFieldType(::Type{NegativeField}) = gradientFieldType(field.field)

import Base.+, Base.-

(+)(field1::T1, field2::T2) where {T1 <: AbstractMagneticField, T2 <: AbstractMagneticField} = superimpose(field1, field2)
(-)(field1::T1, field2::T2) where {T1 <: AbstractMagneticField, T2 <: AbstractMagneticField} = superimpose(field1, -field2)
(-)(field::T) where {T <: AbstractMagneticField} = NegativeField(field)



mutable struct KolibriGradientField{T, N, M} <: AbstractMagneticField{T, N, M}
  gradient::typeof(1.0u"T/m")
  equation::Function
  grid::RegularGridDefinition  
end

function KolibriGradientField(gradient = 5.0u"T/m", equation = nothing)
  if isnothing(equation)
    equation = (x, t) -> [0, 0, x[2]] # TODO: Specialize for M
  end

  return KolibriGradientField{Unitful.BField, 3, 3}(gradient, equation, RegularGridDefinition())
end

fieldType(::Type{KolibriGradientField}) = GradientField()
gradientFieldType(::Type{KolibriGradientField}) = FFLGradientField()
definitionType(::Type{KolibriGradientField}) = EquationBasedFieldDefinition()
timeDependencyType(::Type{KolibriGradientField}) = TimeVarying()

gradient(field::KolibriGradientField) = field.gradient

Base.size(field::KolibriGradientField) = shape(grid)


end



#==

using Unitful, PyPlot, LinearAlgebra
gradient = 5.0u"T/m"
field = [upreferred.([0.0u"T", z*gradient, y*gradient]) for x=-20u"mm":0.5u"mm":20u"mm", y=-20u"mm":0.5u"mm":20u"mm", z=-20u"mm":0.5u"mm":20u"mm"]
imshow(ustrip.(u"T", [norm(field[x, y, z]) for x=1:81, y=1, z=1:81]))

https://juliageometry.github.io/GeometryBasics.jl/stable/

Interpolator und eventuell alte Werte cachen

ReceiveCoil hat <: AbstractField

AbstractEuclideanSpace



GradientField kann eine Funktion definieren, um die Rotation (oder Translation) abzubilden


Dimensionen angeben (1, 2, 3), Vektorfeld zusätzliche Dimensionen -> Rotation wird über Rotation der Vektoren beschrieben

mutable struct RegularGridPositions{T} <: GridPositions where {T<:Unitful.Length}
  shape::Vector{Int}
  fov::Vector{T}
  center::Vector{T}
  sign::Vector{Int}
end

https://github.com/JuliaArrays/StaticArrays.jl
https://juliaarrays.github.io/ArraysOfArrays.jl/stable/#section_ArrayOfSimilarArrays
https://github.com/JuliaArrays/AxisArrays.jl
https://github.com/JuliaArrays/HybridArrays.jl
https://juliaarrays.github.io/SpatioTemporalTraits.jl/stable/
https://github.com/JuliaArrays/RangeArrays.jl

https://docs.julialang.org/en/v1/manual/interfaces/

==#

end
