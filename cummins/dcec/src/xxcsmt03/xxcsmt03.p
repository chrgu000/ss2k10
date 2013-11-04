/* REVISION: eB21SP5       BY: Jordan lin  ECO：*SS -  20120214.1          */
/* REVISION: eB21SP5       BY: Jordan lin  ECO：*SS -  20120330.1          */
/* REVISION: eB21SP5       BY: Jordan lin  ECO：*SS -  20120405.1          */
/* REVISION: eB21SP5       BY: Apple Tam  ECO：*SS -  20120413.1          */
/* REVISION: eB21SP5       BY: Jordan lin  ECO：*SS -  20120416.1          */
/* REVISION: eB21SP5       BY: Jordan lin  ECO：*SS -  20120420.1          */
/* REVISION: eB21SP5       BY: Jordan lin  ECO：*SS -  20120427.1          */
/* REVISION: eB21SP5       BY: Jordan lin  ECO：*SS -  20120502.1          */
/* REVISION: eB21SP5       BY: Jordan lin  ECO：*SS -  20120507.1          */

/* DISPLAY TITLE */
{mfdtitle.i "120507.1"}

define variable domain as char  LABEL "旧办".
define variable entity like en_entity .
define variable BaseCurr  like gl_base_curr .
define variable Type as char  LABEL "ユ摸" initial "JL".
define variable Ref like gltr_ref .
define variable Acc like Ac_code .
define variable Acc1 like Ac_code .
define variable Sub like sb_sub .
define variable Sub1 like sb_sub .
define variable CC like cc_ctr .
define variable CC1 like cc_ctr .
define variable Effdate like gltr_eff_dt .
define variable Effdate1 like gltr_eff_dt .
define variable Confirm as logical initial yes LABEL "絋粄旧".
define variable ReExport as logical initial no LABEL "穝旧".
define variable file as char format "x(55)" LABEL "旧郎".
define variable doc as char format "x(30)" LABEL "Output DOC".
define variable dir as char format "x(30)" LABEL "Output DOC".
define TEMP-TABLE temp_table
   FIELD temp_recno as RECID
   FIELD temp_domain like global_domain
   FIELD temp_tr_type like gltr_tr_type
   FIELD temp_eff_dt like gltr_eff_dt
   FIELD temp_ref like gltr_ref
   FIELD temp_line like  gltr_line
   FIELD temp_entity like gltr_entity
   FIELD temp_acc like gltr_acc
   FIELD temp_sub like gltr_sub
   FIELD temp_ctr like gltr_ctr
   FIELD temp_desc like gltr_desc
   FIELD temp_curr like gltr_curr
   FIELD temp_curramt like gltr_curramt
   FIELD temp_basecurr like gl_base_curr
   FIELD temp_amt AS decimal FORMAT ">>,>>>,>>>,>>9.99"
   FIELD temp_doc as char format "x(20)" label "Output DOC"
   INDEX  temp_index is PRIMARY
          temp_domain ASCENDING
    temp_ref ASCENDING
    temp_line ASCENDING.

/* *SS -  20120330.1  */ define variable Export_Database as char format "x(1)" initial " " LABEL "Export Database".
/* *SS -  20120330.1  */ define variable temp_ref2 like gltr_ref.
/* *SS -  20120502.1  */ define variable subGL like gltr_ref.

{xxcsmt0a.i}

/* SELECT FORM */
form
/* *SS -  20120330.1  domain         colon 20 skip  */
   entity      colon 20
   BaseCurr      colon 55 skip
   Type      colon 20
   Ref      colon 55 skip
   Acc      colon 20
   Acc1      colon 55 skip
   Sub      colon 20
   Sub1      colon 55 skip
   CC      colon 20
   CC1      colon 55 skip
   Effdate      colon 20
   Effdate1      colon 55 skip
/* *SS -  20120330.1  */  Export_Database         colon 20 skip
   Confirm  colon 35 skip
   ReExport colon 35 skip
/* SS -  20120405.1      file colon 20 skip        */
/* SS -  20120405.1  */    doc  colon 20
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

view frame a.

find FIRST  gl_ctrl  where  gl_ctrl.gl_domain = global_domain no-lock no-error .



/* *SS -  20120330.1 -B */

   find FIRST  code_mstr  where  code_mstr.code_domain = global_domain
                       and Code_fldname = "PLCSPROJECT"
           and Code_value  = "Export_Database"
   no-lock no-error .
   if available code_mstr then do :
      Export_Database = substring(code_cmmt,1,1).
   end.



