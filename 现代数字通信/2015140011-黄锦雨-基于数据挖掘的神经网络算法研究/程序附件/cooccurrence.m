function out = cooccurrence (input, dir, dist, symmetric)

input = round(input);
[r c] = size(input);

min_intensity = min(min(input));
max_intensity = max(max(input));

out = zeros(max_intensity-min_intensity+1);
if (dir == 0)
    dir_x = 0;    dir_y = 1;
end

if (dir == 1)
    dir_x = 1;    dir_y = 1;
end

if (dir == 2)
    dir_x = 1;    dir_y = 0;
end

if (dir == 3)
    dir_x = 1;    dir_y = -1;
end

if (dir == 4)
    dir_x = 0;    dir_y = -1;
end

if (dir == 5)
    dir_x = -1;    dir_y = -1;
end

if (dir == 6)
    dir_x = -1;    dir_y = 0;
end

if (dir == 7)
    dir_x = -1;    dir_y = 1;
end

dir_x = dir_x*dist;
dir_y = dir_y*dist;

out_ind_x = 0;
out_ind_y = 0;

for intensity1 = min_intensity:max_intensity
    out_ind_x = out_ind_x + 1;
    out_ind_y = 0;
    
    [ind_x1 ind_y1] = find (input == intensity1);
    ind_x1 = ind_x1 + dir_x;
    ind_y1 = ind_y1 + dir_y;
    
    for intensity2 = min_intensity:max_intensity    
        out_ind_y = out_ind_y + 1;        
    
        [ind_x2 ind_y2] = find (input == intensity2);
        
        count = 0;
        
        for i = 1:size(ind_x1,1)            
            for j = 1:size(ind_x2,1)                
                if ( (ind_x1(i) == ind_x2(j)) && (ind_y1(i) == ind_y2(j)) )
                    count = count + 1;
                end                
            end                
        end
        
        out(out_ind_x, out_ind_y) = count;
            
    end
end

if (symmetric)
    
    if (dir < 4)
        dir = dir + 4;
    else
        dir = mod(dir,4);
    end       
    out = out + cooccurrence (input, dir, dist, 0);    
end