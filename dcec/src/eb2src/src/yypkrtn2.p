/* xxpkrtn2.p   Retrun materiel to store	By: Sunny Zhou AtosOrigin 08/19/02 */
/* xxpkrtn2.p  reference iclotr.p	by sunnyzhou				   */
/* iclotr.p - LOCATION TRANSFER UN ISSUE / UN RECEIPT                   */
/* REVISION: 8.5    LAST MODIFIED: 08/20/02 BY: *Sunny* AtosOrigin */

     /* DISPLAY TITLE */
/*GH52*/ {mfdtitle.i "e+ "}   /*GH52*/

     define new shared variable xxnbr like tr_nbr label "退料单" no-undo.
     define new shared variable xxnbr1 like tr_nbr no-undo.
     define new shared variable so_job like tr_so_job no-undo.
     define new shared variable rmks like tr_rmks  no-undo.
     define new shared variable xSite like pt_site no-undo.
     define new shared variable eff_date like tr_effdate no-undo.
/*sunny*/ define variable xAction as character format "x(30)" label "处理信息".
/*F190*/ define variable yn like mfc_logical.
/*F701*/ define new shared variable site_from like pt_site no-undo.
/*F701*/ define new shared variable loc_from like pt_loc no-undo.
/*F701*/ define new shared variable lotser_from like sr_lotser no-undo.
/*F701*/ define new shared variable lotref_from like ld_ref no-undo.
/*F701*/ define new shared variable status_from like ld_status no-undo.
/*F701*/ define new shared variable site_to like pt_site no-undo.
/*F701*/ define new shared variable loc_to like pt_loc no-undo.
/*F701*/ define new shared variable lotser_to like sr_lotser no-undo.
/*F701*/ define new shared variable lotref_to like ld_ref no-undo.
/*F0FH*/ {gpglefdf.i}
{gplabel.i}
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A


FORM /*GUI*/ 
      
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
	skip(1)
	xSite		 colon 22
	xxnbr            colon 22
	xxnbr1		 colon 45 label {t001.i}
	eff_date         colon 22
        so_job           colon 22
        rmks             colon 22
        skip(1)
      SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/*tfq*/ setframelabels(frame a:handle) .
     /* DISPLAY */
     transloop:
     repeat on endkey undo, leave 
	with frame a :
/*GUI*/ if global-beam-me-up then undo, leave.


	    {gprun.i ""gplotwdl.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*sunny*/	      eff_date = today.

/*sunny*/	for last xxpn_rtn where xxpn_trtype = "ISS-TR" and not xxpn_del exclusive-lock : END.
/*sunny*/	IF available xxpn_rtn THEN
/*sunny*/	DO:
/*sunny*/	     xSite = xxpn_site.
/*sunny*/	      xxnbr = xxpn_nbr.
/*sunny*/	      xxnbr1 = xxpn_nbr.
/*sunny*/	      so_job = xxpn_sojob.
/*sunny*/	      rmks = "领料单退料".
/*sunny*/	    display  xSite xxnbr xxnbr1 so_job rmks eff_date with frame a .
/*sunny*/	END.
/*sunny*/	ELSE DO:
			Message "没有找到可退料的领料单" VIEW-AS ALERT-BOX ERROR BUTTONS ok.
			return.
/*sunny*/	END.
	
	   View frame a .

       setblock:
       do on error undo:
/*GUI*/ if global-beam-me-up then undo, leave.

	   set xSite xxnbr xxnbr1 eff_date so_job rmks with frame a editing:

              {gpglef.i ""IC"" glentity eff_date}

	      assign
	          global_site = input xSite.
	        readkey.
		apply lastkey.
         end.

        find si_mstr where si_site = xSite no-lock no-error.
        if not available si_mstr then do:
          /*tfq*/         {pxmsg.i
               &MSGNUM=708
               &ERRORLEVEL=3
                         }

         /*tfq  {mfmsg.i 708 3} */  /* SITE DOES NOT EXIST */
           next-prompt xSite with frame a.
           undo setblock, retry setblock.
        end.

        {gprun.i ""gpsiver.p""
           "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         if return_int = 0 then do:
           /*tfq*/         {pxmsg.i
               &MSGNUM=725
               &ERRORLEVEL=3
                         }

        /*tfq    {mfmsg.i 725 3}  */  /* USER DOES NOT HAVE */
                               /* ACCESS TO THIS SITE*/
            next-prompt xSite with frame a.
            undo setblock, retry setblock.
         end.
       end. /*do on error undo */
/*GK75*/       hide message.

	/* SELECT PRINTER */
        {mfselbpr.i "printer" 132}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

        {mfphead.i}
	
	tran-loop:
	do transaction on error undo, retry:
	
	{gprun.i ""yypkrtn3.p""}  
	 

	{mfrtrail.i} 

/* 由于执行 undo 功能会导致 tr_trnbr 不连续故不能执行UNDO 功能*
 *		 yn = no.
       /*tfq*/         {pxmsg.i
               &MSGNUM=12
               &ERRORLEVEL=1
               &CONFIRM=yn
            }

 *              /*tfq  {mfmsg01.i 12 1 yn} */
 *                   if yn = no  then do:
 *                      undo tran-loop, leave tran-loop.
 *                   end.
 */
	end.

end.  /*transloop*/
