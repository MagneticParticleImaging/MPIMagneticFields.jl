using MPIMagneticFields
using PyPlot
using LinearAlgebra

gradient = IdealFFP([1, 1, 2])
focusfield = IdealHomogeneousField([0.01, 0, 0])
superimposed = gradient + focusfield

figure(1)
imshow(norm.(gradient[-0.02:0.001:0.02, -0.02:0.001:0.02, 0]))

figure(2)
imshow(norm.(superimposed[-0.02:0.001:0.02, -0.02:0.001:0.02, 0]))