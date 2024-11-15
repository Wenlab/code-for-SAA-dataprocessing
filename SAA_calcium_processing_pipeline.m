%% File location, image size, if MIP

u.filename="C:\SAA\w4_stk1\annotations.h5";
u.x_pixels=512;
u.y_pixels=512;
u.z_range=5;
% Choose whether to perform on MIP or normal image stack. 

u.MIP_flag=true;

if u.MIP_flag
    u.z_range=1;
end
%% Configure image stack

% resize(binning) or not
% ISG=resize_image_stack(imgstk1_2_green,u.x_pixels);% green
% ISR=resize_image_stack(imgstk1_2_red,u.x_pixels);% red
% Flip the green stack

u.Flip_flag=true;

if u.Flip_flag
    ISG = Flipstacks(ISG);
end
% Maximum intensity projection

% do MIP or not
if u.MIP_flag
    ISG_MIP=MIP_image_stack(ISG);
    ISR_MIP=MIP_image_stack(ISR);
end
%% Bound neuron regions and then export
% run function 
% |whole_brain_imaging(ISG_MIP,posi,idx)|
% 
% in where |_image_stack is the normal image stack or MIP. 

neuron_boxes=load_neuron_posiNidx_to_neuron_box(neu_posi,neu_idx,neuron_boxes(1,:));
% check annotation
% run
% 
% |whole_brain_imaging(image_stack,neuron_boxes)|
% 
% |check bounding boxes|
%% Extract fluorescence value

% fullfill neuBox with neuron_boxes
u.thresR=120;
u.thresG=140;
nbG=XBoxes(neuron_boxes,ISG_MIP);
nbR=XBoxes(neuron_boxes,ISR_MIP);
nbR=nbR.assemble3DNeuron('threshold',u.thresR);%red stack
nbG=nbG.assemble3DNeuron('threshold',u.thresG);%green stack
fluG=nbG.flu_value.value;
fluR=nbR.flu_value.value;
% spline cubic to interpolant

fluG = interpolant_flu(fluG);
fluR = interpolant_flu(fluR);
% substract backgroud or not

% substract backgroud value or not
u.subsbkg_flag=true;

u.bkgG=110;
u.bkgR=108;
if u.subsbkg_flag
    fluG_sbkg=fluG-u.bkgG;
    fluR_sbkg=fluR-u.bkgR;
end
%% Calculate traces of deltaR/R0

r=fluG_sbkg./fluR_sbkg;
r0=mean(r,2) 
T = size(r,2);
dr_r0=(r-repmat(r0,[1,T]))./repmat(r0,[1,T]);
dr_r0_sm=zeros(size(dr_r0));
% choose a suitable span
smooth_span=10;
for i=1:height(dr_r0)
    dr_r0_sm(i,:)=smooth(dr_r0(i,:),smooth_span);
end
%% Derive curvature data
% first load centerline data of this image stack as 
% 
% |*cv2i*|

u.head_region=10:20 % determine where head region is
% Currency between IR fps and FL vps
% |IR_FL_curr=fps_of_IR/vps_of_FL;| 
% 
% for example we have IR vedio recorded in 25 fps, thus |fps_of_IR=25;|
% 
% Flurosence vedio was recorded in 25 fps with 10 frames per vol, thus |vps_of_IR=25/10=2.5;|
% 
% then we have IR_FL_curr=25/2.5=10.

u.IR_FL_curr=20;
%% 
% 

% drive curvature data
curv=calculate_curvature_from_centerline(cv2i_sewed);
% smooth curvature data
timefilter=5;
bodyfilter=10;
h = fspecial('average', [timefilter bodyfilter]);
curvfiltered = imfilter(curv*100,  h , 'replicate');
curv_ds=downsample(curvfiltered,u.IR_FL_curr);
% get curvature change of head
curv_head=mean(curv_ds(:,u.head_region),2); % determine where head region is
%% *Plot traces*
% |*fwd, bkw, turn| _from trimmed IR vedio (relative)*_
% 
% are variables that indicate time point of movement status. Each row is one 
% contineous movement, first row is start point, second row is end point. 
% plot

f_title=sprintf('%s,\n MIP_flag=%d, subsbkg=%d, bkgG=%d, bkgR=%d, thresG=%d, thresR=%d', ...
    u.filename,u.MIP_flag,u.subsbkg_flag,u.bkgG,u.bkgR,u.thresG,u.thresR);
% plot_fluorescence_trace_and_ratio(nbR, nbG, dr_r0_sm);
% plot_fluorescence_trace_and_ratio(nbR, nbG, dr_r0, curv_head);
% plot_fluorescence_trace_and_ratio(nbR, nbG, dr_r0_sm, fwd/IR_FL_curr, bkw/IR_FL_curr, pause/IR_FL_curr);
plot_fluorescence_trace_and_ratio(fluG, fluR, dr_r0_sm, ...
    curv_head, u.fwd/u.IR_FL_curr, u.bkw/u.IR_FL_curr, u.turn/u.IR_FL_curr);
sgtitle(regexprep(f_title,{'\', '_'}, {'\\\', '\\_'}),'FontSize',12);
%% Corrcoef and xcorr

% cross correlation
c.fwd=bounds_xcorr_trace_curv(dr_r0_sm, curv_head, fwd/IR_FL_curr);
c.bkw=bounds_xcorr_trace_curv(dr_r0_sm, curv_head, bkw/IR_FL_curr);
% correlation coefficients
% traceNcurv=[dr_r0_sm;curv_head'];
% cc=corrcoef(traceNcurv(:,ceil(bkw(1,1)/10):ceil(bkw(1,2)/10))');
%% Local functions

function image_stack_resized=resize_image_stack(image_stack,targetSize)
    ratio=targetSize/size(image_stack{1},1);
    for i=1:length(image_stack)
        for z=1:size(image_stack{i},3)
            image_stack_resized{i,1}(:,:,z)=imresize(image_stack{i}(:,:,z),ratio,'bicubic');
        end
    end
end

function c=bounds_xcorr_trace_curv(dr_r0_sm, curv_head, movement_point)
for i=1:height(movement_point)
    for j=1:height(dr_r0_sm)
        [c{i}(j,1),c{i}(j,2)]=bounds(...
            xcorr(...
            dr_r0_sm(j,ceil(movement_point(i,1)):ceil(movement_point(i,2))),...
            curv_head(ceil(movement_point(i,1)):ceil(movement_point(i,2))),'normalized'));
        
    end
end
end

function stacks = Flipstacks(stacks)

    T = length(stacks);
    
    for t = 1:T
        stack = stacks{t};
        stacks{t} = fliplr(stack);
    end

end

function flu_fit = interpolant_flu(flu)
    flu_fit=nan(size(flu));
    for n=1:height(flu)
        validIdx = ~isnan(flu(n,:));
        fluWidth = 1:width(flu);
        xValid = fluWidth(validIdx);
        fluValid = flu(n,validIdx);
        flu_fit(n,:) = spline(xValid, fluValid, fluWidth);
    end
end