function [XCF,XCF_bounds]=crosscorr_curv_r(curv,r,range_of_Lags)
% range_of_Lags: 'default' or 'full range'
% default use the default range of function crosscorr
% full range use the full range of curve or r.
for w=1:length(r) % num of worms
    for n=1:height(r{w}) % num of neurons
        for i=1:width(r{w}) % num of trials
            switch range_of_Lags
                case 'full range'
                     [xcf,lags]=crosscorr(curv{w}{1,i},r{w}{n,i},...
                         NumLags=length(r{w}{1,i})-1);
                case 'default'
                     [xcf,lags]=crosscorr(curv{w}{1,i},r{w}{n,i});
                otherwise
                    [xcf,lags]=crosscorr(curv{w}{1,i},r{w}{n,i},...
                         NumLags=range_of_Lags);
            end
            XCF{w}{n,i}=[xcf;lags];
            [XCF_bounds{w}{n,i}(1,1),I]=max(xcf);
            XCF_bounds{w}{n,i}(1,2)=lags(I);
            [XCF_bounds{w}{n,i}(1,3),I]=min(xcf);
            XCF_bounds{w}{n,i}(1,4)=lags(I);
            XCF_bounds{w}{n,i}(1,5)=xcf((length(xcf)+1)/2);
            XCF_bounds{w}{n,i}(1,6)=lags((length(lags)+1)/2);
        end
    end
end