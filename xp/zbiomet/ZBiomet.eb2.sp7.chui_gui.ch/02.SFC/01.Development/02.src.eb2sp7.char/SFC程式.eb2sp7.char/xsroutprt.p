/* xsroutprt.p - FG location print                                      */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* REVISION: 1.20          Created: 11/17/2008    BY: xie yu lin        */


{xsmf002var01.i }  /*all SFC shared vars: v_wolot v_op v_user ...*/
/*因BIOMET要求与QADDB分开,所以程式代码不得使用任何标准*.i和table !*/

define input parameter psn as char format "x(12)" no-undo.
define input parameter lot like xwo_lot no-undo.
define input parameter lop as integer format ">>9" label "工序" no-undo.
define input parameter wkctr like xwc_wkctr no-undo.
define input parameter pdesc like xwc_desc no-undo.
define input parameter l_prt  as char format "x(12)" no-undo.

define variable wkdesc  like xwc_desc no-undo.
define variable dt     as date no-undo.


define variable wsection as char format "x(16)".
define variable ts9130 AS CHARACTER FORMAT "x(100)".
define variable av9130 AS CHARACTER FORMAT "x(100)".

dt = today.
find first xemp_mstr where xemp_addr = psn no-lock no-error.
psn = if available xemp_mstr then xemp_lname else psn .

find first xwc_mstr where xwc_wkctr = wkctr no-lock no-error .
wkdesc = if avail xwc_mstr then entry(max(1,num-entries(xwc_desc, "/")),xwc_desc,"/") else wkctr .

mainloop:
repeat:
    run prt_lbl.
    leave.
end.



/***

FORM 
   lot    colon 10  label "工单标志"
   lop    colon 10  label "工序"     
   pdesc  colon 10  label "工序说明" 
   wkctr  colon 10  label "加工中心" 
   wkdesc colon 10  label "说明"
   psn    colon 10  label "负责人"   
   dt     colon 10  label "加入日期" 
   l_prt  colon 10  label "打印机"
   skip(1)
with frame a 
title color normal "打印工序条码"
attr-space side-labels width 80.

mainloop:
repeat:

    view frame a.
    do transaction with frame a on endkey undo, leave mainloop:
       update lot lop pdesc wkctr wkdesc psn dt l_prt with frame a editing:
                if frame-field = "l_prt" then do:
                    readkey.
                    {xsmfnp11.i xprd_det xprd_dev  xprd_dev "input l_prt and xprd_type = 'barcode' "  }
                    if recno <> ? then do:
                        display xprd_dev @ l_prt  with frame a .
                    end. 
                end.   
                else do:
                    status input.
                    readkey.
                    apply lastkey.                
                end. 
        end. 
        
        run prt_lbl.
    end.


end. 
hide all no-pause .

***/






Procedure prt_lbl:
      
      /*INPUT FROM VALUE("/mfgeb2/bc_test/labels/addop.txt").*/
      define variable labelspath as character format "x(100)" .
      find first xcode_mstr where xcode_fldname = "barcode" and xcode_value ="labelspath" no-lock no-error.
      if available(xcode_mstr) then labelspath = trim ( xcode_cmmt ).
      if substring(labelspath, length(labelspath), 1) <> "/" then labelspath = labelspath + "/".
      INPUT FROM VALUE(labelspath + "addop.txt").

      wsection = string(MONTH(TODAY)) + string(DAY(TODAY))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) . 

      output to value( trim(wsection) + "l.l") .

      repeat:
         IMPORT UNFORMATTED ts9130.

         if INDEX(ts9130, "$lot") <> 0 THEN DO:
            av9130 = lot.
            TS9130 = substring(TS9130, 1, Index(TS9130 , "$lot") - 1) + av9130 
                   + SUBSTRING( ts9130 , index(ts9130 ,"$lot") 
                   + length("$lot"), LENGTH(ts9130) - ( index(ts9130 , "$lot") + length("$lot") - 1 ) ).
         END.

         if INDEX(ts9130, "$op") <> 0 THEN DO:
            av9130 = string(lop).
            TS9130 = substring(TS9130, 1, Index(TS9130 , "$op") - 1) + av9130 
                   + SUBSTRING( ts9130 , index(ts9130 ,"$op") 
                   + length("$op"), LENGTH(ts9130) - ( index(ts9130 , "$op") + length("$op") - 1 ) ).
         END.

         if INDEX(ts9130, "$psn") <> 0 THEN DO:
            av9130 = psn.
            TS9130 = substring(TS9130, 1, Index(TS9130 , "$psn") - 1) + av9130 
                   + SUBSTRING( ts9130 , index(ts9130 ,"$psn") 
                   + length("$psn"), LENGTH(ts9130) - ( index(ts9130 , "$psn") + length("$psn") - 1 ) ).
         END.

         if INDEX(ts9130, "$wkctr") <> 0 THEN DO:
            av9130 = wkctr.
            TS9130 = substring(TS9130, 1, Index(TS9130 , "$wkctr") - 1) + av9130 
                   + SUBSTRING( ts9130 , index(ts9130 ,"$wkctr") 
                   + length("$wkctr"), LENGTH(ts9130) - ( index(ts9130 , "$wkctr") + length("$wkctr") - 1 ) ).
         END.

         if INDEX(ts9130, "$desc1") <> 0 THEN DO:
            av9130 = wkdesc.
            TS9130 = substring(TS9130, 1, Index(TS9130 , "$desc1") - 1) + av9130 
                   + SUBSTRING( ts9130 , index(ts9130 ,"$desc1") 
                   + length("$desc1"), LENGTH(ts9130) - ( index(ts9130 , "$desc1") + length("$desc1") - 1 ) ).
         END.

         if INDEX(ts9130, "$BC") <> 0 THEN DO:
            av9130 = lot + "+" + string(lop).
            TS9130 = substring(TS9130, 1, Index(TS9130 , "$BC") - 1) + av9130 
                   + SUBSTRING( ts9130 , index(ts9130 ,"$BC") 
                   + length("$BC"), LENGTH(ts9130) - ( index(ts9130 , "$BC") + length("$BC") - 1 ) ).
         END.

         if INDEX(ts9130, "$dt") <> 0 THEN DO:
            av9130 = string(dt).
            TS9130 = substring(TS9130, 1, Index(TS9130 , "$dt") - 1) + av9130 
                   + SUBSTRING( ts9130 , index(ts9130 ,"$dt") 
                   + length("$dt"), LENGTH(ts9130) - ( index(ts9130 , "$dt") + length("$dt") - 1 ) ).
         END.

         if INDEX(ts9130, "$pdesc1") <> 0 THEN DO:
            av9130 = pdesc.
            TS9130 = substring(TS9130, 1, Index(TS9130 , "$pdesc1") - 1) + av9130 
                   + SUBSTRING( ts9130 , index(ts9130 ,"$pdesc") 
                   + length("$pdesc"), LENGTH(ts9130) - ( index(ts9130 , "$pdesc") + length("$pdesc") - 1 ) ).
         END.

         put unformatted ts9130 skip.
      end.

      INPUT CLOSE.
      OUTPUT CLOSE.

      output to value("prt1.prn") .
          unix silent value ("chmod 777  " + trim(wsection) + "l.l").

          find first xprd_det where xprd_dev = trim(l_prt) no-lock no-error.
          IF AVAILABLE xprd_det then do:
             unix silent value (trim(xprd_path) + trim(wsection) + "l.l").
          end.

          unix silent value ( "rm -f  "  + trim(wsection) + "l.l" ).
      OUTPUT CLOSE.
end. /*Procedure*/
