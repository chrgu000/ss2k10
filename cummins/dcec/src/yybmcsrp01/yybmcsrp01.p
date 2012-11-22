/* GUI CONVERTED from bmcsrp01.p (converter v1.78) Wed Dec 20 14:07:57 2006 */
/* bmcsrp01.p - BILL OF MATERIAL COST REPORT                            */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* CHANGED CONVERT MODE FROM FULLGUIREPORT TO REPORT                    */
/* REVISION: 7.0      LAST MODIFIED: 09/25/91   BY: pma *F003*          */
/* REVISION: 7.3      LAST MODIFIED: 02/18/93   BY: pma *G032*          */
/* REVISION: 7.3      LAST MODIFIED: 08/31/93   BY: pxd *GE64*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 12/29/93   BY: ais *FL07           */
/* REVISION: 7.3      LAST MODIFIED: 12/06/94   BY: cdt *GO70           */
/* REVISION: 8.6      LAST MODIFIED: 10/14/97   BY: GYK *K0ZG*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 02/11/99   BY: *M081* Mugdha Tambe */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn              */
/* Revision: 1.7.1.8  BY: Paul Donnelly (SB)  DATE: 06/26/03  ECO: *Q00B* */
/* Revision: 1.7.1.9  BY: Rajinder Kamra      DATE: 06/23/03  ECO: *Q003* */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *FL07*                    */
/* Old ECO marker removed, but no ECO header exists *GO70*                    */
/* $Revision: 1.7.1.10 $ BY: Gaurav Kerkar        DATE: 12/18/06  ECO: *P5JD*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* ss - 121011.1 by: Steven */ 
/*-Revision end---------------------------------------------------------------*/
/*V8:ConvertMode=Report                                                       */

/* DISPLAY TITLE          */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*{mfdtitle.i "1+ "}*/
{mfdtitle.i "121011.1"}

define shared variable transtype as character.

define new shared variable site  like si_site.
define new shared variable csset like sct_sim.
define new shared variable part  like pt_part.
define new shared variable part1 like pt_part.

define new shared variable numlevels as integer format ">>>" label "Levels".
define new shared variable eff_date  as date initial today
                                             label "As of Date".

define new shared variable newpage like mfc_logical initial yes
                                   label "New Page Each Assembly".
define variable catelm             like mfc_logical format "Element/Category"
                                   label "By Element/Category".
define variable formula_only       like mfc_logical initial no
                                   label "Formula Only" no-undo.

{wbrp02.i}


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/  
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
skip(1)
   part           colon 25 part1 label "To" skip(1)
   numlevels      colon 25
   eff_date       colon 25
   newpage        colon 25
   catelm         colon 25
   skip(1)
   site           colon 25 skip(1)
   formula_only   colon 25
   csset          colon 25
   cs_desc        colon 25
   cs_method      colon 25
   cs_type        colon 25
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find first icc_ctrl
   where icc_ctrl.icc_domain = global_domain no-lock.

site = global_site.

find si_mstr no-lock
   where si_mstr.si_domain = global_domain
   and   si_site           = site no-error.

if available si_mstr
then
   csset = si_cur_set.

