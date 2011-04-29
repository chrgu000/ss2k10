/* xxkbrp001.p  看板使用明细报表                                                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                               */
/* All rights reserved worldwide.  This is an unpublished work.                      */
/*V8:ConvertMode=NoConvert                                                           */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao   /*xp001*/ */
/*-Revision end------------------------------------------------------------          */



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */
define var site  like xmpt_site .
define var v_buyer like pt_buyer  label "计划员".
define var v_buyer1 like pt_buyer .
define var v_buyer2 like pt_buyer .
define var part  like xmpt_part .
define var part1 like xmpt_part .
define var desc1 like pt_desc1.
define var desc2 like pt_desc2 .
define var v_type    like xkb_type label "看板类型".
/* define var v_type1   like xkb_type. */
define var v_yn        as logical .
define var i as integer .
define var j as integer .

define buffer xkbmstr for xkb_mstr .

define temp-table temp 
    field t_item  as char format "x(4)"
    field t_type  like xkb_type 
    field t_buyer like pt_buyer
    field t_part  like xkb_part 
    field t_desc1 like pt_desc1
    field t_desc2 like pt_desc2
    field t_num   as char format "x(4)"
    field t_kb    as char extent 202 .





find icc_ctrl where icc_domain = global_domain no-lock no-error.
site = if avail icc_ctrl then icc_site else global_site .
disp site with frame a .   

define  frame a.

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)

    site                     colon 18   
    v_buyer                  colon 18   label "计划员"
    v_buyer1                 colon 54   label {t001.i}
    part                     colon 18
    part1                    colon 54   label  {t001.i} 
    v_type                   colon 18   label  "看板类型"
     /*v_type1                  colon 54   label  {t001.i} */
    skip (2)
   
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    if part1 = part       then part1 = "".
     /*if v_type1 = v_type   then v_type1 = "". */
    if v_buyer1 = v_buyer   then v_buyer1 = "".


    if c-application-mode <> 'web' then  
        update site v_buyer v_buyer1 part part1 v_type  with frame a.

	{wbrp06.i &command = update &fields = " site  v_buyer v_buyer1  part part1 v_type "  &frm = "a"}
    if (c-application-mode <> 'web') or (c-application-mode = 'web' and (c-web-request begins 'data')) then do:

        find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = site) no-lock no-error .
        if not avail xkbc_ctrl then do:
            find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = "" ) no-lock no-error .
            if not avail xkbc_ctrl then do:
                /* {pxmsg.i &MSGNUM=???? &ERRORLEVEL=3} */
                message "看板模块没有开启" view-as alert-box .
                leave .
            end.
        end.

        if v_type = "L" then do:
                message "状态报表限制: 非领料看板类型(L)." view-as alert-box .
                /*领料看板全是A状态,  且可能超过报表宽度 ,    但是也可以改 temp-table temp 的宽度即可  */
                leave .
        end.
           
    

        bcdparm = "".
        {mfquoter.i site       }
        {mfquoter.i v_buyer    }
        {mfquoter.i v_buyer1   }
        {mfquoter.i part       }
        {mfquoter.i part1      }
        {mfquoter.i v_type     }


        if part1 = "" then part1 = part.
        /* if v_type1 = "" then v_type1 = v_type. */
        if v_buyer1 = "" then v_buyer1 = v_buyer.

	end.  /* if c-application-mode <> 'web' */

    /* PRINTER SELECTION */
    /* OUTPUT DESTINATION SELECTION */
    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = " "
                &stream = " "
                &appendToFile = " "
                &streamedOutputToTerminal = " "
                &withBatchOption = "yes"
                &displayStatementType = 1
                &withCancelMessage = "yes"
                &pageBottomMargin = 6
                &withEmail = "yes"
                &withWinprint = "yes"
                &defineVariables = "yes"}
mainloop: 
do on error undo, return error on endkey undo, return error:                    



for each temp :
    delete temp .
end.

PUT UNFORMATTED "#def REPORTPATH=$/Minth/xxkbrp001" SKIP.
PUT UNFORMATTED "#def :end" SKIP.


j = 0 .
for each xkb_mstr where xkb_domain = global_domain 
    and xkb_site = site 
    and  (xkb_type = v_type or v_type = "" ) 
    and  xkb_type <> "L" 
    and  xkb_part >= part and (xkb_part <= part1 or part1 = "" )
    and ( xkb_kb_id <> 0  and xkb_kb_id <> 999 ) 
    no-lock break by xkb_type by xkb_part by xkb_kb_id   :

    v_buyer2 = "" .
    find first ptp_det  where ptp_domain = global_domain and ptp_site = xkb_site and ptp_part = xkb_part no-lock no-error .
    if avail ptp_det then do:
        if ptp_buyer <> ""  then v_buyer2 = ptp_buyer .
        else do:
            find first pt_mstr  where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
            if avail pt_mstr then do:
                if pt_buyer <> "" then assign v_buyer2 = pt_buyer .
            end.
        end.
    end.
        else do:
            find first pt_mstr  where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
            if avail pt_mstr then do:
                if pt_buyer <> "" then assign v_buyer2 = pt_buyer .
            end.
        end.

    if not ( v_buyer2 >= v_buyer and ( v_buyer2 <= v_buyer1 or v_buyer1 = "" )) then next .
    

    if first-of (xkb_part) then do:
        assign i = 0 .   
    end.
    i =  i + 1 .

    if last-of(xkb_part) then do:
          j = max(j,i).
    end.

