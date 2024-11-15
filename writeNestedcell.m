function writeNestedcell(nested_cell,filename,sheetname,startRow,startCol)
Gap=2;
for i=1:length(nested_cell)
    startCell = sprintf('%s%d', startCol, startRow);
    if ~isempty(nested_cell{i})
        writecell(nested_cell{i}, filename, 'Sheet', sheetname, 'Range', startCell);
    end
    startRow = startRow + height(nested_cell{i}) + Gap; % 更新下一次写入的起始行（考虑到数据长度和行间隔）
end
end