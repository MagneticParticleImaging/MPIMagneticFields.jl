@testset "Traits" begin
  @testset "Not implemented" begin
    mutable struct TestField <: AbstractMagneticField end

    testField = TestField()

    @test_throws ErrorException("Not yet implemented") fieldType(testField)
    @test_throws ErrorException("Not yet implemented") definitionType(testField)
    @test_throws ErrorException("Not yet implemented") timeDependencyType(testField)
    @test_throws ErrorException("Not yet implemented") gradientFieldType(testField)
  end

  @testset "Implemented rotational" begin
    mutable struct TestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.fieldType(::TestFieldImplemented) = GradientField()
    MPIMagneticFields.definitionType(::TestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.timeDependencyType(::TestFieldImplemented) = TimeVarying()
    MPIMagneticFields.gradientFieldType(::TestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.fieldMovementType(::TestFieldImplemented) = RotationalMovement()

    testField = TestFieldImplemented()

    @test isTimeVarying(testField) == true
    @test isRotatable(testField) == true
    @test isTranslatable(testField) == false
  end

  @testset "Implemented translational" begin
    mutable struct TestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.fieldType(::TestFieldImplemented) = GradientField()
    MPIMagneticFields.definitionType(::TestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.timeDependencyType(::TestFieldImplemented) = TimeVarying()
    MPIMagneticFields.gradientFieldType(::TestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.fieldMovementType(::TestFieldImplemented) = TranslationalMovement()

    testField = TestFieldImplemented()

    @test isTimeVarying(testField) == true
    @test isRotatable(testField) == false
    @test isTranslatable(testField) == true
  end

  @testset "Implemented translational" begin
    mutable struct TestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.fieldType(::TestFieldImplemented) = GradientField()
    MPIMagneticFields.definitionType(::TestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.timeDependencyType(::TestFieldImplemented) = TimeVarying()
    MPIMagneticFields.gradientFieldType(::TestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.fieldMovementType(::TestFieldImplemented) = (RotationalMovement(), TranslationalMovement())

    testField = TestFieldImplemented()

    @test isTimeVarying(testField) == true
    @test isRotatable(testField) == true
    @test isTranslatable(testField) == true
  end
end