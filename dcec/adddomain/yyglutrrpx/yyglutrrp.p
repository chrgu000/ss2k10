/* GUI CONVERTED from glutrrp.p (converter v1.69) Sat Mar 30 01:10:21 1996 */
/* glutrrp.p - GENERAL LEDGER UNPOSTED TRANSACTION REGISTER             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 5.0      LAST MODIFIED: 03/16/89   BY: JMS   *B066*        */
/*                                   10/06/89   by: jms   *B330*        */
/* REVISION: 6.0      LAST MODIFIED: 07/06/90   by: jms   *D034*        */
/*                                   02/20/91   by: jms   *D366*        */
/* REVISION: 7.0      LAST MODIFIED: 10/18/91   by: jjs   *F058*        */
/*                                   02/26/92   by: jms   *F231*        */
/*                                   08/15/94   by: pmf   *FQ15*        */
/*                                   09/03/94   by: srk   *FQ80*        */
/*                                   11/17/94   by: str   *FT77*        */
/*                                   19/07/01   by: rhb   *bn083*       */
/* ss - 121009.1 by: Steven */ /*Add filter by user_id*/     
	  /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*{mfdtitle.i "120912.1"}*/
{mfdtitle.i "121009.1"}  

	  define variable ref like glt_ref.
	  define variable ref1 like glt_ref.
	  define variable dt like glt_date.
	  define variable dt1 like glt_date.
	  define variable effdt like glt_effdate.
	  define variable effdt1 like glt_effdate.
/*F058*/  define variable btch like glt_batch.
	  define variable unb like glt_unb label "只打印未平衡帐务".
	  define variable unb_msg as character format "X(5)".
	  define variable drtot as decimal format ">>>,>>>,>>>,>>>,>>>.99cr".
	  define variable crtot like drtot.
	  define variable type like glt_tr_type.
	  define variable amt like glt_amt.
	  define variable unbflag like mfc_logical.
/*F058*/  define variable account as character format "x(14)" label "帐户".
/*FQ15*/  define variable glname like en_name.
/*FQ15*/  define variable entity like gltr_entity.
/*FQ15*/  define variable entity1 like gltr_entity.
/*FT77*/  define variable entity_flag like mfc_logical.
/*FT77*/  
/* ss - 121009.1 - B */ 
define variable user_id like glt_userid.    
define variable user_id1 like glt_userid. 
/* ss - 121009.1 - E */ 

/*FQ15*/  /* BEGIN: ADDED SECTION */
	  /* GET NAME OF CURRENT ENTITY */
	  find en_mstr where en_domain = global_domain and 
	  		 en_entity = current_entity no-lock no-error.
	  if not available en_mstr then do:
	     {mfmsg.i 3059 3} /* NO PRIMARY ENTITY DEFINED */
	     pause.
	     leave.
	  end.
	  else do:
	     glname = en_name.
	     release en_mstr.
	  end.
	  entity = current_entity.
	  entity1 = entity.
/*FQ15*/  /* END: ADDED SECTION */

form "财  务  凭  证"      at 33  
skip(1)
    glt_ref      label "总帐参考号  " 
    glt_date        label "制单日期  "                 at 30
    glt_effdate    label "出库日期  "    at 50
/*RHB     glt_userid       label "制单人" at 70  */
     with no-box side-labels width 132 frame b.


	  /* SELECT FORM */
	  
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*FQ15*/     
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
       entity   colon 25    entity1 colon 50 label {t001.i}
	     ref      colon 25    ref1    colon 50 label {t001.i}
	     dt       colon 25    dt1     colon 50 label {t001.i}
	     effdt    colon 25    effdt1  colon 50 label {t001.i}
/*F058*/  btch     colon 25  
/* ss - 121009.1 - B */ 
       user_id   colon 25    user_id1 colon 50 label {t001.i}
/* ss - 121009.1 - E */ 
	     type     colon 25
	     unb      colon 25
/*FQ80*   with frame a side-labels attr-space */
/*FQ80*/   SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 
/*FQ15*/   NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = glname.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/*judy 05/08/05*/ /* SET EXTERNAL LABELS */
/*judy 05/08/05*/  setFrameLabels(frame a:handle).


