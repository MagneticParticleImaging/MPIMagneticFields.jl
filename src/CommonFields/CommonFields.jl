abstract type RotationPlane end
struct XYRotationPlane <: RotationPlane end
struct XZRotationPlane <: RotationPlane end
struct YZRotationPlane <: RotationPlane end

include("FFL.jl")
include("FFP.jl")
include("Homogeneous.jl")