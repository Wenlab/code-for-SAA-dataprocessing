function signal_status=segment_movement_status(signal,status,currency)
% signal is either fl signal or head curvature
% status is either u.fwd, u.bkw, u.turn
% currency is the array of u.IR_FL_curr
for w=1:length(signal)
    for n=1:height(signal{w})
        for i=1:height(status{w})
            seg=ceil(status{w}(i,:)/currency(w));
            seg(2)=min(length(signal{w}(n,:)),seg(2));
            signal_status{w}{n,i}=signal{w}(n,seg(1):seg(2));
        end
    end
end