function prop = init_rocket()

    prop = readtable('rocket_prop_comp.txt','Format','%s%f');
%     motorname=char(table2array(prop(end,1)));
%     motordata = rocketmotor(motorname);

end

