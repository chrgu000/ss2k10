/* mhjit055.p  调拨单打印                                                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                               */
/* All rights reserved worldwide.  This is an unpublished work.                      */
/*V8:ConvertMode=NoConvert                                                           */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao   /*xp001*/ */
/*-Revision end------------------------------------------------------------          */


{mfdtitle.i "2+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE repkrp01_p_1 "Production Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkrp01_p_2 "Picklist"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkrp01_p_3 "Print Allocated"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkrp01_p_4 " Issued"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkrp01_p_6 "Reprint Picked"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkrp01_p_7 "Sequence"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define shared variable global_recid as recid.
define variable linne   like op_wkctr label "转出库位".
define variable linne1  like linne  .
define var      loc like loc_loc  label "转入库位".
define var      loc1 like loc_loc. 
define variable nbrr  as character format "x(10)" .
define variable nbrr1 like nbrr.
define variable effdate as date  .
define variable effdate1 like effdate  .
define variable v_yn   like mfc_logical label "仅限未打印"  initial yes .
define variable desc1 like pt_desc1 format "x(48)" .
define variable desc2 like pt_desc1 .
define variable um like pt_um.
define variable qtyall like tr_qty_loc.

define variable print_more like mfc_logical.
define variable print-loop as integer label {&repkrp01_p_7}.
define variable issued as character format "x(20)" extent 4 initial "__________".
define variable assy_ord_max like pt_ord_max.
define variable ord_max like pt_ord_max.
define variable comp_max like lad_qty_all.
define variable tot_picked like lad_qty_all.
define variable ord_mult like pt_ord_mult.

define variable prodline like loc_loc .
define variable rcvno as character format "x(8)" .


/*ss-min001*/ define variable lines as integer format ">>9" label "项次".
/*ss-min001*/ define variable qty_oh like lad_qty_all label "车间库存量".
/*ss-min001*/ define variable page-start as integer .
/*ss-min001*/ page-start = 1.

 
/*ss-min001*/ define variable yield_pct  like pt_yield_pct .

/*ss-min001*/  define variable page_counter as integer  no-undo.
/*ss-min001*/  define variable co_name as character format "x(30)"  no-undo.

/*ss-min001*/  define variable companyname  as char format "x(28)".
/*ss-min001*/  define variable xdnname      like xdn_name.
/*ss-min001*/  define variable xdnisonbr    like xdn_isonbr.
/*ss-min001*/  define variable xdnisover    like xdn_isover.
/*ss-min001*/  define variable xdntrain1    like xdn_train1 .
/*ss-min001*/  define variable xdntrain2    like xdn_train2 .
/*ss-min001*/  define variable xdntrain3    like xdn_train3 .
/*ss-min001*/  define variable xdntrain4    like xdn_train4 .
/*ss-min001*/  define variable xdntrain5    like xdn_train5 .
/*ss-min001*/  define variable xdnpage1    like xdn_page1 .
/*ss-min001*/  define variable xdnpage2    like xdn_page2 .
/*ss-min001*/  define variable xdnpage3    like xdn_page3 .
/*ss-min001*/  define variable xdnpage4    like xdn_page4 .
/*ss-min001*/  define variable xdnpage5    like xdn_page5 .
/*ss-min001*/  define variable xdnpage6    like xdn_page6 .

effdate = today.
effdate1 = today.

form
   linne                              colon 20 column-label "转出库位"
   linne1      label {t001.i}         colon 49 skip
   loc                                colon 20 
   loc1        label {t001.i}         colon 49 skip
   nbrr        label "转移单号"       colon 20 
   nbrr1       label {t001.i}         colon 49 skip
   effdate     label "转移日期"       colon 20 
   effdate1    label {t001.i}          colon 49 skip
   v_yn                               colon 20 
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
{wbrp01.i}

mainloop:
repeat:

   if linne1  = linne then linne1  = "".
   if loc1  = loc    then loc1  = "".
   if nbrr1   = nbrr then nbrr1   = "".
/*    if effdate1 = effdate then effdate1 = ? . */
   if effdate1 = hi_date then effdate1 = ? .
   if effdate  = low_date then effdate = ? .
   global_recid = ?.

   if c-application-mode <> 'WEB' then update  linne linne1 loc loc1 nbrr nbrr1 effdate effdate1 v_yn with frame a .
   {wbrp06.i &command = update &fields = " linne linne1 loc loc1  nbrr nbrr1 effdate effdate1 v_yn  " &frm = "a" }

   if c-application-mode <> 'WEB' or
      (c-application-mode = 'WEB' and
      c-web-request begins 'DATA') then do:
      bcdparm = "".
      {mfquoter.i linne    }
      {mfquoter.i linne1   }
      {mfquoter.i loc     }
      {mfquoter.i loc1     }
      {mfquoter.i nbrr     }
      {mfquoter.i nbrr1    }
      {mfquoter.i effdate }
      {mfquoter.i effdate1 }
      {mfquoter.i v_yn  }


      if nbrr1  = "" then nbrr1  = nbrr .
      if loc1  = "" then loc1  = loc .
      if linne1 = "" then linne1 = linne .
      if effdate <> low_date and effdate1 = ? then effdate1 = effdate .
      if effdate = ? then effdate = low_date .
      if effdate1 = ? then effdate1 = hi_date.
      

   end.

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

   assign
      print_more   = yes
      page_counter = 0.
      lines = 1.

  find first ad_mstr no-lock  where ad_mstr.ad_domain = global_domain and  ad_addr = global_domain and ad_type = "company"  no-error.
  companyname = if available ad_mstr then  ad_name else  "敏实集团" .

  find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = "TR"  no-lock no-error.
  if available xdn_ctrl then do:
	   xdntrain1 = xdn_train1.
	   xdntrain2 = xdn_train2.
	   xdntrain3 = xdn_train3.
	   xdntrain4 = xdn_train4.
	   xdntrain5 = xdn_train5.
	   xdnpage1 = xdn_page1.
	   xdnpage2 = xdn_page2.
	   xdnpage3 = xdn_page3.
	   xdnpage4 = xdn_page4.
	   xdnpage5 = xdn_page5.
	   xdnpage6 = xdn_page6.
	   xdnname   = xdn_name.
	   xdnisonbr = xdn_isonbr.
	   xdnisover = xdn_isover.
	  
	end. 
	else do:
    	message "库存转移单格式没有设置, 请重新设置后再打印!!"  view-as alert-box.
    	undo, retry.
	end.

for first ls_mstr where ls_mstr.ls_domain = global_domain 
    and  ls_addr = "~~reports" and ls_type = "company" no-lock: end.

if available ls_mstr then
   for first ad_mstr  where ad_mstr.ad_domain = global_domain 
   and  ad_addr = ls_addr no-lock: end.

if available ad_mstr then
   co_name = fill(" ", max ((15 - integer ({gprawlen.i &strng=ad_name} / 2)), 1))
           + ad_name.

    form header          
        companyname        at 1    
        "表号:"            at 113 xdnisonbr  format "x(14)"  
        
        xdnname            at 50
        "版本/修订:"       at 113 xdnisover format "x(4)"                  
        getTermLabelRtColon("DATE",6) format "x(6)" to 117
        today               skip
    with frame phead2 page-top width 150 no-box no-attr-space.

{wbgp03.i}

if c-application-mode = 'WEB' and c-web-request = 'DATA' then do:
    form header         
        skip (1)
        companyname        at 1    
        "表号:"            at 113 xdnisonbr  format "x(14)"  
        
        xdnname            at 50
        "版本/修订:"       at 113 xdnisover format "x(4)"                  
        getTermLabelRtColon("DATE",6) format "x(6)" to 117
        today                  
        skip
    with frame pwebhead page-top no-label width 132 no-box.
    view {1} frame pwebhead.
end.
else view {1} frame phead2.

page_counter = page-number {2} - 1.
print-loop = 0.

for each tr_hist use-index tr_nbr_eff where tr_domain = global_domain and tr_type = "rct-tr" 
                 and (tr_effdate >= effdate or effdate = ?) and (tr_effdate <= effdate1 or effdate1 = ? )
                 and tr_nbr >= nbrr and ( tr_nbr <= nbrr1 or nbrr1 = "" ) and tr_nbr begins "TR"
                 and tr_addr >= linne and ( tr_addr <= linne1 or linne1 = "" ) and tr_addr > ""
                 and tr_loc >= loc and (tr_loc <= loc1 or loc1 = "" )
                 and ( tr__log02 = no or v_yn = no  ) 
                 no-lock break by tr_effdate by tr_nbr by tr_addr by tr_part
                 with frame b width 150 no-attr-space no-box down :
                setFrameLabels(frame b:handle).
                {mfrpchk.i}
    
    if first-of(tr_nbr) then do:
        lines = 0.        
        form     
            "转出库位: "    at 1          
            prodline  " "  
            desc2 
            "转移单号: "        
            rcvno   "   "
        with frame c page-top width 150 no-box no-label no-attr-space .  
        
        find wc_mstr no-lock  where wc_mstr.wc_domain = global_domain and wc_wkctr = tr_addr no-error.
        desc2 = if avail wc_mstr then wc_desc else "" .
        rcvno = tr_nbr .
        prodline = tr_addr .
        disp prodline desc2 rcvno with  frame c .

    end. /*if first-of(tr_nbr) */

    if first-of(tr_part) then do:
        find first pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock no-error .
        desc1 = if avail pt_mstr then pt_desc1 + pt_desc2 else  ""  .
        um = if avail pt_mstr then pt_um else "" .
        qtyall = 0 .
        qty_oh = 0 .
    end.
    qtyall = qtyall + tr_qty_loc .

    if last-of(tr_part) then do:

        lines = lines + 1 .
        disp lines tr_part desc1 
             um
             tr_loc label "转入库位"
             qtyall label "入库数量"
             "" @ issued[1]  label ""
             with frame b .
        put "----------------------------------------------------------------------------------------------------------------------" at 1 .

        if page-size - line-counter < 6 then do:
             do while page-size - line-counter > 5:         
                 put skip(1).                                
             end.                                           
             put "----------------------------------------------------------------------------------------------------------------------------" at 2.
             put skip(1).  
        
             if xdntrain1 <> "" and xdntrain2 <> "" and xdntrain3 <> "" and xdntrain4 <> "" and xdntrain5 <> "" then do: 
                 put xdntrain1    format "x(16)"   at  1.                                    
                 put xdntrain2    format "x(16)"                 at 20.   
                 put xdntrain3    format "x(16)"                 at 40.
                 put xdntrain4    format "x(16)"                 at 60.
                 put xdntrain5    format "x(16)"                 at 80.
             end.
             else  if xdntrain1 <> "" and xdntrain2 <> "" and xdntrain3 <> "" and xdntrain4 <> ""  then do:
                 put xdntrain1   format "x(16)"                 at  1.                                    
                 put xdntrain2   format "x(16)"                  at 25.   
                 put xdntrain3   format "x(16)"                  at 50.
                 put xdntrain4   format "x(16)"                  at 75.
             end.	       
             else if xdntrain1 <> "" and xdntrain2 <> "" and xdntrain3 <> ""   then do:
                 put xdntrain1   format "x(16)"                 at  1.                                    
                 put xdntrain2   format "x(16)"                  at 30.   
                 put xdntrain3   format "x(16)"                  at 60.
             end.	       
             else if xdntrain1 <> "" and xdntrain2 <> ""    then do:
                 put xdntrain1  format "x(16)"                  at  1.                                    
                 put xdntrain2  format "x(16)"                   at 40.   
             end.
             put skip(0).
        
             if xdnpage1 <>   "" and xdnpage2 <> "" and xdnpage3 <> "" 
             and xdnpage4 <> "" and xdnpage5 <> ""  and xdnpage6 <> "" then do: 
                 put "第一联:"          at 1  xdnpage1  format "x(8)"   .
                 put "第二联:"          at 15 xdnpage2  format "x(8)"   .
                 put "第三联:"         at  30 xdnpage3  format "x(8)"   .
                 put "第四联:"         at  45 xdnpage4  format "x(8)"   . 
                 put "第五联:"         at  60 xdnpage5  format "x(8)"   .
                 put "第六联:"         at  75 xdnpage6   format "x(8)" . 
             end.
             else if xdnpage1 <> "" and xdnpage2 <> "" and xdnpage3 <> "" 
             and xdnpage4 <> "" and xdnpage5 <> ""   then do: 
                 put "第一联:"   at 1  xdnpage1  format "x(12)" .
                 put "第二联:"   at 20 xdnpage2  format "x(12)" .
                 put "第三联:"   at 40 xdnpage3  format "x(12)" .
                 put "第四联:"   at 60 xdnpage4  format "x(12)" . 
                 put "第五联:"   at 80 xdnpage5  format "x(12)" . 
             end. 
             else if xdnpage1 <> "" and xdnpage2 <> "" and xdnpage3 <> "" 
             and xdnpage4 <> ""   then do: 
                 put "第一联:"        at 1  xdnpage1     format "x(14)".
                 put "第二联:"       at 25 xdnpage2     format "x(14)". 
                 put "第三联:"       at 50 xdnpage3     format "x(14)".
                 put "第四联:"       at 75 xdnpage4     format "x(14)". 
             end.				     
             else if xdnpage1 <> "" and xdnpage2 <> "" and xdnpage3 <> ""  then do: 
                 put "第一联:"           at 1  xdnpage1     format "x(18)".
                 put "第二联:"          at 30 xdnpage2     format "x(18)" .
                 put "第三联:"          at 60 xdnpage3     format "x(18)" .
             end.
             else if xdnpage1 <> "" and xdnpage2 <> ""  then do: 
                 put "第一联："   at 1    xdnpage1     format "x(18)" .
                 put "第二联："  at 40  xdnpage2     format "x(18)".
             end.
        
             put "打印日期:"   STRING(TODAY,"99/99/99") STRING(TIME,"hh:mm:ss")
                 "页码:" TO 116  string(page-start) format "xxxx" skip .  
             page-start = page-start + 1.
             page.
        
             disp prodline desc2 rcvno with  frame c .
        end.
    end.    /*if last-of(tr_part) */

    if last-of(tr_nbr) then do:
         /*disp "表尾 " . */
            do while page-size - line-counter > 6:                                                                                                              
		        put skip(1).                                                                                                                                     
		    end.                                                                                                                                                
		    put "----------------------------------------------------------------------------------------------------------------------------" at 2.
	        put skip(1).                                                             
            
            if xdntrain1 <> "" and xdntrain2 <> "" and xdntrain3 <> "" and xdntrain4 <> "" and xdntrain5 <> "" then do: 
                put xdntrain1    format "x(16)"   at  1.                                    
                put xdntrain2    format "x(16)"                 at 20.   
                put xdntrain3    format "x(16)"                 at 40.
                put xdntrain4    format "x(16)"                 at 60.
                put xdntrain5    format "x(16)"                 at 80.
            end.
            else  if xdntrain1 <> "" and xdntrain2 <> "" and xdntrain3 <> "" and xdntrain4 <> ""  then do:
                put xdntrain1   format "x(16)"                 at  1.                                    
                put xdntrain2   format "x(16)"                  at 25.   
                put xdntrain3   format "x(16)"                  at 50.
                put xdntrain4   format "x(16)"                  at 75.
            end.	       
            else if xdntrain1 <> "" and xdntrain2 <> "" and xdntrain3 <> ""   then do:
                put xdntrain1   format "x(16)"                 at  1.                                    
                put xdntrain2   format "x(16)"                  at 30.   
                put xdntrain3   format "x(16)"                  at 60.
            end.	       
            else if xdntrain1 <> "" and xdntrain2 <> ""    then do:
                put xdntrain1  format "x(16)"                  at  1.                                    
                put xdntrain2  format "x(16)"                   at 40.   
            end.
            put skip(0).

            if xdnpage1 <>   "" and xdnpage2 <> "" and xdnpage3 <> "" 
            and xdnpage4 <> "" and xdnpage5 <> ""  and xdnpage6 <> "" then do: 
                put "第一联:"          at 1  xdnpage1  format "x(8)"   .
                put "第二联:"          at 15 xdnpage2  format "x(8)"   .
                put "第三联:"         at  30 xdnpage3  format "x(8)"   .
                put "第四联:"         at  45 xdnpage4  format "x(8)"   . 
                put "第五联:"         at  60 xdnpage5  format "x(8)"   .
                put "第六联:"         at  75 xdnpage6   format "x(8)" . 
            end.
            else if xdnpage1 <> "" and xdnpage2 <> "" and xdnpage3 <> "" 
            and xdnpage4 <> "" and xdnpage5 <> ""   then do: 
                put "第一联:"   at 1  xdnpage1  format "x(12)" .
                put "第二联:"   at 20 xdnpage2  format "x(12)" .
                put "第三联:"   at 40 xdnpage3  format "x(12)" .
                put "第四联:"   at 60 xdnpage4  format "x(12)" . 
                put "第五联:"   at 80 xdnpage5  format "x(12)" . 
            end. 
            else if xdnpage1 <> "" and xdnpage2 <> "" and xdnpage3 <> "" 
            and xdnpage4 <> ""   then do: 
                put "第一联:"        at 1  xdnpage1     format "x(14)".
                put "第二联:"       at 25 xdnpage2     format "x(14)". 
                put "第三联:"       at 50 xdnpage3     format "x(14)".
                put "第四联:"       at 75 xdnpage4     format "x(14)". 
            end.				     
            else if xdnpage1 <> "" and xdnpage2 <> "" and xdnpage3 <> ""  then do: 
                put "第一联:"           at 1  xdnpage1     format "x(18)".
                put "第二联:"          at 30 xdnpage2     format "x(18)" .
                put "第三联:"          at 60 xdnpage3     format "x(18)" .
            end.
            else if xdnpage1 <> "" and xdnpage2 <> ""  then do: 
                put "第一联："   at 1    xdnpage1     format "x(18)" .
                put "第二联："  at 40  xdnpage2     format "x(18)".
            end.

            put "打印日期:"   STRING(TODAY,"99/99/99") STRING(TIME,"hh:mm:ss")
                "页码:"  TO 116 string(page-start) format "xxxx".  
            put "(END)" skip .	
            page.
            page-start = 1.
    end. /* if last-of(tr_nbr)  */

end.  /*for each tr_hist */


for each tr_hist use-index tr_nbr_eff  where tr_domain = global_domain and tr_type = "rct-tr"
                 and (tr_effdate >= effdate or effdate = ?) and (tr_effdate <= effdate1 or effdate1 = ? )
                 and tr_nbr >= nbrr and ( tr_nbr <= nbrr1 or nbrr1 = "" ) and tr_nbr begins "TR"
                 and tr_addr >= linne and ( tr_addr <= linne1 or linne1 = "" )
                 and ( tr__log02 = no or v_yn = no  )
                 and tr_addr > "" exclusive-lock:
    assign tr__log02 = yes .
end.
   {mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec=a}
