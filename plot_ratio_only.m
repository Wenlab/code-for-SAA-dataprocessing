function plot_ratio_only(deltaR_R0, varargin)
figure
% various arguments in oder: curvature of head, fwd, bkw, turn
    N = size(deltaR_R0, 1);
    for i=1:N
        subplot(N,1,i);
        plot(deltaR_R0(i,:),'b','LineWidth',1.5);hold on;
        plot(zeros(length(deltaR_R0(i,:)),1),'b:','LineWidth',1.5);
        % determine how to plot: curvature, movement status
        if nargin==2 % curvature
            curv=varargin{1};
            yyaxis right
            plot(curv,'k--');
            plot(zeros(length(curv),1),'k:','LineWidth',1.5);
        elseif nargin==4 % movement status
            fwd=varargin{1};
            bkw=varargin{2};
            turn=varargin{3};
            shadow_movement_status(fwd,bkw,turn);
        elseif nargin==5 % cuvr & movement status
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