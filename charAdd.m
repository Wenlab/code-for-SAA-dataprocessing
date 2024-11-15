function result = charAdd(baseChar, num)
    % 将基础字符转换为数字（'A' = 1, 'B' = 2, ..., 'Z' = 26）
    baseNum = double(baseChar) - 'A' + 1;
    % 计算总数，包括从基础字符开始的偏移量
    totalNum = baseNum + num;
    
    % 初始化结果字符串
    result = '';
    % 当总数大于0时进行处理
    while totalNum > 0
        % 减1是为了使'A'成为循环的起点（'A'到'Z'，然后是'AA', 'AB', ...）
        rem = mod(totalNum-1, 26);
        % 获得当前字符并将其加到结果字符串的前面
        result = [char('A' + rem), result];
        % 更新totalNum以进行下一轮循环
        totalNum = floor((totalNum - rem) / 26);
    end
end

