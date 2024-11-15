function plot_fluorescence_trace_and_ratio(fluG, fluR, deltaR_R0, varargin)
figure
% various arguments in oder: curvature of head, fwd, bkw, turn
    N = size(deltaR_R0, 1);
    % odd column for red vs. green fluorescence 
    for i=1:N
        subplot(N,2,2*i-1);
        plot(fluR(i,:),'r','LineWidth',1.5);hold on;
        plot(fluG(i,:),'g','LineWidth',1.5);
        % determine how to plot: curvature, movement status
        if nargin==4 % curvature
            curv=varargin{1};
            yyaxis right
            plot(curv,'k--','LineWidth',1.5);
            plot(zeros(length(curv),1),'k:','LineWidth',1.5);
        elseif nargin==6 % movement status
            fwd=varargin{1};
            bkw=varargin{2};
            turn=varargin{3};
            shadow_movement_status(fwd,bkw,turn);
        elseif nargin==7 % cuvr & movement status
            curv=varargin{1};
            fwd=varargin{2};
            bkw=varargin{3};
            turn=varargin{4};
            yyaxis right
            plot(curv,'k--','LineWidth',1.5);
            plot(zeros(length(curv),1),'k:','LineWidth',1.5);
            yyaxis left
            shadow_movement_status(fwd,bkw,turn);
        end
        title(['neuron ' num2str(i)]);
    end

    for i=1:N
        subplot(N,2,2*i);
        plot(deltaR_R0(i,:),'b','LineWidth',1.5);hold on;
        plot(zeros(length(deltaR_R0(i,:)),1),'b:','LineWidth',1.5);
        % determine how to plot: curvature, movement status
        if nargin==4 % curvature
            curv=varargin{1};
            yyaxis right
            plot(curv,'k--');
            plot(zeros(length(curv),1),'k:','LineWidth',1.5);
        elseif nargin==6 % movement status
            fwd=varargin{1};
            bkw=varargin{2};
            turn=varargin{3};
            shadow_movement_status(fwd,bkw,turn);
        elseif nargin==7 % cuvr & movement status
            curv=varargin{1};
            fwd=varargin{2};
            bkw=varargin{3};
            turn=varargin{4};
            yyaxis right
            plot(curv,'k--','LineWidth',1.5);
            plot(zeros(length(curv),1),'k:','LineWidth',1.5);
            yyaxis left
            shadow_movement_status(fwd,bkw,turn);
        end
        title(['neuron ' num2str(i)]);
    end
end