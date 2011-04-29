/* s9issunp.p - Unplanned issue Report                                  */
/*By: Neil Gao 09/02/06 ECO: *SS 20090206* */

/* DISPLAY TITLE */
{mfdtitle.i "a"}

          define variable line like pt_prod_line no-undo.
          define variable line1 like pt_prod_line no-undo.
          define variable site   like pt_site no-undo.
          define variable site1  like pt_site no-undo.
          define variable acct  like trgl_dr_acct no-undo.
          define variable acct1 like trgl_dr_acct no-undo.
          define variable proj  like trgl_dr_proj no-undo.
          define variable proj1 like trgl_dr_proj no-undo.
          define variable issdt  like tr_date no-undo.
          define variable issdt1 like tr_date no-undo.
          define variable tmpdesc like pt_desc1 no-undo.
          define variable sno   as integer no-undo.
          define variable tot as dec format "->>>,>>>,>>9.99" no-undo.            


         /* SELECT FORM */
         form
            line           colon 20
            line1          label {t001.i} colon 49 skip
            acct           colon 20
            acct1          label {t001.i} colon 49 skip
            proj           colon 20
            proj1          label {t001.i} colon 49 skip
            site           colon 20
            site1          label {t001.i} colon 49 skip
            issdt          colon 20
            issdt1         label {t001.i} colon 49 skip
/*FQ43*/ with frame a side-labels width 80.

setFrameLabels(frame a:handle).

/* REPORT BLOCK */

{wbrp01.i}
repeat:

   if line1 = hi_char then line1 = "".
   if site1 = hi_char then site1 = "".
   if acct1 = hi_char then acct1 = "".
   if proj1 = hi_char then proj1 = "".
   if issdt = low_date then issdt = ?.
   if issdt1 = hi_date then issdt1 = ?.

if c-application-mode <> 'web' then
   update line line1
   acct acct1 proj proj1 site site1 issdt issdt1
   with frame a.

   {wbrp06.i &command = update &fields = "  line line1
             acct acct1 proj proj1 site site1 issdt issdt1" &frm = "a"}

/*K0RN*/ if (c-application-mode <> 'web') or
/*K0RN*/ (c-application-mode = 'web' and
/*K0RN*/ (c-web-request begins 'data')) then do:

   bcdparm = "".
   {mfquoter.i line   }
   {mfquoter.i line1  }
   {mfquoter.i acct   }
   {mfquoter.i acct1  }
   {mfquoter.i proj   }
   {mfquoter.i proj1  }
   {mfquoter.i site   }
   {mfquoter.i site1  }
   {mfquoter.i issdt  }
   {mfquoter.i issdt1 }

   if line1 = "" then line1 = hi_char.
   if acct1 = "" then acct1 = hi_char.
   if proj1 = "" then proj1 = hi_char.
   if site1 = "" then site1 = hi_char.
   if issdt = ? then issdt = low_date.
   if issdt1 = ? then issdt1 = hi_date.

/*K0RN*/ end.

   /* PRINTER SELECTION */
   {mfselbpr.i "printer" 132}
   {mfphead.i}

   assign sno = 0
          tot = 0.
   
   for each tr_hist field(tr_type tr_site tr_effdate tr_part tr_date
                    tr_nbr tr_userid tr_loc tr_prod_line tr_loc tr_qty_chg
                    tr_trnbr tr_qty_loc)
                    no-lock
       where (tr_date >= issdt and tr_date <= issdt1) and
/*SS 20090206 - B*/
							tr_domain = global_domain and
/*SS 20090206 - E*/
             (tr_prod_line >= line and tr_prod_line <= line1) and
             (tr_site >= site and tr_site <= site1) and
             tr_type = "iss-unp" use-index tr_date_trn  :
             
       for each trgl_det field(trgl_dr_acct trgl_dr_cc
            trgl_dr_proj trgl_trnbr) no-lock
            where trgl_trnbr = tr_trnbr and
/*SS 20090206 - B*/
							trgl_domain = global_domain and 
/*SS 20090206 - E*/
            (trgl_dr_acct >= acct and trgl_dr_acct <= acct1) and 
            (trgl_dr_proj >= proj and trgl_dr_proj <= proj1) 
            use-index trgl_nbr_ref
            with frame b width 132 no-box down:
			setFrameLabels(frame b:handle).
       sno = sno + 1.
      
    find first in_mstr no-lock where in_part = tr_part 
/*SS 20090206 - B*/
					and in_domain = global_domain
/*SS 20090206 - E*/
         and in_site = tr_site use-index in_part no-error.
    if available in_mstr then 
        {gpsct03.i &cost=sct_cst_tot }   
        
 find pt_mstr where pt_part = tr_part  
/*SS 20090206 - B*/
	and pt_domain = global_domain
/*SS 20090206 - E*/ 
 no-lock no-error.
 if available pt_mstr then
    tmpdesc = pt_desc1.
 else 
    tmpdesc = "".

      tot = round((abs(tr_qty_loc) * round(glxcst,2)),2) + tot.
      
      
      display
         sno        format ">>9"  label "No."
         tr_prod_line
         tr_part
         tmpdesc    format "x(20)" label "ÃèÊö"
         tr_qty_loc format "->>>>>9.99" label "Qty-Iss"
         glxcst     format ">>>>>9.99" label "U.Cost"
         trgl_dr_acct
         trgl_dr_cc
         trgl_dr_proj 
         tr_date.

   end.
   end. 
   put "-----------------" at 54. 
   put "Tot Cost: " at 35 tot at 54.
  
   /* REPORT TRAILER */
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}

