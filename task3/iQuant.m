function x = iQuant(q, L)
%IQUANT Calculates the output of the dequantizer for the given indexes and
%quantization levels.
%q The symbols vectors. This is the output of the quantizer.
%L The quantization levels.

x = L(q);

end