/* *SS -  20120330.1 -E */

assign
/*   domain = global_domain */
   Effdate = today
   Effdate1 = today
   BaseCurr = gl_base_curr
   entity = gl_entity .
/* *SS -  20120330.1   display  Effdate Effdate1 BaseCurr entity with frame a .  */
/* *SS -  20120330.1  */  display Export_Database  Effdate Effdate1 BaseCurr entity with frame a .

repeat with frame a:

   if Ref = hi_char
   then
      Ref = "".
   if Acc = hi_char
   then
      Acc = "".
   if Acc1 = hi_char
   then
      Acc1 = "".
   if Sub = hi_char
   then
      Sub = "".
   if Sub1 = hi_char
   then
      Sub1 = "".
   if CC = hi_char
   then
      CC = "".
   if CC1 = hi_char
   then
      CC1 = "".

   update entity Type Ref
          Acc Acc1
    Sub Sub1
    CC CC1
    Effdate Effdate1
    Confirm ReExport .

   if Acc1 = ""
   then
      Acc1 = hi_char.
   if Sub1 = ""
   then
      Sub1 = hi_char.
   if CC1 = ""
   then
      CC1 = hi_char.

/*检查会计单位,生效日期不为空*/
   if entity = "" then do :
      {pxmsg.i &MSGNUM=3061 &ERRORLEVEL=3}
      NEXT-PROMPT entity .
      undo ,NEXT .
   end.
   if (Effdate1 - Effdate < 0 ) then do :
      {pxmsg.i &MSGNUM=2930 &ERRORLEVEL=3}
      NEXT-PROMPT Effdate .
      undo ,NEXT .
   end .

  do TRANSACTION on error undo,LEAVE :
/*指定导出文件*/
 /* 目录*/
      find FIRST  code_mstr  where  code_mstr.code_domain = global_domain
                                   and Code_fldname = "PLCSPROJECT"
           and Code_value  = "Export_directory"
       no-lock no-error.
       if available code_mstr then do :
          FILE-INFO:FILE-NAME = code_cmmt.
          if SeekCH(FILE-INFO:FILE-TYPE,"D") and  SeekCH(FILE-INFO:FILE-TYPE,"W") then do:
            dir =  code_cmmt .
     end.
     else do :
       message "Error Export directory not exists!".
             undo , retry.
           end. /* if FILE-INFO:FILE-TYPE begins("F") */
           end .
       else do :
          message "Error Export directory not null! ".
          undo , retry.
       end. /* if available code_mstr then do : */

/*流水号*/
      find FIRST  code_mstr  where  code_mstr.code_domain = global_domain
                                   and Code_fldname = "PLCSPROJECT"
           and Code_value  = "Export_Sequence"
       no-error.
       if available code_mstr then do :
           assign code_cmmt = string(INTEGER(code_cmmt) + 1 , "999") .
           doc = dbname + string(today,"99999999") + string(time,"999999") + code_cmmt .
     file = dir + doc.
       end .
       else do :
          message "Error Export file sequence not null! ".
          undo , retry.
       end.

/* SS -  20120405.1  -B  */
   update doc .
   file = trim(dir) + trim(doc).
/* SS -  20120405.1  -E  */

   EMPTY TEMP-TABLE temp_table .
   if not Confirm then doc = "" .
/*查询数据*/
   for each gltr_hist USE-INDEX gltr_eff_dt where gltr_hist.gltr_domain = global_domain
          and gltr_eff_dt >= Effdate
          and gltr_eff_dt <= Effdate1
          and gltr_entity = entity
          and gltr_acc >= acc
          and gltr_acc <= acc1
          and gltr_sub >= sub
          and gltr_sub <= sub1
          and gltr_ctr >= cc
          and gltr_ctr <= cc1
          and ( Type = "" or gltr_tr_type = Type )
          and ( ref = "" or gltr_ref = ref )
          and ( ReExport = yes or gltr_user1 = "" ) no-lock,
       each ac_mstr where ac_mstr.ac_domain = global_domain
        and Ac_code = gltr_acc
        and TRIM(ac_user1) = "*"  no-lock
       break by gltr_tr_type
             by gltr_acc
       by gltr_eff_dt:
     CREATE  temp_table.
              temp_recno = recid(gltr_hist).
              temp_ref = gltr_ref.
              temp_domain = global_domain.
              temp_tr_type = gltr_tr_type.
        temp_eff_dt = gltr_eff_dt.
        temp_ref = gltr_ref.
        temp_line = gltr_line.
        temp_entity = gltr_entity .
        temp_acc = gltr_acc .
        temp_sub = gltr_sub.
        temp_ctr = gltr_ctr .
        temp_desc = gltr_desc .
        temp_curr = gltr_curr .
        temp_curramt = gltr_curramt .
        temp_amt = gltr_amt .

   end. /*for each gltr_hist */


   OUTPUT TO value(file) .
   for each temp_table use-index temp_index :

