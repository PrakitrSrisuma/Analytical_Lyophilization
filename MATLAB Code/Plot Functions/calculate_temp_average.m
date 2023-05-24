% ==============================================================================
% This is a function calculating the average temperature using trapz.
%
% Created by Prakitr Srisuma, 
% PhD, Braatz Group (ChemE) & 3D Optical Systems Group (MechE), MIT.
% ==============================================================================

function outputs = calculate_temp_average(Temp,input)

T_avg = zeros(height(Temp),1);
for i = 1:height(Temp)
    T_avg(i,1) = trapz(input.x,Temp(i,:))/input.L;
end

outputs = T_avg;

return