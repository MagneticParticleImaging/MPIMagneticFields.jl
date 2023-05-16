using MPIMagneticFields
using PyPlot

field = IdealXYFFL(5.0)

for angle in 0:pi/10:2pi
  imshow([sign(val[1]) == sign(val[2]) ? sign(val[1]) + sign(val[2]) > 0 : sign(val[1]) - sign(val[2]) > 0 for val in value(field, [-0.02:0.001:0.02, -0.02:0.001:0.02, 0], angle)])
  sleep(1)
end