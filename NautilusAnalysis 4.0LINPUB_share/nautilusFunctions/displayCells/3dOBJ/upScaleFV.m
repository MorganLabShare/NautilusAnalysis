function[fv] = upScaleFV(fv,upScale)

fv.vertices = fv.vertices(:,[2 1 3]) * upScale;