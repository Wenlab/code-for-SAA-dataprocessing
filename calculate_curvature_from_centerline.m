function curvdata = calculate_curvature_from_centerline(cv2i)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
body_points=cellfun(@size,cv2i,'UniformOutput',false);
max_body_points=max(cellfun(@max,body_points));
curvdata=nan(length(cv2i),max_body_points-2); % diff twice below, so need to minus 2.
for i=1:length(cv2i)
    if ~isempty(cv2i{i})
        df2 = diff(cv2i{i},1,1);
        atdf2 =  unwrap(atan2(-df2(:,2), df2(:,1)));
        curv = unwrap(diff(atdf2,1));
        curvdata(i,:) = curv';
    end
end
end