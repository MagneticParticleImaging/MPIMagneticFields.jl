@testset "Type" begin
  mutable struct TestField <: AbstractMagneticField end

  testField = TestField()

  @test_throws ErrorException("Not yet implemented") value(testField, [0, 0, 0])
  @test_throws ErrorException("Not yet implemented") value(testField, [0, 0, 0], 0.0)
  @test_throws ErrorException("Not yet implemented") value(testField, [0, 0, 0], [0.0, 0.0, 0.0])
  @test_throws ErrorException("Not yet implemented") value(testField, [0, 0, 0], 0.0, [0.0, 0.0, 0.0])
end