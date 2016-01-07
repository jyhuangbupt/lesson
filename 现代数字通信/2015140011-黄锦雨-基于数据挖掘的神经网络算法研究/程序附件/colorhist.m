function colorhist = colorhist(rgb) 
% CBIR_colorhist() --- color histogram calculation 
% input:   MxNx3 image data, in RGB 
% output:  1x256 colorhistogram == (HxSxV = 16x4x4) 
% as the MPEG-7 generic color histogram descriptor 
% [Ref] Manjunath, B.S.; Ohm, J.-R.; Vasudevan, V.V.; Yamada, A., "Color and texture descriptors"  
% IEEE Trans. CSVT, Volume: 11 Issue: 6 , Page(s): 703 -715, June 2001 (section III.B) 
 % check input 
if size(rgb,3)~=3 
    error('3 components is needed for histogram'); 
end 
% globals 
H_BITS = 4; S_BITS = 2; V_BITS = 2; 
%rgb2hsv可用rgb2hsi代替，见你以前的提问。
hsv = uint8(255*rgb2hsv(rgb)); 

imgsize = size(hsv); 
% get rid of irrelevant boundaries 
i0=round(0.05*imgsize(1));  i1=round(0.95*imgsize(1)); 
j0=round(0.05*imgsize(2));  j1=round(0.95*imgsize(2)); 
hsv = hsv(i0:i1, j0:j1, :); 
 
% histogram 
for i = 1 : 2^H_BITS 
    for j = 1 : 2^S_BITS 
        for k = 1 : 2^V_BITS 
            colorhist(i,j,k) = sum(sum( ... 
                bitshift(hsv(:,:,1),-(8-H_BITS))==i-1 &... 
                bitshift(hsv(:,:,2),-(8-S_BITS))==j-1 &... 
                bitshift(hsv(:,:,3),-(8-V_BITS))==k-1 ));             
        end         
    end 
end 
colorhist = reshape(colorhist, 1, 2^(H_BITS+S_BITS+V_BITS)); 
% normalize 
colorhist = colorhist/sum(colorhist);

%基于纹理特征提取灰度共生矩阵用于纹理判断
% Calculates cooccurrence matrix 
% for a given direction and distance
%
% out = cooccurrence (input, dir, dist, symmetric);
%
% INPUT:
% input: input matrix of any size
%
% dir: direction of evaluation
%       "dir" value                    Angle
%              0                            0
%              1                           -45
%              2                           -90
%              3                           -135
%              4                           -180
%              5                           +135
%              6                           +90
%              7                           +45
%
% dist: distance between pixels
%
% symmetric:  1 for symmetric version
%                   0 for non-symmetric version
%
% eg: out = cooccurrence (input, 0, 1, 1);
% Author: Baran Aydogan (15.07.2006)
% RGI, Tampere University of Technology
% baran.aydogan@tut.fi

