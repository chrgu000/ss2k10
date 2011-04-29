/* xscanrun001.i procedure defined to load and check menu Security         */
/* REVISION: 1.0         Last Modified: 2008/11/29   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/


/*
1.�ļ��� = ͨ�ô����ֶ���+menu  (ȫСд)
2.�ļ��и�ʽ: "ָ��#��ʽ��#ָ��˵��#Ȩ���嵥"
3.�ļ�����ɹ���¼�ļ�: ͨ�ô����ֶ���+menuok.txt 

*/




procedure loadmenu:
    define var v_fullname  as char format "x(30)" .
    define var text-string as char format "x(255)".
if search(v_fldname + "menu") <> ? then do:
    assign v_fullname = search(v_fldname + "menu") .
end.
else do:
    message "�ļ�������:" (v_fldname + "menu")  view-as alert-box title ""  .
    undo,retry .
end.

input from value(v_fullname).
output to value(v_fullname + "ok.txt") append .
    put "/*----------------Shopfloor Menu Security Load Record ---------------------*/" skip .
    put "��ʼʱ��:" string(string(year(today),"9999") + "/" + string(month(today),"99") + "/" + string(day(today),"99") + " " + string(time,"HH:MM") ) format "x(50)" skip .
    
    repeat :
        /*text-string��ʽ: ָ��#��ʽ��#ָ��˵��#Ȩ���嵥 */
        import unformatted text-string.
        text-string = text-string + "####" .
        if entry(2,text-string,"#") <> "" then do:

            find first xusrw_wkfl where xusrw_key1 = v_fldname and xusrw_key2 = trim(entry(2,text-string,"#")) no-error.
            if not available(xusrw_wkfl) then do:
                create xusrw_wkfl.
                assign xusrw_key1       = v_fldname
                       xusrw_key2       = trim(entry(2,text-string,"#")) 
                       xusrw_charfld[1] = "*".
            end.

            xusrw_charfld[1] = trim ( entry(4,text-string,"#") ).
            xusrw_charfld[2] = trim ( entry(3,text-string,"#") ).
            xusrw_charfld[3] = trim ( entry(1,text-string,"#") ).
            put "    ok    "  substring(text-string,1,length(text-string) - 4 ) format "x(255)" skip .
        end.
        else do:
            put "    **    "  substring(text-string,1,length(text-string) - 4 ) format "x(255)" skip .
        end.

    end.

    put "����ʱ��:" string(string(year(today),"9999") + "/" + string(month(today),"99") + "/" + string(day(today),"99") + " " + string(time,"HH:MM") )  format "x(50)" skip .
    put skip(3) .

input close.
output close .
    message "�������,��־�ļ�:" skip v_fullname + "ok.txt"   view-as alert-box title ""  .  /**/
end procedure.






procedure checksecurity:
    define input  parameter  v_filein   as character.
    define input  parameter  v_user     as character.
    define output parameter  v_fileout  as character.

    v_fileout = "" .
    find first xusrw_wkfl where xusrw_key1 = v_fldname and xusrw_key2 = v_filein no-lock no-error.
    if available(xusrw_wkfl) then do:
        if index ( xusrw_charfld[1] + "," , v_user + ","  ) <> 0 then  v_fileout = v_filein  .
        if index ( xusrw_charfld[1] , "*") <> 0                  then  v_fileout = v_filein  .
        find first xusrw_wkfl where xusrw_key1 = v_fldname and xusrw_key2 = v_filein no-lock no-error .
    end.
    else do:
        create xusrw_wkfl.
        assign  xusrw_key1 = v_fldname
                xusrw_key2 = v_filein
                xusrw_charfld[1] = "*"

                v_fileout = v_filein 
                .
    end.
end procedure.



/*


procedure runmfgproprogram.
   define input parameter  wmfgproprogram    as character.
   run xsmfgpro.p(input wmfgproprogram ,input "").
end procedure.


*/
