#Base.size(S::SquaresVector) = (S.count,)
Base.IndexStyle(::Type{<:AbstractMagneticField}) = IndexCartesian()
Base.getindex(mf::FT, i) where FT <: AbstractMagneticField = getindex(definitionType(typeof(mf)), i)

LinearAlgebra.norm(field::FT) where FT <: AbstractMagneticField = [norm(field[i]) for i ∈ eachindex(field)]