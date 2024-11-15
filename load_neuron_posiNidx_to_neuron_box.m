function neu_boxes = load_neuron_posiNidx_to_neuron_box(neu_posi,neu_idx,neu_box_template)
%LOAD_NEURON_POSINIDX_TO_NEURON_BOX Summary of this function goes here
%   neu_box_template is the one row of typical neuron_boxes, which contains
%   the bounding box of target neuron.
nb=XBoxes(neu_box_template);
nb.total_vol=height(neu_idx);
for slice=1:length(neu_box_template)
    bbox_1col=neu_box_template{slice};
    for b=1:length(bbox_1col)
        if ~isempty(bbox_1col(b).idx)
            xySize(bbox_1col(b).idx,:)=bbox_1col(b).Position(3:4);
        end
    end
end
num_make_empty=length(nb.boxes);
for h=1:height(neu_idx)
    for i=1:length(neu_idx{h})
        idx=neu_idx{h}(i);
        nb.boxes(end+1).idx=idx;
        nb.boxes(end).slice=neu_posi{h,1}(3,i);

        nb.boxes(end).Position=[neu_posi{h,1}(1,i)-xySize(idx,1)/2,...
                                neu_posi{h,1}(2,i)-xySize(idx,2)/2,...
                                xySize(idx,1),...
                                xySize(idx,2)];
        nb.boxes(end).vol=h;
        nb.boxes(end).isinlier=1;
        nb.boxes(end).identifier=0;
     end
end
nb.boxes(1:num_make_empty)=[];
neu_boxes=nb.Transform2WholeBrainImageReadable;
                                   
end

