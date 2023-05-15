#Base.size(S::SquaresVector) = (S.count,)
Base.IndexStyle(::Type{<:AbstractMagneticField}) = IndexCartesian()
Base.getindex(field::AbstractMagneticField, args...) = getindex_(FieldTimeDependencyStyle(field), field, args...)

getindex_(::TimeConstant, field::AbstractMagneticField, args...) = getindex_(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, args...)

getindex_(::TimeConstant, ::NoMovement, field::AbstractMagneticField, args...) = value(field, [args...])

getindex_(::TimeConstant, ::RotationalMovement, field::AbstractMagneticField, args...) = getindex_(FieldTimeDependencyStyle(field), FieldMovementStyle(field), RotationDimensionalityStyle(field), field, args...)
getindex_(::TimeConstant, ::RotationalMovement, ::RotationalDimensionalityStyle{OneDimensional}, field::AbstractMagneticField, args...) = value(field, [args[1:end-1]...], [args[end]...])
getindex_(::TimeConstant, ::RotationalMovement, ::RotationalDimensionalityStyle{TwoDimensional}, field::AbstractMagneticField, args...) = value(field, [args[1:end-2]...], [args[end-1:end]...])
getindex_(::TimeConstant, ::RotationalMovement, ::RotationalDimensionalityStyle{ThreeDimensional}, field::AbstractMagneticField, args...) = value(field, [args[1:end-3]...], [args[end-2:end]...])

getindex_(::TimeConstant, ::TranslationalMovement, field::AbstractMagneticField, args...) = getindex_(FieldTimeDependencyStyle(field), FieldMovementStyle(field), TranslationalDimensionalityStyle(field), field, args...)
getindex_(::TimeConstant, ::TranslationalMovement, ::RotationalDimensionalityStyle{OneDimensional}, field::AbstractMagneticField, args...) = value(field, [args[1:end-1]...], [args[end]...])
getindex_(::TimeConstant, ::TranslationalMovement, ::RotationalDimensionalityStyle{TwoDimensional}, field::AbstractMagneticField, args...) = value(field, [args[1:end-2]...], [args[end-1:end]...])
getindex_(::TimeConstant, ::TranslationalMovement, ::RotationalDimensionalityStyle{ThreeDimensional}, field::AbstractMagneticField, args...) = value(field, [args[1:end-3]...], [args[end-2:end]...])

getindex_(::TimeConstant, ::RotationalTranslationalMovement, field::AbstractMagneticField, args...) = getindex_(FieldTimeDependencyStyle(field), FieldMovementStyle(field), RotationDimensionalityStyle(field), TranslationalDimensionalityStyle(field), field, args...)
getindex_(::TimeConstant, ::RotationalTranslationalMovement, ::RotationalDimensionalityStyle{OneDimensional}, ::TranslationalDimensionalityStyle{OneDimensional}, field::AbstractMagneticField, args...) = value(field, [args[1:end-2]...], [args[end-1]...], [args[end]...])
getindex_(::TimeConstant, ::RotationalTranslationalMovement, ::RotationalDimensionalityStyle{OneDimensional}, ::TranslationalDimensionalityStyle{TwoDimensional}, field::AbstractMagneticField, args...) = value(field, [args[1:end-3]...], [args[end-2]...], [args[end-1:end]...])
getindex_(::TimeConstant, ::RotationalTranslationalMovement, ::RotationalDimensionalityStyle{OneDimensional}, ::TranslationalDimensionalityStyle{ThreeDimensional}, field::AbstractMagneticField, args...) = value(field, [args[1:end-4]...], [args[end-3]...], [args[end-2:end]...])
getindex_(::TimeConstant, ::RotationalTranslationalMovement, ::RotationalDimensionalityStyle{TwoDimensional}, ::TranslationalDimensionalityStyle{OneDimensional}, field::AbstractMagneticField, args...) = value(field, [args[1:end-3]...], [args[end-2:end-1]...], [args[end]...])
getindex_(::TimeConstant, ::RotationalTranslationalMovement, ::RotationalDimensionalityStyle{TwoDimensional}, ::TranslationalDimensionalityStyle{TwoDimensional}, field::AbstractMagneticField, args...) = value(field, [args[1:end-4]...], [args[end-3:end-2]...], [args[end-1:end]...])
getindex_(::TimeConstant, ::RotationalTranslationalMovement, ::RotationalDimensionalityStyle{TwoDimensional}, ::TranslationalDimensionalityStyle{ThreeDimensional}, field::AbstractMagneticField, args...) = value(field, [args[1:end-5]...], [args[end-4:end-3]...], [args[end-2:end]...])
getindex_(::TimeConstant, ::RotationalTranslationalMovement, ::RotationalDimensionalityStyle{ThreeDimensional}, ::TranslationalDimensionalityStyle{OneDimensional}, field::AbstractMagneticField, args...) = value(field, [args[1:end-4]...], [args[end-3:end-1]...], [args[end]...])
getindex_(::TimeConstant, ::RotationalTranslationalMovement, ::RotationalDimensionalityStyle{ThreeDimensional}, ::TranslationalDimensionalityStyle{TwoDimensional}, field::AbstractMagneticField, args...) = value(field, [args[1:end-5]...], [args[end-4:end-2]...], [args[end-1:end]...])
getindex_(::TimeConstant, ::RotationalTranslationalMovement, ::RotationalDimensionalityStyle{ThreeDimensional}, ::TranslationalDimensionalityStyle{ThreeDimensional}, field::AbstractMagneticField, args...) = value(field, [args[1:end-6]...], [args[end-5:end-3]...], [args[end-2:end]...])

