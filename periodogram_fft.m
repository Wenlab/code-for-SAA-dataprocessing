function [psdx, freq] = periodogram_fft(x, fs)
x = ensureEvenLength(x);
N = length(x);
xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:fs/length(x):fs/2;
end

function evenArray = ensureEvenLength(array)
    lengthOfArray = length(array);     
    if mod(lengthOfArray, 2) == 1
       evenArray = array(1:end-1);
    else
        evenArray = array;
    end
end
