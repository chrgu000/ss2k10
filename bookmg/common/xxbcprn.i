
procedure printbc:
    define input parameter iType as character.  /* bc|bk  ((bookcard|book)   */
    define input parameter iIDnbr  like pt_part.
    define input parameter iName   as character.
    define input parameter iNbr    as character.
    define input parameter IQty    as character.

    define var wsection as char . /*for barcode print*/
    define var ts9030   as char . /*for barcode print*/
    define var av9030   as char . /*for barcode print*/
    define variable labelspath as character format "x(100)" init "/app/bc/labels/".
    find first code_mstr where code_fldname = "barcode" and code_value ="labelspath" no-lock no-error.
    if available(code_mstr) then labelspath = trim ( code_cmmt ).
    if substring(labelspath, length(labelspath), 1) <> "/" then labelspath = labelspath + "/".

    wsection    = "lap03" + trim ( string(year(today)) + string(month(today),'99') + string(day(today),'99'))  + trim(string(time)) + trim(string(random(1,100))) .

    input from value(labelspath + "lap03" ).
    output to value(trim(wsection) + ".l") .
       repeat:
          import unformatted ts9030.

          /*���������������*/
          if index(ts9030, "$B") <> 0 then do:
             av9030 = trim(iIDnbr).
             ts9030 = substring(ts9030, 1, index(ts9030 , "$B") - 1) + av9030
                    + substring( ts9030 , index(ts9030 ,"$B")
                    + length("$B"), length(ts9030) - ( index(ts9030 , "$B") + length("$B") - 1 )).
          end.
          /*ͼ������*/
          if index(ts9030, "ͼ��:") <> 0 then do:
            if iType = "BK" then do:
               av9030 = trim("���:").
            end.
            else do:
               av9030 = "".
            end.
            ts9030 = substring(ts9030, 1, index(ts9030 , "ͼ��:") - 1) + av9030
                   + substring( ts9030 , index(ts9030 ,"ͼ��:")
                   + length("ͼ��:"), length(ts9030) - ( index(ts9030 , "ͼ��:") + length("ͼ��:") - 1 )).
          end.
          /*ͼ��*/
          if index(ts9030, "$P") <> 0 then do:
             if iType = "BK" then do:
                av9030 = trim(iIDnbr).
             end.
             else do:
                 av9030 = "".
             end.
             ts9030 = substring(ts9030, 1, index(ts9030 , "$P") - 1) + av9030
                    + substring( ts9030 , index(ts9030 ,"$P")
                    + length("$P"), length(ts9030) - ( index(ts9030 , "$P") + length("$P") - 1 )).
          end.
          /*��������*/
          if index(ts9030, "����:") <> 0 then do:
            if iType = "BK" then do:
               av9030 = trim("����:").
            end.
            else do:
               av9030 = "".
            end.
            ts9030 = substring(ts9030, 1, index(ts9030 , "����:") - 1) + av9030
                   + substring( ts9030 , index(ts9030 ,"����:")
                   + length("����:"), length(ts9030) - ( index(ts9030 , "����:") + length("����:") - 1 )).
          end.

          /*����*/
          if index(ts9030, "$F") <> 0 then do:
             if iType = "BK" then do:
                av9030 = trim(iName).
             end.
             else do:
                 av9030 = "".
             end.
             ts9030 = substring(ts9030, 1, index(ts9030 , "$F") - 1) + av9030
                    + substring( ts9030 , index(ts9030 ,"$F")
                    + length("$F"), length(ts9030) - ( index(ts9030 , "$F") + length("$F") - 1 )).
          end.

          /*��������*/
          if index(ts9030, "����:") <> 0 then do:
            if iType = "BK" then do:
               av9030 = trim("˵��:").
            end.
            else do:
               av9030 = "".
            end.
            ts9030 = substring(ts9030, 1, index(ts9030 , "����:") - 1) + av9030
                   + substring( ts9030 , index(ts9030 ,"����:")
                   + length("����:"), length(ts9030) - ( index(ts9030 , "����:") + length("����:") - 1 )).
          end.

           /*����*/
          if index(ts9030, "$O") <> 0 then do:
             if iType = "BK" then do:
                av9030 = trim(iNbr).
             end.
             else do:
                 av9030 = "".
             end.
             ts9030 = substring(ts9030, 1, index(ts9030 , "$O") - 1) + av9030
                    + substring( ts9030 , index(ts9030 ,"$O")
                    + length("$O"), length(ts9030) - ( index(ts9030 , "$O") + length("$O") - 1 )).
          end.

          /*��������*/
          if index(ts9030, "����:") <> 0 then do:
            if iType = "BK" then do:
               av9030 = trim("���:").
            end.
            else do:
               av9030 = "".
            end.
            ts9030 = substring(ts9030, 1, index(ts9030 , "����:") - 1) + av9030
                   + substring( ts9030 , index(ts9030 ,"����:")
                   + length("����:"), length(ts9030) - ( index(ts9030 , "����:") + length("����:") - 1 )).
          end.
         /*����*/
          if index(ts9030, "$F") <> 0 then do:
             if iType = "BK" then do:
                av9030 = trim(iQty).
             end.
             else do:
                 av9030 = "".
             end.
             ts9030 = substring(ts9030, 1, index(ts9030 , "$Q") - 1) + av9030
                    + substring( ts9030 , index(ts9030 ,"$Q")
                    + length("$Q"), length(ts9030) - ( index(ts9030 , "$Q") + length("$Q") - 1 )).
          end.
          /*��λ����*/
          if index(ts9030, "��λ:") <> 0 then do:
            av9030 = "".
            ts9030 = substring(ts9030, 1, index(ts9030 , "��λ:") - 1) + av9030
                   + substring( ts9030 , index(ts9030 ,"��λ:")
                   + length("��λ:"), length(ts9030) - ( index(ts9030 , "��λ:") + length("��λ:") - 1 )).
          end.
          /*��λ*/
          if index(ts9030, "$C") <> 0 then do:
            av9030 = "".
            ts9030 = substring(ts9030, 1, index(ts9030 , "$C") - 1) + av9030
                   + substring( ts9030 , index(ts9030 ,"$C")
                   + length("$C"), length(ts9030) - ( index(ts9030 , "$C") + length("$C") - 1 )).
          end.
          /*��������*/
          if index(ts9030, "����:") <> 0 then do:
            av9030 = "".
            ts9030 = substring(ts9030, 1, index(ts9030 , "����:") - 1) + av9030
                   + substring( ts9030 , index(ts9030 ,"����:")
                   + length("����:"), length(ts9030) - ( index(ts9030 , "����:") + length("����:") - 1 )).
          end.
          /*����*/
          if index(ts9030, "$L") <> 0 then do:
            av9030 = "".
            ts9030 = substring(ts9030, 1, index(ts9030 , "$L") - 1) + av9030
                   + substring( ts9030 , index(ts9030 ,"$L")
                   + length("$L"), length(ts9030) - ( index(ts9030 , "$L") + length("$L") - 1 )).
          end.
          /*��λ����*/
          if index(ts9030, "��λ:") <> 0 then do:
            av9030 = "".
            ts9030 = substring(ts9030, 1, index(ts9030 , "��λ:") - 1) + av9030
                   + substring( ts9030 , index(ts9030 ,"��λ:")
                   + length("��λ:"), length(ts9030) - ( index(ts9030 , "��λ:") + length("��λ:") - 1 )).
          end.
          /*��λ*/
          if index(ts9030, "$U") <> 0 then do:
            av9030 = "".
            ts9030 = substring(ts9030, 1, index(ts9030 , "$U") - 1) + av9030
                   + substring( ts9030 , index(ts9030 ,"$U")
                   + length("$U"), length(ts9030) - ( index(ts9030 , "$U") + length("$U") - 1 )).
          end.
          /*�������*/
          if index(ts9030, "���:") <> 0 then do:
            av9030 = "".
            ts9030 = substring(ts9030, 1, index(ts9030 , "���:") - 1) + av9030
                   + substring( ts9030 , index(ts9030 ,"���:")
                   + length("���:"), length(ts9030) - ( index(ts9030 , "���:") + length("���:") - 1 )).
          end.
          /*���*/
          if index(ts9030, "$E") <> 0 then do:
            av9030 = "".
            ts9030 = substring(ts9030, 1, index(ts9030 , "$E") - 1) + av9030
                   + substring( ts9030 , index(ts9030 ,"$E")
                   + length("$E"), length(ts9030) - ( index(ts9030 , "$E") + length("$E") - 1 )).
          end.
          /*��������*/
          if index(ts9030, "����:") <> 0 then do:
            av9030 = "".
            ts9030 = substring(ts9030, 1, index(ts9030 , "����:") - 1) + av9030
                   + substring( ts9030 , index(ts9030 ,"����:")
                   + length("����:"), length(ts9030) - ( index(ts9030 , "����:") + length("����:") - 1 )).
          end.
          /*����*/
          if index(ts9030, "$D") <> 0 then do:
            av9030 = "".
            ts9030 = substring(ts9030, 1, index(ts9030 , "$D") - 1) + av9030
                   + substring( ts9030 , index(ts9030 ,"$D")
                   + length("$D"), length(ts9030) - ( index(ts9030 , "$D") + length("$D") - 1 )).
          end.
          /*$R*/
          if index(ts9030, "$R") <> 0 then do:
            av9030 = "".
            ts9030 = substring(ts9030, 1, index(ts9030 , "$R") - 1) + av9030
                   + substring( ts9030 , index(ts9030 ,"$R")
                   + length("$R"), length(ts9030) - ( index(ts9030 , "$R") + length("$R") - 1 )).
          end.
          put unformatted ts9030 skip.
       end.

    input close.
    output close.

    unix silent value ("chmod 777  " + trim(wsection) + ".l").

    find first prd_det where prd_dev = trim(dev) no-lock no-error.
    if available prd_det then do:
        unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
        unix silent value ("rm " + trim(wsection) + ".l").
    end.
end. /*procedure*/