/* {mfrpexit.i} */
end. /*  for each xkb_mstr*/

/* /* export delimiter ";" */                                                         */
/* put  '"项次";"看板类型";"计划员";"料号";"说明1";"说明2";"发行张数";"尾板";"状态"'. */
/* do i = 1 to j  :                                                                   */
/*         put  ';"' string(i,"999") format "x(3)"  '";"状态"' .                      */
/* end.                                                                               */
/* do i = j + 1 to 101 :                                                              */
/*     put ';"";""' .                                                                 */
/* end.                                                                               */
/* put skip .                                                                         */

create temp.
assign  t_item = "项次"
        t_type = "类型"
        t_part = "零件号" 
        t_buyer = "计划员"
        t_desc1 = "说明1" 
        t_desc2 = "说明2"
        t_num   = "发行张数"
        t_kb[1] = "尾板"
        t_kb[2] = "状态" .
do i = 1 to j :
    t_kb[2 * i + 1 ] = string(i,"999") .
    t_kb[2 * i + 2 ] = "状态" .
end.





j = 0 .
for each xkb_mstr where xkb_domain = global_domain 
    and xkb_site = site 
    and  (xkb_type = v_type or v_type = "" )
    and  xkb_type <> "L"
    and  xkb_part >= part and (xkb_part <= part1 or part1 = "" )
    no-lock break by xkb_type by xkb_part by xkb_kb_id  :

    v_buyer2 = "" .
    find first ptp_det  where ptp_domain = global_domain and ptp_site = xkb_site and ptp_part = xkb_part no-lock no-error .
    if avail ptp_det then do:
        if ptp_buyer <> ""  then v_buyer2 = ptp_buyer .
        else do:
            find first pt_mstr  where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
            if avail pt_mstr then do:
                if pt_buyer <> "" then assign v_buyer2 = pt_buyer .
            end.
        end.
    end.
        else do:
            find first pt_mstr  where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
            if avail pt_mstr then do:
                if pt_buyer <> "" then assign v_buyer2 = pt_buyer .
            end.
        end.

    if not ( v_buyer2 >= v_buyer and ( v_buyer2 <= v_buyer1 or v_buyer1 = "" )) then next .
    

    if first-of (xkb_part) then do:
        assign i = 0 .   
    end.
    i =  i + 1 .

    if last-of(xkb_part) then do:
                find pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
                desc1 = if avail pt_mstr then pt_desc1   else "".
                desc2 = if avail pt_mstr then pt_desc2   else "".
                
                create temp .
                j = j + 1 .
                assign t_item = string(j) 
                       t_type = xkb_type 
                       t_part = xkb_part 
                       t_buyer = v_buyer2
                       t_desc1 = desc1 
                       t_desc2 = desc2
                       t_num = string(i) .
                
                for each xkbmstr where xkbmstr.xkb_domain = global_domain 
                                 and xkbmstr.xkb_type = xkb_mstr.xkb_type 
                                 and xkbmstr.xkb_part = xkb_mstr.xkb_part 
                                 /*and ( xkb_kb_id <> 0  and xkb_kb_id <> 999 ) */
                                 no-lock break by xkb_kb_id  :
                    if ( xkb_kb_id = 0 or xkb_kb_id = 999 ) then do:
                        assign  t_kb[ 1 ] = if (xkb_upt_date) <> ? then  string(xkb_upt_date) else  string(xkb_crt_date)  
                                t_kb[ 2 ] = xkb_status .
                    end.
                    else do :
                        assign  t_kb[2 * (xkb_kb_id - 1 ) + 3 ] = if (xkb_upt_date) <> ? then  string(xkb_upt_date) else string(xkb_crt_date) 
                                t_kb[2 * (xkb_kb_id - 1 ) + 4 ] = xkb_status .
                    end.
                    
                    
                end.
    end.

/* {mfrpexit.i} */
end. /*  for each xkb_mstr*/


for each temp  :
    export delimiter ";" temp .
end.


for each temp :
    delete temp .
end.
      

    end. /* mainloop: */
    /* {mfrtrail.i}  REPORT TRAILER  */
    {mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