/* *SS -  20120330.1 -b */
/*
      if BaseCurr = "RMB" then
      temp_ref = substring(temp_ref,1,8) + "C" + substring(temp_ref,10,5).
      if BaseCurr = "HKD" then
      temp_ref = substring(temp_ref,1,8) + "H" + substring(temp_ref,10,5).
*/
/* *SS -  20120330.1 -E */
/*SS -  20120416.1  -B */
/*
/* *SS -  20120330.1 -B */
      temp_ref2 = substring(temp_ref,1,8) + Export_Database + substring(temp_ref,10,5).
/* *SS -  20120330.1 -E */
*/
/*SS -  20120416.1  -E */
/*SS -  20120416.1  -B */
      if LENGTH(temp_ref, "CHARACTER") >= 14 then do:
         temp_ref2 = substring(temp_ref,1,8) + Export_Database + substring(temp_ref,10,5).
      end.
      else do:
         temp_ref2 = temp_ref + Export_Database.
      end.
/*SS -  20120420.1   -B   */

      temp_desc = REPLACE(temp_desc,'"','#').

/*SS -  20120420.1   -E     */

/*SS -  20120416.1  -E */

/*SS -  20120502.1  -B  */
     subGL = substring(temp_ref,1,2).
     if subGL <> "jl" and  LENGTH(temp_ref, "CHARACTER") = 14 then do:
        find FIRST  code_mstr  where  code_mstr.code_domain = global_domain
                                   and Code_fldname = "PLCSPROJECT"
           and Code_value  = subGL
       no-lock no-error.
       if not available code_mstr then do :
          message "Error " + subGL + " not null! ".
          undo , retry.
       end.
       else do :
          temp_ref2 = "jl" + substring(temp_ref2,4,11) + trim(code_cmmt).
       end.

     end.

/*SS -  20120502.1  -E  */
/*SS -  20120507.1   -B   */

/*SS -  20120507.1   -b    */
     temp_desc = substring(temp_desc,1,21) .
/* *SS -  20120413.1 -e   */
/*
     EXPORT DELIMITER " "
     */
/* *SS -  20120413.1 -E */
/* *SS -  20120413.1 -B */
     EXPORT DELIMITER "~t"
/* *SS -  20120413.1 -E */
           temp_domain format "x(8)" label "Domain"
           temp_tr_type format "x(2)" label "Trans Type"
     temp_eff_dt label "Effective Date"
/* *SS -  20120330.1       temp_ref format "x(14)" label "GL Ref No" */
/* *SS -  20120330.1 */    temp_ref2 format "x(14)" label "GL Ref No"
     temp_line format "9999" label "GL Line"
     temp_entity format "x(4)" label "Entity"
     temp_acc format "x(8)" label "Account"
     temp_sub format "x(8)" label "Sub Account"
     temp_ctr format "x(8)" label "Cost Center"
     temp_desc format "x(14)" label "Description"
     temp_curr format "x(4)" label "Currency"
     temp_curramt format "->>,>>>,>>>,>>9.99" label "Currency Amt"
     BaseCurr format "x(4)" label "Base Currency"
     temp_amt format "->>,>>>,>>>,>>9.99" label "Base Currency Amt"
     doc format "x(20)" label "Output DOC" .
 /*更新gltr_user1*/
       if Confirm then do :
          find gltr_hist where recid(gltr_hist) = temp_table.temp_recno no-error.
    update gltr_user1 = doc .
       end.


   end. /*for each temp_table*/


   OUTPUT CLOSE.
 end . /*do on error undo,LEAVE*/

/*SS -  20120405.1            display file with frame a. */
end. /*repeat with frame a:*/





