put
    unformatted
    "ExcelFile" at 1
    sDelimiter
    {1}
    "SaveFile" at 1
    sDelimiter
    string(today, "99999999")
        + replace(string(time, "HH:MM:SS"), ":", "")
        + {2}
    "BeginRow" at 1
    sDelimiter
    {3}
    .


