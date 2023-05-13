@testset "Traits" begin
  @testset "Not implemented" begin
    mutable struct TestField <: AbstractMagneticField end

    testField = TestField()

    @test FieldStyle(testField) isa OtherField
    @test FieldDefinitionStyle(testField) isa MethodBasedFieldDefinition
    @test FieldTimeDependencyStyle(testField) isa TimeConstant
    @test isnothing(GradientFieldStyle(testField))
  end

  @testset "Implemented rotational" begin
    mutable struct TestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TestFieldImplemented) = GradientField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldImplemented) = TimeVarying()
    MPIMagneticFields.GradientFieldStyle(::TestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.FieldMovementStyle(::TestFieldImplemented) = RotationalMovement()

    testField = TestFieldImplemented()

    @test isTimeVarying(testField) == true
    @test isRotatable(testField) == true
    @test isTranslatable(testField) == false
  end

  @testset "Implemented translational" begin
    mutable struct TestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TestFieldImplemented) = GradientField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldImplemented) = TimeVarying()
    MPIMagneticFields.GradientFieldStyle(::TestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.FieldMovementStyle(::TestFieldImplemented) = TranslationalMovement()

    testField = TestFieldImplemented()

    @test isTimeVarying(testField) == true
    @test isRotatable(testField) == false
    @test isTranslatable(testField) == true
  end

  @testset "Implemented translational" begin
    mutable struct TestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TestFieldImplemented) = GradientField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldImplemented) = TimeVarying()
    MPIMagneticFields.GradientFieldStyle(::TestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.FieldMovementStyle(::TestFieldImplemented) = RotationalTranslationalMovement()

    testField = TestFieldImplemented()

    @test isTimeVarying(testField) == true
    @test isRotatable(testField) == true
    @test isTranslatable(testField) == true
  end
end