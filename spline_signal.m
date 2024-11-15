function flu_fit = spline_signal(s)
    flu_fit=nan(size(s));
    for n=1:height(s)
        validIdx = ~isnan(s(n,:));
        fluWidth = 1:width(s);
        xValid = fluWidth(validIdx);
        fluValid = s(n,validIdx);
        flu_fit(n,:) = spline(xValid, fluValid, fluWidth);
    end
end