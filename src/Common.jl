#Base.size(S::SquaresVector) = (S.count,)
Base.IndexStyle(::Type{<:AbstractMagneticField}) = IndexCartesian()
Base.getindex(field::AbstractMagneticField, r...) = value(field, [r...]) # TODO: How to deal with rotation and translation?

# TODO: This only works with eachindex() available, which is only the case for fields defining a grid. How shall we solve this? Create a container?
LinearAlgebra.norm(field::AbstractMagneticField) = [norm(field[i]) for i ∈ eachindex(field)]