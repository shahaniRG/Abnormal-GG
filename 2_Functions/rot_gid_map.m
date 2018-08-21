function [gid_map] = rot_gid_map(gid_map,dg)
%rot_gid_map rotates gid_map (all sections) to the specified degrees
    for i = 1:size_gm2(3)
        b = imrotate(gid_map(:,:,i),dg);
        w = size(b,1);
        l = size(b,2);
        if mod(w,2) == 0
            gid_map(:,:,i) = b(((w/2) - 214):((w/2) + 214),...
                ((l/2) - 214):((l/2) + 214));
        else
            w = w - 1;
            l = w;
            gid_map(:,:,i) = b(((w/2) - 214):((w/2) + 214),...
                ((l/2) - 214):((l/2) + 214));
        end
    end

end

