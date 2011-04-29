if {1} = ? then do:
    message "不允许非法字符(?),请重新输入" {2} .
    undo,retry .
end.