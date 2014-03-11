/* xxbcprn01.p 打印程序01---根据传入参数选择打印标签            */
/*
   使用@符号进行分割par1@par2@par3@par4@par5@par6@par7@.........
   par1是标签类型代码，决定调用的标签程序名,在xxbcprnall中使用

   在本程序中
   par2是打印机队列名
   par3   公司名
   par4   desc1
   par5   desc2
   par6   pt_part
   par7   lotserial
   par8   完工数
   par9   日期
   par10  生产者
   par11  H3 方位信息
   以上都是打印标签的变量字段，
   注意：在本程序中调用了额外的程序进行汉字处理
*/
{mfdeclre.i}
define input parameter thpar as char.
define var mypar as char extent 20.
define var myi as int.
    DEFINE TEMP-TABLE tt
      FIELD tt_c1 AS CHARACTER
    .
    DEFINE TEMP-TABLE tt1
      FIELD tt1_c1 AS CHARACTER
    .

myi = 1 .
do while myi < 12:
  mypar[myi] = entry(myi,thpar,"@").
  myi = myi + 1.
end.

run myprnlabel(
    input  mypar[2],
    input  mypar[3],
    input  mypar[4],
    input  mypar[5],
    input  mypar[6],
    input  mypar[7],
    input  mypar[8],
    input  mypar[9],
    input  mypar[10],
    input  mypar[11]
    ).



procedure myprnlabel:
   define input parameter myprint as char .
   define input parameter mypar1 as char .
   define input parameter mypar2 as char .
   define input parameter mypar3 as char .
   define input parameter mypar4 as char .
   define input parameter mypar5 as char .
   define input parameter mypar6 as char .
   define input parameter mypar7 as char .
   define input parameter mypar8 as char .
   define input parameter mypar9 as char .
   define var usection as char.
   define var LabelsPath as character format "x(100)" init "/app/bc/labels/".
   define var TmpPath as character format "x(100)" init "/app/bc/tmp/".
   define var tmps as char.
   define var tmps1 as char.
   define var tmps2 as char.
   define var tmps3 as char.
   Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then
        LabelsPath = LabelsPath + "/".
   Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="Temp"no-lock no-error.
        If AVAILABLE(code_mstr) Then TmpPath = trim ( code_cmmt ).
        If substring(TmpPath, length(TmpPath), 1) <> "/" Then
        TmpPath = TmpPath + "/".
  IF NOT (SEARCH(LabelsPath + "xxbcprn03.lbl") <> ?) THEN DO:
     /* 文件不存在 */
     message "模版文件不存在" view-as alert-box.
     RETURN.
  END.

  {gprun.i ""xxconvertbc.p"" " (input mypar1 , input ""001.GRF"",output  tmps1) "}
  {gprun.i ""xxconvertbc.p"" " (input mypar2 , input ""002.GRF"",output  tmps2) "}
  {gprun.i ""xxconvertbc.p"" " (input mypar3 , input ""003.GRF"",output  tmps3) "}

  /* TEMP */
  EMPTY TEMP-TABLE tt NO-ERROR.
  INPUT FROM VALUE(LabelsPath + "xxbcprn03.lbl").
  REPEAT:
     CREATE tt.
     IMPORT UNFORMATTED tt.
  END.
      /* print label */
      EMPTY TEMP-TABLE tt1 NO-ERROR.
      for each tt:
        create tt1 .
        tt1_c1 = tt_c1.
        if index(tt1_c1,"111111111111111111") > 0  then do:
          tt1_c1 = replace(tt1_c1,"111111111111111111",  mypar4  ).
          next.
        end.
        if index(tt1_c1,"222222222222222222") > 0  then do:
          tt1_c1 = replace(tt1_c1,"222222222222222222",  mypar5  ).
          next.
        end.
        if index(tt1_c1,"33333333") > 0  then do:
          tt1_c1 = replace(tt1_c1,"33333333",  mypar6  ).
          next.
        end.
        if index(tt1_c1,"44444444") > 0  then do:
            tt1_c1 = replace(tt1_c1,"44444444",  mypar7  ).
          next.
        end.
        if index(tt1_c1,"55555555") > 0  then do:
            tt1_c1 = replace(tt1_c1,"55555555",  mypar8  ).
          next.
        end.
        if index(tt1_c1,"66666666") > 0  then do:
            tt1_c1 = replace(tt1_c1,"66666666",  mypar9  ).
          next.
        end.
        if index(tt1_c1,"DG001DG001") > 0  then do:
          tt1_c1 = replace(tt1_c1,"DG001DG001",  tmps1).
          next.
        end.
        if index(tt1_c1,"DG002DG002") > 0  then do:
          tt1_c1 = replace(tt1_c1,"DG002DG002",  tmps2).
          next.
        end.
        if index(tt1_c1,"DG003DG003") > 0  then do:
          tt1_c1 = replace(tt1_c1,"DG003DG003",  tmps3).
          next.
        end.
      end.

      usection =  "Prn_bc01"  + mfguser + "_" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,10)))  .
      usection = TmpPath +  trim(usection) + ".prn".
      output to value(usection) .
      for each tt1 :
        put unformat tt1_c1 skip.
      end.
      output close.
      os-command silent value("lp -d" + trim(myprint) + " " + usection  + "  > /dev/null"  ) .
      /*pause 1 .
      os-command silent value("rm -f " + usection    ) .
      */
      pause 0 .
end procedure.