repeat:

   if part1 = hi_char
   then
      part1 = "".

   if c-application-mode <> 'web'
   then
      update
         part
         part1
         numlevels
         eff_date
         newpage
         catelm
         site
         formula_only
         csset
   with frame a
   editing:

      if frame-field = "site"
      then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i si_mstr site  " si_mstr.si_domain = global_domain and si_site
              "  site si_site si_site}

         if recno <> ?
         then do:
            site = si_site.
            display site with frame a.
            recno = ?.
         end. /* IF recno <> ? */

      end. /* IF frame-field = "site" */
      else if frame-field = "csset"
      then do:
         /* FIND NEXT/PREVIOUS RECORD */
         if transtype = "SIM"
         then do:
            {mfnp01.i cs_mstr csset cs_set ""SIM""  "
                 cs_mstr.cs_domain = global_domain and cs_type "  cs_set}
         end. /* IF transtype = "SIM" */
         else
            if transtype = "COST"
            then do:
               {mfnp01a.i cs_mstr csset cs_set ""SIM""  "
                  cs_mstr.cs_domain = global_domain and cs_type "  cs_set}
            end. /* IF transtype = "COST" */
            else do:
               {mfnp.i cs_mstr csset  " cs_mstr.cs_domain = global_domain and
                 cs_set "  csset cs_set cs_set}
            end. /* IF transtype <> "COST" */

         if recno <> ?
         then do:
            csset = cs_set.
            display csset with frame a.
            find cs_mstr
               where cs_mstr.cs_domain = global_domain
               and   cs_set            = csset
            no-lock no-error.
            if available cs_mstr
            then
               display cs_desc cs_method cs_type with frame a.
            recno = ?.
         end. /* IF recno <> ? */
      end. /* IF frame-field = "csset" */
      else do:
         readkey.
         apply lastkey.
      end. /* IF frame-field <> "csset" */
   end. /* IF (c-application-mode <> 'web') */

   {wbrp06.i &command = update &fields = " part part1 numlevels eff_date
        newpage  catelm site formula_only csset " &frm = "a"}

   if (c-application-mode <> 'web')
   or (c-application-mode = 'web'
       and (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i part        }
      {mfquoter.i part1       }
      {mfquoter.i numlevels   }
      {mfquoter.i eff_date    }
      {mfquoter.i newpage     }
      {mfquoter.i catelm      }
      {mfquoter.i site        }
      {mfquoter.i formula_only}
      {mfquoter.i csset       }

      if part1 = ""
      then
         part1 = hi_char.

      /* MOVED VALIDATIONS BELOW MFQUOTER CALLS FOR GUI CONVERSION. */
      if true
      then do:
         find si_mstr
            where si_mstr.si_domain = global_domain
            and   si_site           = site
         no-lock no-error.
         if not available si_mstr
         then do:
            /* SITE DOES NOT EXIST */
            {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}

            if c-application-mode = 'web'
            then
               return.
            else
               next-prompt site with frame a.
            undo, retry.
         end. /* IF NOT available si_mstr */

         if si_db <> global_db
         then do:
            /* SITE IS NOT ASSIGNED TO THIS DOMAIN */
            {pxmsg.i &MSGNUM=6251 &ERRORLEVEL=3}

            if c-application-mode = 'web'
            then
               return.
            else
               next-prompt site with frame a.
            undo, retry.
         end. /* IF si_db <> global_db */
      end. /* IF TRUE */

      if true
      then do:
         if csset = ""
         then do:
            /* BLANK NOT ALLOWED */
            {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}

            if c-application-mode = 'web'
            then
               return.
            else
               next-prompt csset with frame a.
            undo, retry.
         end. /* IF csset = "" */

         find cs_mstr
         where cs_mstr.cs_domain = global_domain
         and   cs_set            = csset
         no-lock no-error.
         if not available cs_mstr
         then do:
            /* COST SET DOES NOT EXIST */
            {pxmsg.i &MSGNUM=5407 &ERRORLEVEL=3}

            if c-application-mode = 'web'
            then
               return.
            else
               next-prompt csset with frame a.
            undo, retry.
         end. /* IF NOT AVAILABLE cs_mstr */

         display cs_desc cs_method cs_type with frame a.
      end. /* TRUE */

   end. /* IF (c-application-mode <> 'web') ... */

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
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

   {mfphead.i}

   if catelm
   then do:
   	  /* ss - 121011.1 -b */
      {gprun.i ""bmcsrp1b.p"" "(input formula_only)"}
      /*{gprun.i ""yybmcsrp1b.p"" "(input formula_only)"}*/
      /* ss - 121011.1 -e */
   end.
   else do:
   	  /* ss - 121011.1 -b */
      /*{gprun.i ""bmcsrp1a.p"" "(input formula_only)"}*/ 
      {gprun.i ""yybmcsrp1a.p"" "(input formula_only)"}      
      /* ss - 121011.1 -e */  
   end.

   /* REPORT TRAILER */
   {mfrtrail.i}

   global_site = site.
end.

{wbrp04.i &frame-spec = a}