getindex_(::TimeVarying, field::AbstractMagneticField, args...) = getindex_(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field, args...)

getindex_(::TimeVarying, ::NoMovement, field::AbstractMagneticField, args...) = value(field, args[1], [args[2:end]...])

getindex_(::TimeVarying, ::RotationalMovement, field::AbstractMagneticField, args...) = getindex_(FieldTimeDependencyStyle(field), FieldMovementStyle(field), RotationDimensionalityStyle(field), field, args...)
getindex_(::TimeVarying, ::RotationalMovement, ::RotationalDimensionalityStyle{OneDimensional}, field::AbstractMagneticField, args...) = value(field, args[1], [args[2:end-1]...], [args[end]...])
getindex_(::TimeVarying, ::RotationalMovement, ::RotationalDimensionalityStyle{TwoDimensional}, field::AbstractMagneticField, args...) = value(field, args[1], [args[2:end-2]...], [args[end-1:end]...])
getindex_(::TimeVarying, ::RotationalMovement, ::RotationalDimensionalityStyle{ThreeDimensional}, field::AbstractMagneticField, args...) = value(field, args[1], [args[2:end-3]...], [args[end-2:end]...])

getindex_(::TimeVarying, ::TranslationalMovement, field::AbstractMagneticField, args...) = getindex_(FieldTimeDependencyStyle(field), FieldMovementStyle(field), TranslationalDimensionalityStyle(field), field, args...)
getindex_(::TimeVarying, ::TranslationalMovement, ::RotationalDimensionalityStyle{OneDimensional}, field::AbstractMagneticField, args...) = value(field, args[1], [args[2:end-1]...], [args[end]...])
getindex_(::TimeVarying, ::TranslationalMovement, ::RotationalDimensionalityStyle{TwoDimensional}, field::AbstractMagneticField, args...) = value(field, args[1], [args[2:end-2]...], [args[end-1:end]...])
getindex_(::TimeVarying, ::TranslationalMovement, ::RotationalDimensionalityStyle{ThreeDimensional}, field::AbstractMagneticField, args...) = value(field, args[1], [args[2:end-3]...], [args[end-2:end]...])

getindex_(::TimeVarying, ::RotationalTranslationalMovement, field::AbstractMagneticField, args...) = getindex_(FieldTimeDependencyStyle(field), FieldMovementStyle(field), RotationDimensionalityStyle(field), TranslationalDimensionalityStyle(field), field, args...)
getindex_(::TimeVarying, ::RotationalTranslationalMovement, ::RotationalDimensionalityStyle{OneDimensional}, ::TranslationalDimensionalityStyle{OneDimensional}, field::AbstractMagneticField, args...) = value(field, args[1], [args[2:end-2]...], [args[end-1]...], [args[end]...])
getindex_(::TimeVarying, ::RotationalTranslationalMovement, ::RotationalDimensionalityStyle{OneDimensional}, ::TranslationalDimensionalityStyle{TwoDimensional}, field::AbstractMagneticField, args...) = value(field, args[1], [args[2:end-3]...], [args[end-2]...], [args[end-1:end]...])
getindex_(::TimeVarying, ::RotationalTranslationalMovement, ::RotationalDimensionalityStyle{OneDimensional}, ::TranslationalDimensionalityStyle{ThreeDimensional}, field::AbstractMagneticField, args...) = value(field, args[1], [args[2:end-4]...], [args[end-3]...], [args[end-2:end]...])
getindex_(::TimeVarying, ::RotationalTranslationalMovement, ::RotationalDimensionalityStyle{TwoDimensional}, ::TranslationalDimensionalityStyle{OneDimensional}, field::AbstractMagneticField, args...) = value(field, args[1], [args[2:end-3]...], [args[end-2:end-1]...], [args[end]...])
getindex_(::TimeVarying, ::RotationalTranslationalMovement, ::RotationalDimensionalityStyle{TwoDimensional}, ::TranslationalDimensionalityStyle{TwoDimensional}, field::AbstractMagneticField, args...) = value(field, args[1], [args[2:end-4]...], [args[end-3:end-2]...], [args[end-1:end]...])
getindex_(::TimeVarying, ::RotationalTranslationalMovement, ::RotationalDimensionalityStyle{TwoDimensional}, ::TranslationalDimensionalityStyle{ThreeDimensional}, field::AbstractMagneticField, args...) = value(field, args[1], [args[2:end-5]...], [args[end-4:end-3]...], [args[end-2:end]...])
getindex_(::TimeVarying, ::RotationalTranslationalMovement, ::RotationalDimensionalityStyle{ThreeDimensional}, ::TranslationalDimensionalityStyle{OneDimensional}, field::AbstractMagneticField, args...) = value(field, args[1], [args[2:end-4]...], [args[end-3:end-1]...], [args[end]...])
getindex_(::TimeVarying, ::RotationalTranslationalMovement, ::RotationalDimensionalityStyle{ThreeDimensional}, ::TranslationalDimensionalityStyle{TwoDimensional}, field::AbstractMagneticField, args...) = value(field, args[1], [args[2:end-5]...], [args[end-4:end-2]...], [args[end-1:end]...])
getindex_(::TimeVarying, ::RotationalTranslationalMovement, ::RotationalDimensionalityStyle{ThreeDimensional}, ::TranslationalDimensionalityStyle{ThreeDimensional}, field::AbstractMagneticField, args...) = value(field, args[1], [args[2:end-6]...], [args[end-5:end-3]...], [args[end-2:end]...])