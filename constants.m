classdef constants
    properties (Constant)
        BEAM = 14
        F_GETER = 8160e6
        FREQ = 1100e6
        c = physconst('LightSpeed');
        
        GAIN = -1;
        SHADES = 256;
        RESOL = 0.25;
        CUT_NEAR = 0;
        CUT_FAR = 0;
        
        DB_CUT_LEVEL_HI = 0; %  верхний предел контрастности (белый цвет)
        DB_CUT_LEVEL_LO = -20; %  нижний предел контрастности (черный цвет)
    end
end
