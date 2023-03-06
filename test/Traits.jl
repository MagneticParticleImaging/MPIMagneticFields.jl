@testset "Traits" begin
  mutable struct TestField <: AbstractMagneticField end

  testField = TestField()

  @test_throws "Not yet implemented" fieldType(testField)
  @test_throws "Not yet implemented" definitionType(testField)
  @test_throws "Not yet implemented" timeDependencyType(testField)
  @test_throws "Not yet implemented" gradientFieldType(testField)

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