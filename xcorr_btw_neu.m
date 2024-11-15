function xce=xcorr_btw_neu(dr_r0,neu1,neu2)
xce=[];
for w=1:length(dr_r0)
    for i=1:width(dr_r0{w})
        if ~isempty(dr_r0{w})
            r1=dr_r0{w}{neu1(w),i};
            r2=dr_r0{w}{neu2(w),i};
            xce(end+1)=xcorr(r1,r2,0,'normalized');
        end
    end
end