/*RHB	  type = "JL"   .  */
 
	  /* REPORT BLOCK */
	  
/*GUI*/ {mfguirpa.i true  "printer" 80 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

	     if ref1 = hi_char then ref1 = "".
	     if dt =  low_date then dt = ?.
	     if dt1 = hi_date then dt1 = ?.
	     if effdt = low_date then effdt = ?.
	     if effdt1 = hi_date then effdt1 = ?.
/*FQ15*/     if entity1 = hi_char then entity1 = "".
	     unb = no.
	     /* ss - 121009.1 - B */ 
       if user_id1 = hi_char then user_id1 = "".
       /* ss - 121009.1 - E */ 
/*F058*/     
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


	     /* CREATE BATCH INPUT STRING */
	     bcdparm = "".
/*FQ15*/     {mfquoter.i entity  }
/*FQ15*/     {mfquoter.i entity1 }
	     {mfquoter.i ref     }
	     {mfquoter.i ref1    }
	     {mfquoter.i dt      }
	     {mfquoter.i dt1     }
	     {mfquoter.i effdt   }
	     {mfquoter.i effdt1  }
/*F058*/    
       {mfquoter.i btch    }
	     {mfquoter.i type    }
	     {mfquoter.i unb     }
/* ss - 121009.1 - B */ 
       {mfquoter.i user_id  }
       {mfquoter.i user_id1 }
       if user_id1 = "" then user_id1 = hi_char.
/* ss - 121009.1 - E */ 
	     if  ref1 = "" then ref1 = hi_char.
	     if  dt = ?  then dt = low_date.
	     if  dt1 = ? then dt1 = hi_date.
	     if  effdt = ? then effdt = low_date.
	     if  effdt1 = ? then effdt1 = hi_date.
/*FQ15*/     if  entity1 = "" then entity1 = hi_char.
	     crtot = 0.
	     drtot = 0.

	     /* SELECT PRINTER */
	     
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
find en_mstr where en_domain = global_domain and
		 en_entity = current_entity no-lock no-error.

define buffer gltdet for glt_det.

	     {mfphead.i}

	     for each glt_det where glt_domain = global_domain and
/*FQ15*/                            glt_entity >= entity and
/*FQ15*/                            glt_entity <= entity1 and
				    glt_ref >= ref and glt_ref <= ref1 and
				    glt_date >= dt and
				    glt_date <= dt1 and
				    glt_effdate >= effdt and
				    glt_effdate <= effdt1 and
				    /* ss - 121009.1 - B */ 
				    glt_userid >= user_id and
				    glt_userid <= user_id1 and
				    /* ss - 121009.1 - E */ 
/*F058*/    (glt_batch = btch or btch = "")
				    no-lock use-index glt_ref
				    break by glt_ref
				    with width 132 NO-ATTR-SPACE STREAM-IO:
		if type <> "" and substring(glt_ref, 1, 2) <> type then next.
		if unb = yes and glt_unb = no then next.

		if first-of(glt_ref) then do:
/*FT77*/           entity_flag = no.
/*FT77*/           find first gltdet where gltdet.glt_domain = global_domain and
/*FT77*/              gltdet.glt_ref = glt_det.glt_ref and
/*FT77*/              (gltdet.glt_entity < entity or 
/*FT77*/               gltdet.glt_entity > entity1) no-lock no-error.
/*FT77*/           if available gltdet then do:
/*FT77*/              entity_flag = yes.
/*FT77*/              next.
/*FT77*/           end.
		   display glt_det.glt_ref
			   glt_det.glt_date
			   glt_det.glt_effdate
/* RHB 			   glt_det.glt_userid  */
                           WITH frame b STREAM-IO.   /* STREAM-IO /*GUI*/ .  */
		   unb_msg = "".
		   unbflag = no.
		end.
/*
/*FT77*/        else do:
/*FT77*/           if entity_flag = yes then next.
/*FT77*/           display "" @ glt_det.glt_ref
/*FT77*/                   "" @ glt_det.glt_date
/*FT77*/                   "" @ glt_det.glt_effdate
/*FT77*/                   
/* RHB "" @ glt_det.glt_userid */
				WITH STREAM-IO /*GUI*/ .
/*FT77*/        end.
*/		amt = glt_det.glt_amt.
		if glt_det.glt_curr <> base_curr 
		   then amt = glt_det.glt_curr_amt.
/*F058*/        find ac_mstr where ac_domain = global_domain and
									   ac_code = glt_det.glt_acc no-lock no-error.
		if not available ac_mstr then do:
		   accumulate glt_det.glt_amt (total by glt_det.glt_ref).
		   if glt_det.glt_amt < 0 
		      then crtot = crtot - glt_det.glt_amt.
		   else drtot = drtot + glt_det.glt_amt.
		end.
		else if ac_type <> "S" and ac_type <> "M" then do:
		   accumulate glt_det.glt_amt (total by glt_det.glt_ref).
		   if glt_det.glt_amt < 0 
		      then crtot = crtot - glt_det.glt_amt.
		   else drtot = drtot + glt_det.glt_amt.
		end.
/*F058*/ {glacct.i &acc=glt_det.glt_acc 
			  &sub=glt_det.glt_sub 
			  &cc=glt_det.glt_cc 
			  &acct=account}
	       find pj_mstr where pj_domain = global_domain and
	       		  pj_project = glt_project no-lock no-error.
		if available pj_mstr then do:
		display glt_det.glt_line
/*F058*/                account
/*RHB*/			ac_mstr.ac_desc WHEN AVAIL ac_mstr column-label "账户名称"
/*bn083 don't disply entity*/
			glt_det.glt_project 
			pj_desc
/*bn083			glt_det.glt_entity     */
			glt_det.glt_desc
			glt_det.glt_cc
			amt
			glt_det.glt_curr WITH width 180 /*GUI*/ .
		end.
		else do:
		display glt_det.glt_line
/*F058*/                account
/*RHB*/			ac_mstr.ac_desc WHEN AVAIL ac_mstr
/*bn083 don't disply entity*/
			glt_det.glt_project 			
/*bn083			glt_det.glt_entity     */
			glt_det.glt_desc
/*RHB			glt_det.glt_cc */
			amt
			glt_det.glt_curr WITH STREAM-IO /*GUI*/ .
		end.
		if glt_det.glt_error <> "" then do:
		   down 1.
		   disp glt_det.glt_error @ glt_det.glt_desc WITH STREAM-IO /*GUI*/ .
		end.
		if glt_det.glt_unb = yes then unbflag = yes.

		if last-of(glt_det.glt_ref) then do:
/*F231*/           if unbflag = yes then unb_msg = "*不平*".
		   underline amt.
		   disp accum total by glt_det.glt_ref glt_det.glt_amt @ amt
		      base_curr @ glt_det.glt_curr unb_msg no-label WITH STREAM-IO /*GUI*/ .
		   down 1.
		end.

		
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

	     end.

	     /* PRINT DEBIT AND CREDIT TOTALS */
             put      "---------------------------------------------------------------------------------------------".
/*F231*/     put   skip(1) "    借方合计:  "  drtot space(1) base_curr
/*F231*/                  "贷方合计:      "  at 45 crtot space(1) base_curr.

        /* REPORT TRAILER  */
find usr_mstr where usr_userid = glt_userid no-lock no-error.

/*bn083 Print the new report trailer */
             put skip(1)     "---------------------------------------------------------------------------------------------".
            put  skip(1) "    财务主管:                  复核:                    制单:" .
if available usr_mstr then put usr_name.
	     

/* bn083 cancel the trailer print	     
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/
*/
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

	  end.

/*GUI*/ end procedure. /*p-report*/
	
	
/*GUI*/ 
/* ss - 121009.1 - B */ 
/* {mfguirpb.i &flds="  entity entity1 ref ref1 dt dt1 effdt effdt1 btch type unb "}*/

{mfguirpb.i &flds="  entity entity1 ref ref1 dt dt1 effdt effdt1 btch user_id user_id1 type unb "}

/* ss - 121009.1 - e */ 
 /*Drive the Report*/
