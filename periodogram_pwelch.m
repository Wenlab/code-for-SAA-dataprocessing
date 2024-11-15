function [psdx, freq] = periodogram_pwelch(x, fs)
    % 使用pwelch方法计算功率谱密度
    % 输入：
    % x - 信号样本
    % fs - 采样频率
    % 输出：
    % psdx - 功率谱密度估计
    % freq - 对应的频率向量

    % 使用pwelch计算PSD
    % 默认情况下，pwelch使用信号长度的一半作为窗口长度，50%的重叠，并使用默认的汉宁窗
    % 这里，'onesided'选项告诉pwelch返回单边谱
    [psdx, freq] = pwelch(x, [], [], [], fs, 'onesided');
    
    % 将功率谱密度转换为更加通用的形式
    % 对于除了直流分量以外的所有频率成分，功率需要乘以2
    % 注意：pwelch已经为我们做了这一步，所以这里不需要手动调整

    % 返回结果
end
