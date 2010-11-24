/* gpcmmt01.p - TRANSACTION COMMENTS                                          */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.37.1.1 $                                                          */
/*                                                                            */
/* Logic to view and maintain the transaction comments for an application     */
/* and allow the attachment of an exiting Master Comment to it                */
/*                                                                            */
/* NOTE: ANY CHANGES TO THIS PROGRAM SHOULD ALSO BE MADE TO gpcmmt03.p        */
/* REVISION: 4.0     LAST MODIFIED: 11/17/87    BY: PML                       */
/* REVISION: 4.0     LAST MODIFIED: 05/02/88    BY: PML *A221*                */
/* REVISION: 4.0     LAST MODIFIED: 11/10/88    BY: EMB *A530*                */
/* REVISION: 5.0     LAST MODIFIED: 01/26/89    BY: RL  *A623*                */
/* REVISION: 5.0     LAST MODIFIED: 10/31/89    BY: EMB *B380*                */
/* REVISION: 6.0     LAST MODIFIED: 06/26/90    BY: WUG *D043*                */
/* REVISION: 6.0     LAST MODIFIED: 08/20/90    BY: RAM *D030*                */
/* REVISION: 6.0     LAST MODIFIED: 04/10/91    BY: WUG *D513*                */
/* REVISION: 6.0     LAST MODIFIED: 05/24/91    BY: emb *D662*                */
/* REVISION: 6.0     LAST MODIFIED: 08/09/91    BY: emb *D818*                */
/* REVISION: 7.0     LAST MODIFIED: 12/20/91    BY: WUG *F034*                */
/* REVISION: 7.0     LAST MODIFIED: 01/29/92    BY: WUG *F110*                */
/* REVISION: 7.0     LAST MODIFIED: 03/17/92    BY: RAM *F298*                */
/* REVISION: 7.0     LAST MODIFIED: 06/09/92    BY: tjs *F504*                */
/* REVISION: 7.0     LAST MODIFIED: 09/23/92    BY: emb *G080*                */
/* REVISION: 7.3     LAST MODIFIED: 10/14/92    BY: rwl *G185*                */
/* REVISION: 7.3     LAST MODIFIED: 11/25/92    BY: emb *G359*                */
/* REVISION: 7.3     LAST MODIFIED: 02/22/93    BY: tjs *G718*                */
/* REVISION: 7.3     LAST MODIFIED: 05/07/93    BY: afs *GA73*                */
/* REVISION: 7.3     LAST MODIFIED: 09/30/93    BY: WUG *GG12*                */
/* REVISION: 7.4     LAST MODIFIED: 10/04/93    BY: WUG *H153*                */
/* REVISION: 7.4     LAST MODIFIED: 10/28/93    BY: dpm *H186*                */
/* REVISION: 7.4     LAST MODIFIED: 09/15/94    BY: ljm *GM66*                */
/* REVISION: 7.4     LAST MODIFIED: 12/29/94    BY: pxd *F0BF*                */
/* REVISION: 7.4     LAST MODIFIED: 01/17/95    BY: jxz *F0F4*                */
/* REVISION: 7.4     LAST MODIFIED: 05/30/95    BY: jym *F0SF*                */
/* REVISION: 7.4     LAST MODIFIED: 06/06/95    BY: str *G0PC*                */
/* REVISION: 8.5     LAST MODIFIED: 06/08/95    BY: *J04C* Sue Poland         */
/* REVISION: 8.5     LAST MODIFIED: 12/14/95    BY: *G0TN* Sue Poland         */
/* REVISION: 8.5     LAST MODIFIED: 06/11/96    BY: *J0S4* Rob Wachowicz      */
/* REVISION: 8.5     LAST MODIFIED: 08/06/96    BY: *G2BH* Sanjay Patil       */
/* REVISION: 8.6     LAST MODIFIED: 10/22/96    BY: *K004* Elke Van Maele     */
/* REVISION: 8.6     LAST MODIFIED: 11/19/96    BY: *H0PD* Aruna Patil        */
/* REVISION: 8.6     LAST MODIFIED: 04/03/97    BY: *K09K* Arul Victoria      */
/* REVISION: 8.6     LAST MODIFIED: 07/02/97    BY: ame *J1PM*                */
/* REVISION: 8.6     LAST MODIFIED: 10/21/97    BY: *J23P* Markus Barone      */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 07/16/98    BY: *H1MB* Viswanathan M      */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan         */
/* REVISION: 8.6E    LAST MODIFIED: 02/21/00    BY: *L0S1* Manish K.          */
/* REVISION: 9.1     LAST MODIFIED: 03/06/00    BY: *N05Q* David Morris       */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *G0J1*                    */
/* Revision: 1.20        BY: Anup Pereira      DATE:05/11/00    ECO: *N03T*   */
/* Revision: 1.21        BY: Paul Donnelly     DATE:06/17/00    ECO: *N0B9*   */
/* Revision: 1.22        BY: Julie Milligan    DATE:08/02/00    ECO: *N059*   */
/* Revision: 1.24        BY: Joseph Jegan      DATE:08/08/00    ECO: *M0QX*   */
/* Revision: 1.25        BY: Mark Brown        DATE:08/24/00    ECO: *N0ND*   */
/* Revision: 1.29        BY: Jean Miller       DATE:06/03/01    ECO: *M11Z*   */
/* Revision: 1.32  BY: Andrea Suchankova       DATE: 10/15/02   ECO: *N13P*   */
/* Revision: 1.34  BY: Paul Donnelly (SB)      DATE: 06/26/03   ECO: *Q00F*   */
/* Revision: 1.35  BY: Manish Dani             DATE: 08/29/03   ECO: *P11T*   */
/* Revision: 1.36  BY: Manisha Sawant          DATE: 06/15/04   ECO: *P269*   */
/* Revision: 1.37  BY: Matthew Lee             DATE: 02/06/05   ECO: *P36X*   */
/* $Revision: 1.37.1.1 $ BY: Shoma Salgaonkar        DATE: 06/03/05   ECO: *P3NN*   */
/*-Revision end---------------------------------------------------------------*/

/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */
/* ************************************************************************** */
/* Note: This code has been modified to run when called inside an MFG/PRO API */
/* method as well as from the MFG/PRO menu, using the global variable         */
/* c-application-mode to conditionally execute API- vs. UI-specific logic.    */
/* Before modifying the code, please review the MFG/PRO API Development Guide */
/* in the QAD Development Standards for specific API coding standards and     */
/* guidelines.                                                                */
/* ************************************************************************** */

{mfdeclre.i}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i &ClearReg=yes}

{pxmaint.i}

define input parameter file_name as character no-undo.

define shared variable cmtindx like cmt_indx.

define variable prevField       as character no-undo.
define variable del-yn          like mfc_logical initial no no-undo.
define variable i               as   integer                no-undo.
define variable prt_on_quote    like mfc_logical
   label "Print On Quote"  no-undo.
define variable prt_on_so       like mfc_logical
   label "Print On Sales Order" no-undo.
define variable prt_on_invoice  like mfc_logical
   label "Print On Invoice"  no-undo.
define variable prt_on_packlist like mfc_logical
   label "Print On Packing List"  no-undo.
define variable prt_on_po       like mfc_logical
   label "Print On Purchase Order" no-undo.
define variable prt_on_rtv      like mfc_logical
   label "Print On Rtn To Supplier"  no-undo.
define variable prt_on_rct      like mfc_logical
   label "Print On PO Receipt" no-undo.
define variable prt_on_shpr     like mfc_logical
   label "Print On Shipper"  no-undo.
define variable prt_on_bol      like mfc_logical
   label "Print On Bill of Lading"  no-undo.
define variable prt_on_schedule like mfc_logical
   label "Print On Schedules" no-undo.
define variable prt_on_cus      like mfc_logical
   label "Print On Customer Reports" initial yes no-undo.
define variable prt_on_intern   like mfc_logical
   label "Print On Internal Reports" initial yes no-undo.
define variable prt_on_isrqst   like mfc_logical
   label "Print On I/S Request" no-undo.
define variable prt_on_do       like mfc_logical
   label "Print On Distr. Order" no-undo.

define variable first-time      like mfc_logical initial yes no-undo.
define variable cmt_recno       as   recid       no-undo.
define variable newcmmt         like mfc_logical no-undo.
define variable l-value         as   character   no-undo.
define variable l-fontvalue     as   integer     no-undo.
define variable pSeq            like cmt_seq     no-undo.
define variable emt-bu-lvl  as character format "x(4)" no-undo.

{mfaimfg.i} /* Common API constants and variables */

{mfctit01.i} /* API transaction comment temp tables */

define variable validCmtPrintList        as character   no-undo.
define variable validPrintEntry          as character   no-undo.
define variable createTransComment       as logical no-undo.
define variable cmtPrint               like cmt_print   no-undo.
define variable commentTextProvided      as logical no-undo.
define variable masterCommentPageCount   as integer     no-undo.
define variable renumberIncrement        as integer     no-undo.
define variable newPageNumber            as integer     no-undo.
define variable cmtSeq                 like cmt_seq     no-undo.

if c-application-mode = "API" then do:

   /* Get handle of API controller */
   {gprun.i ""gpaigh.p""
      "(output ApiMethodHandle,
        output ApiProgramName,
        output ApiMethodName,
        output ApiContextString)"}

   /* Get transaction comment temp-table */
   run getTransComment in ApiMethodHandle
      (output table ttTransComment).

end. /* IF c-application-mode = "API" */

/* FOR REPLACING SCHEMA VALIDATION OF COMMENT TYPE */
FUNCTION validType returns logical (input commentType as character):
   {pxrun.i &PROC='validateCommentType' &PROGRAM='gpcmxr.p'
      &PARAM="(input commentType)"
      &NOAPPERROR=true
      &CATCHERROR=true}
   return (return-value = {&SUCCESS-RESULT}).
END FUNCTION. /* validType */

/* FOR REPLACING SCHEMA VALIDATION OF COMMENT LANGUAGE */
FUNCTION validLang returns logical (input commentLang as character):
   {pxrun.i &PROC='validateCommentLang' &PROGRAM='gpcmxr.p'
      &PARAM="(input commentLang)"
      &NOAPPERROR=true
      &CATCHERROR=true}
   return (return-value = {&SUCCESS-RESULT}).
END FUNCTION. /* validLang */

/* N13P does not change any logic when not in API mode */
if c-application-mode <> "API" then do:

   for first soc_ctrl
      fields( soc_domain soc_use_btb)
    where soc_ctrl.soc_domain = global_domain no-lock:
   end.

   form
      cmt_seq     colon 18
      cd_ref      colon 18
      cd_lang     colon 71 validate(true, "")
      cd_type     colon 18 validate(true, "")
      cd_seq      colon 71
      cmt_cmmt    no-labels
      /*V8! view-as fill-in size 76 by 1 at 2 skip */
   with overlay frame cmmt01
      title color normal (getFrameTitle("TRANSACTION_COMMENTS",29))
      no-validate side-labels width 80 attr-space.

   setFrameLabels(frame cmmt01:handle).

   get-key-value section "ProADE" key "FixedFont" value l-value.

   /* DEFAULT PROGRESS ADE FIXEDFONT VALUE */
   if l-value = ? or l-value = "" then
      l-value = "0".

   l-fontvalue = integer(l-value).

   assign
      cmt_cmmt[1]:font  = l-fontvalue
      cmt_cmmt[2]:font  = l-fontvalue
      cmt_cmmt[3]:font  = l-fontvalue
      cmt_cmmt[4]:font  = l-fontvalue
      cmt_cmmt[5]:font  = l-fontvalue
      cmt_cmmt[6]:font  = l-fontvalue
      cmt_cmmt[7]:font  = l-fontvalue
      cmt_cmmt[8]:font  = l-fontvalue
      cmt_cmmt[9]:font  = l-fontvalue
      cmt_cmmt[10]:font = l-fontvalue
      cmt_cmmt[11]:font = l-fontvalue
      cmt_cmmt[12]:font = l-fontvalue
      cmt_cmmt[13]:font = l-fontvalue
      cmt_cmmt[14]:font = l-fontvalue
      cmt_cmmt[15]:font = l-fontvalue.

   do with frame cmmt01:
      if cmtindx <> 0 then
         for first cmt_det
            fields( cmt_domain cmt_cmmt cmt_indx cmt_lang cmt_print cmt_ref
            cmt_seq cmt_type)
             where cmt_det.cmt_domain = global_domain and  cmt_indx = cmtindx
         no-lock:
         end.
      if available cmt_det
      then do:
         cmt_recno = recid(cmt_det).
         display
            cmt_seq + 1 @ cmt_seq
            cmt_ref     @ cd_ref
            cmt_type    @ cd_type
            cmt_lang    @ cd_lang
            cmt_cmmt.
      end. /* IF AVAILABLE cmt_det */

      else do:
         display
            1           @ cmt_seq
            global_ref  @ cd_ref
            global_type @ cd_type
            global_lang @ cd_lang.

         /* READ MASTER COMMENT RECORD FOR GLOBAL SETTINGS */
         {pxrun.i &PROC='findMasterComment' &PROGRAM='gpcmxr1.p'
            &PARAM="(input global_ref,
              input global_type,
              input global_lang,
              buffer cd_det)"
            &NOAPPERROR=true
            &CATCHERROR=true}

         if return-value = {&SUCCESS-RESULT}
         then do:
            display cd_seq + 1 @ cd_seq.
            do i = 1 to 15:
               display cd_cmmt[i] @ cmt_cmmt[i].
            end. /* do i = 1 TO 15: */
         end. /* if return-value */
      end. /* else */
   end. /* do with frame cmmt01: */

   /*REMOVE PAUSE AT BEGINNING OF COMMENT DISPLAY*/
   pause 0.

   repeat with frame cmmt01:

      newcmmt = no.

      if can-find (first cmt_det  where cmt_det.cmt_domain = global_domain and
      (  cmt_indx = cmtindx)) or
         first-time = no
      then do:

         prompt-for
            cmt_seq
            editing:
               {mfnp05.i cmt_det cmt_ref " cmt_det.cmt_domain = global_domain
               and cmt_indx  = cmtindx" cmt_seq
                  "(input cmt_seq - 1)"}
               if recno <> ?
               then do:
                  display
                     cmt_ref     @ cd_ref
                     cmt_type    @ cd_type
                     cmt_lang    @ cd_lang
                     cmt_seq + 1 @ cmt_seq
                     cmt_cmmt.

                  display "" @ cd_seq.
               end. /* IF recno <> ? */
            end. /* EDITING */

         /* ADD/MOD/DELETE */

         /* READ TRANSACTION COMMENT RECORD */
         {pxrun.i &PROC='processRead' &PROGRAM='gpcmxr.p'
            &PARAM="(input cmtindx,
              input cmt_seq:screen-value,
              buffer cmt_det,
              input true,
              input true)"
            &NOAPPERROR=true
            &CATCHERROR=true}

         if return-value = {&SUCCESS-RESULT}
         then do:

            display
               cmt_seq + 1 @ cmt_seq
               cmt_ref     @ cd_ref
               cmt_type    @ cd_type
               cmt_lang    @ cd_lang
               ""          @ cd_seq.

            assign
               recno     = recid(cmt_det)
               cmt_recno = recid(cmt_det).

         end. /* IF AVAILABLE cmt_det */
      end. /* PROMPT-FOR cmt_seq */

      if not available cmt_det then
      do on error undo, retry:

         newcmmt = yes.
         pSeq = integer(cmt_seq:screen-value).

         /* CREATE TRANSACTION COMMENT RECORD AND INITIALIZE PRINT SETTING */
         {pxrun.i &PROC='processCreate' &PROGRAM='gpcmxr.p'
            &PARAM="(input-output cmtindx,
              input-output pSeq,
              input file_name,
              buffer cmt_det)"
            &NOAPPERROR=true
            &CATCHERROR=true}

         cmt_seq:screen-value = string(pSeq).

         recno = recid(cmt_det).

         if not first-time then
            display cmt_cmmt.

         /* MESSAGE #1 - ADDING NEW RECORD */
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL={&INFORMATION-RESULT}}

         if can-find (first cd_det using  cd_ref and cd_type and cd_lang
         where cd_det.cd_domain = global_domain )
         then do:

            for first cd_det
               fields( cd_domain cd_cmmt cd_lang cd_ref cd_seq cd_type)
               using  cd_ref and cd_type and cd_lang
               where cd_det.cd_domain = global_domain
               no-lock:



            end.
            if available cd_det
            then do:
               display cd_seq + 1 @ cd_seq.
               do i = 1 to 15:
                  display cd_cmmt[i] @ cmt_cmmt[i].
               end. /* DO i = 1 TO 15: */
            end. /* IF AVAILABLE cd_det */
         end. /* IF CAN-FIND (FIRST cd_det... */
         else do:

            for first cd_det
               fields(cd_domain cd_cmmt cd_lang cd_ref cd_seq cd_type)
               where cd_domain = global_domain
               and   cd_ref    = global_ref
               and   cd_type   = (if cd_type <> ""
                                  then
                                     cd_type
                                  else
                                     global_type)
               and   cd_lang   = (if cd_lang <> ""
                                  then
                                     cd_lang
                                  else
                                     global_lang)
               no-lock:
            end. /* FOR FIRST cd_det */

            if available cd_det
            then
               display  cd_seq + 1 @ cd_seq.

         end.  /* ELSE DO */

         prevField = "cd_ref".
         prompt-for
            cd_ref
            cd_type
            cd_lang
            cd_seq
            editing:
               if frame-field = "cd_ref"
               then do:
                  {mfnp05.i cd_det cd_ref_type  " cd_det.cd_domain =
                  global_domain and yes "  cd_ref "input cd_ref"}
               end. /* IF FRAME-FIELD = "cd_ref" */
               else
                  if frame-field = "cd_type"
                  then do:
                     {mfnp05.i cd_det cd_ref_type
                        " cd_det.cd_domain = global_domain and cd_ref  = input
                        cd_ref" cd_type "input cd_type"}
                  end. /* IF FRAME-FIELD = "cd_type" */
                  else
                     if frame-field = "cd_lang"
                     then do:
                        {mfnp05.i cd_det cd_ref_type
                           " cd_det.cd_domain = global_domain and cd_ref  =
                           input cd_ref and cd_type = input cd_type"
                           cd_lang "input cd_lang"}
                     end. /* IF FRAME-FIELD = "cd_lang" */
                     else
                        if frame-field = "cd_seq"
                        then do:
                           {mfnp05.i cd_det cd_ref_type
                              " cd_det.cd_domain = global_domain and cd_ref  =
                              input cd_ref and cd_type = input cd_type
                              and cd_lang = input cd_lang"
                              cd_seq "input cd_seq - 1"}
                        end. /* IF FRAME-FIELD = "cd_seq" */
                        else do:
                           readkey.
                           apply lastkey.
                           recno = ?.
                        end. /* ELSE */

               if go-pending then do:
                  if not validType(input frame cmmt01 cd_type) then do:
                     next-prompt cd_type.
                     next.
                  end.
                  if not validLang(input frame cmmt01 cd_lang) then do:
                     next-prompt cd_lang.
                     next.
                  end.
               end.

               if frame-field <> prevField then do:
                  if prevField = "cd_type"
                     and not validType(input frame cmmt01 cd_type) then do:
                     next-prompt cd_type.
                     next.
                  end.
                  if prevField = "cd_lang"
                     and not validLang(input frame cmmt01 cd_lang) then do:
                     next-prompt cd_lang.
                     next.
                  end.
                  prevField = frame-field.
               end.

               if recno <> ?
               then do:
                  display
                     cd_ref
                     cd_type
                     cd_lang
                     cd_seq + 1 @ cd_seq.
                  do i = 1 to 15:
                     display cd_cmmt[i] @ cmt_cmmt[i].
                  end. /* DO i = 1 TO 15: */
               end. /* IF recno <> ? */

            end. /* EDITING */
         /* READ MASTER COMMENT RECORD */
         {pxrun.i &PROC='processRead' &PROGRAM='gpcmxr1.p'
                  &PARAM="(input cd_ref:screen-value,
                           input cd_type:screen-value,
                           input cd_lang:screen-value,
                           input cd_seq:screen-value,
                           buffer cd_det,
                           input false,
                           input false)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT}
            and not cd_seq entered
         then do:

            if cd_seq:screen-value = "" then
            do:
               {pxrun.i &PROC='findMasterComment' &PROGRAM='gpcmxr1.p'
                  &PARAM="(input cd_ref:screen-value,
                           input cd_type:screen-value,
                           input cd_lang:screen-value,
                           buffer cd_det)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
            end. /* IF CD_SEQ:SCREEN-VALUE = "" */
            else
            do:
               {pxrun.i &PROC='processRead' &PROGRAM='gpcmxr1.p'
                  &PARAM="(input cd_ref:screen-value,
                    input cd_type:screen-value,
                    input cd_lang:screen-value,
                    input cd_seq:screen-value,
                    buffer cd_det,
                    input false,
                    input false)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
            end. /* ELSE DO */

            if return-value = {&SUCCESS-RESULT} then
               display cd_seq + 1 @ cd_seq.
         end. /* IF NOT AVAILABLE cd_det ... */

         if return-value = {&SUCCESS-RESULT}
         then do:
            do i = 1 to 15:
               cmt_cmmt[i] = cd_cmmt[i].
            end. /* DO i = 1 TO 15: */
         end. /* IF AVAILABLE cd_det */

         assign
            cmt_ref  = input cd_ref
            cmt_type = input cd_type
            cmt_lang = input cd_lang.

      end. /* IF NOT AVAILABLE cmt_det */

      assign
         ststatus   = stline[2]
         del-yn     = no
         first-time = no.
      status input ststatus.

      {fsmnp02.i ""gpcmmt01.p"" 10
         """(input recid(cmt_det),
           input newcmmt)"""}
      display cmt_cmmt.

      /* If we are running SO Maintenance and using EMT, determine */
      /* which BU Level we are at, don't allow maintenance if the  */
      /* comments were created at a different BU Level             */
      hide message no-pause.
      if soc_use_btb and lookup(file_name,"so_mstr,sod_det") > 0
         and global_part <> ""
         and lookup(global_part,"PBU,MBU,SBU") > 0
      then do:
         emt-bu-lvl = global_part.
         if (emt-bu-lvl <> cmt__qadc01) and cmt__qadc01 <> "" then do:
            {pxmsg.i &MSGNUM=4612 &ERRORLEVEL=1 &MSGARG1=cmt__qadc01}
         end.
      end.

      set1:
      do on error undo, retry:

         if (soc_use_btb and lookup(file_name,"so_mstr,sod_det") > 0 and
            (emt-bu-lvl = cmt__qadc01 or cmt__qadc01 = "")) or
            not soc_use_btb or
            lookup(file_name,"so_mstr,sod_det") = 0 or
            cmt__qadc01 = ""
         then do:
            if {gpiswrap.i} then
               set cmt_cmmt go-on ("F5" "CTRL-D").
            else
               set text(cmt_cmmt) go-on ("F5" "CTRL-D").
         end.

         /* DELETE */
         if lastkey = keycode("F5") or
            lastkey = keycode("CTRL-D")
         then do:
            del-yn = yes.
            /* MESSAGE #11 - PLEASE CONFIRM DELETE */
            {pxmsg.i
               &MSGNUM=11
               &ERRORLEVEL={&INFORMATION-RESULT}
               &CONFIRM=del-yn}
            if not del-yn then
               undo set1, retry.
         end. /* IF LASTKEY = KEYCODE("F5") */
      end. /* DO ON ERROR UNDO, RETRY: */

      if del-yn
      then do:
         delete cmt_det.

         clear frame cmmt01.
         del-yn = no.

         find next cmt_det no-lock
             where cmt_det.cmt_domain = global_domain and  cmt_indx = cmtindx
             no-error.
         if not available cmt_det then
            find prev cmt_det no-lock
                where cmt_det.cmt_domain = global_domain and  cmt_indx =
                cmtindx no-error.
         if available cmt_det
         then do:
            display
               cmt_seq + 1 @ cmt_seq
               cmt_ref     @ cd_ref
               cmt_type    @ cd_type
               cmt_lang    @ cd_lang
               cmt_cmmt.
         end. /* IF AVAILABLE cmt_det */

         if not available cmt_det then
            cmtindx = 0.
         next.
      end. /* IF del-yn */

      /* GET PRINT CONTROL */
      form
         prt_on_quote      colon 25
         space(2)
         prt_on_so         colon 25
         prt_on_invoice    colon 25
         prt_on_packlist   colon 25
         prt_on_po         colon 25 label "Print On EMT PO"
      with frame sales-btb side-labels overlay row 8 centered attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame sales-btb:handle).

      form
         prt_on_quote      colon 25
         space(2)
         prt_on_so         colon 25
         prt_on_invoice    colon 25
         prt_on_packlist   colon 25
      with frame sales side-labels overlay row 8 centered attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame sales:handle).

      form
         prt_on_po         colon 25
         space(2)
         prt_on_rct        colon 25
         prt_on_rtv        colon 25
      with frame purch side-labels overlay row 8 centered attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame purch:handle).

      form
         prt_on_packlist   colon 25
         space(2)
      with frame cust_sched side-labels overlay row 8 centered attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame cust_sched:handle).

      form
         prt_on_schedule   colon 25
         space(2)
      with frame supp_sched side-labels overlay row 8 centered attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame supp_sched:handle).

      form
         prt_on_shpr       colon 25
         space(2)
         prt_on_bol        colon 25
      with frame shipper side-labels overlay row 8 centered attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame shipper:handle).

      form
         prt_on_do         colon 25
         space(2)
         prt_on_packlist   colon 25
      with frame distr side-labels overlay row 8 centered attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame distr:handle).

      form
         prt_on_isrqst      colon 25
         space(2)
      with frame isite side-labels overlay row 8 centered attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame isite:handle).

      form
         prt_on_intern     colon 30
      with frame calls side-labels overlay row 8 centered attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame calls:handle).

      form
         prt_on_intern     colon 30
         prt_on_po         colon 30 label "Print On EMT PO"
      with frame paocmmt side-labels overlay row 8 centered attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame paocmmt:handle).

      form
         prt_on_cus        colon 30
         prt_on_invoice    colon 30
         prt_on_intern     colon 30
         prt_on_po         colon 30
      with frame projtype side-labels overlay row 8 centered attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame projtype:handle).

      form
         prt_on_cus        colon 30
         prt_on_invoice    colon 30
         prt_on_intern     colon 30
      with frame pjdtype side-labels overlay row 8 centered attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame pjdtype:handle).

      form
         prt_on_invoice    colon 18
      with frame instype side-labels overlay row 8 centered attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame instype:handle).

      if lookup(file_name,"so_mstr,sod_det") > 0 then
      do:
         for first soc_ctrl
            fields( soc_domain soc_use_btb)
          where soc_ctrl.soc_domain = global_domain no-lock:
         end.
      end. /* IF LOOKUP(file_name,"so_mstr,sod_det") */

/* ss 20071224 - b */
/*
*      /* GET THE PRINT OPTIONS BASED ON THE TRANSACTION COMMENT PRINT SETTING */
*      {pxrun.i &PROC='getPrintOptions' &PROGRAM='gpcmxr.p'
*         &PARAM="(input cmt_print,
*           output prt_on_quote,
*           output prt_on_so,
*           output prt_on_invoice,
*           output prt_on_packlist,
*           output prt_on_po,
*           output prt_on_rct,
*           output prt_on_rtv,
*           output prt_on_shpr,
*           output prt_on_bol,
*           output prt_on_do,
*           output prt_on_isrqst,
*           output prt_on_intern,
*           output prt_on_cus)"
*         &NOAPPERROR=true
*         &CATCHERROR=true}
*
*      if lookup(file_name,"so_mstr,sod_det") > 0 and
*         soc_use_btb
*      then do:
*         if dynamic-function('getTranslateFramesFlag' in h-label) then
*            assign   prt_on_po:label in frame sales-btb
*               = getTermLabel("PRINT_ON_EMT_PO",24).
*         update
*            prt_on_quote
*            prt_on_so
*            prt_on_invoice
*            prt_on_packlist
*            prt_on_po
*         with frame sales-btb.
*      end. /* IF LOOKUP(file_name,"so_mstr,sod_det") ... */
*      else
*         if lookup(file_name,"qo_mstr,qod_det") > 0 or
*            (lookup(file_name,"so_mstr,sod_det") > 0
*            and not soc_use_btb)
*         then do:
*            update
*               prt_on_quote
*               prt_on_so
*               prt_on_invoice
*               prt_on_packlist
*            with frame sales.
*         end. /* IF LOOKUP(file_name,"qo_mstr,qod_det") > 0 */
*         else
*            if lookup(file_name,"po_mstr,pod_det,req_det") > 0
*            then do:
*               update
*                  prt_on_po
*                  prt_on_rct
*                  prt_on_rtv
*               with frame purch.
*            end. /* IF LOOKUP(file_name,"po_mstr,pod_det,req_det") > 0 */
*            else
*               if lookup(file_name,"cs") > 0
*               then do:
*                  update
*                     prt_on_packlist
*                  with frame cust_sched.
*               end. /* IF LOOKUP(file_name,"cs") > 0 */
*               else
*                  if lookup(file_name,"ss") > 0
*                  then do:
*                     update
*                        prt_on_schedule
*                     with frame supp_sched.
*                  end. /* IF LOOKUP(file_name,"ss") > 0 */
*                  else
*                     if lookup(file_name,"abs_mstr") > 0
*                     then do:
*                        update
*                           prt_on_shpr
*                           prt_on_bol
*                        with frame shipper.
*                     end. /* IF LOOKUP(file_name,"abs_mstr") > 0 */
*                     else
*                        if lookup(file_name,"dss_mstr") > 0
*                        then do:
*                           update
*                              prt_on_do
*                              prt_on_packlist
*                           with frame distr.
*                        end. /* IF LOOKUP(file_name,"dss_mstr") > 0 */
*                        else
*                           if lookup(file_name,"dsr_mstr") > 0
*                           then do:
*                              update
*                                 prt_on_isrqst
*                              with frame isite.
*                           end. /* IF LOOKUP(file_name,"dsr_mstr") > 0 */
*                           else
*                              if lookup(file_name,"ds_det") > 0
*                              then do:
*                                 update
*                                    prt_on_do
*                                    prt_on_packlist
*                                 with frame distr.
*                              end. /* IF LOOKUP(file_name,"ds_det") > 0 */
*                              else
*                                 if lookup(file_name,"ca_mstr2") > 0
*                                 then do:
*                                    update
*                                       prt_on_intern
*                                       prt_on_po
*                                    with frame paocmmt.
*                                 end.
*                                 else
*                                    if lookup(file_name,"ins_mstr") > 0
*                                    then do:
*                                       update
*                                          prt_on_invoice
*                                       with frame instype.
*                                    end.
*                                    else
*                                       if lookup(file_name,"pjd_det") > 0
*                                       then do:
*                                          update
*                                             prt_on_cus
*                                             prt_on_invoice
*                                             prt_on_intern
*                                          with frame pjdtype.
*                                       end.
*                                       else
*                                          if lookup(file_name,"ca_mstr") > 0
*                                          then do:
*                                             update
*                                                prt_on_intern
*                                             with frame calls.
*                                          end. /* IF LOOKUP(file_name,"ca_mstr") > 0 */
*                                          else
*                                             if lookup(file_name,"pjt_mstr,prj_mstr,pjs_mstr") > 0
*                                             then do:
*                                                update
*                                                   prt_on_cus
*                                                   prt_on_invoice
*                                                   prt_on_intern
*                                                   prt_on_po
*                                                with frame projtype.
*                                             end.
*
*      /* ASSIGN THE TRANSACTION COMMENT PRINT SETTING BASED ON PRINT OPTIONS */
*      {pxrun.i &PROC='setPrintOptions' &PROGRAM='gpcmxr.p'
*            &PARAM="(input prt_on_quote,
*                     input prt_on_so,
*                     input prt_on_invoice,
*                     input prt_on_packlist,
*                     input prt_on_po,
*                     input prt_on_rct,
*                     input prt_on_rtv,
*                     input prt_on_schedule,
*                     input prt_on_shpr,
*                     input prt_on_bol,
*                     input prt_on_do,
*                     input prt_on_isrqst,
*                     input prt_on_cus,
*                     input prt_on_intern,
*                     output cmt_print)"
*            &NOAPPERROR=True
*            &CATCHERROR=True}
*/
/* ss 20071224 - e */
end. /* repeat with frame cmmt01 */

hide frame cmmt01.
hide frame sales.
hide frame sales-btb.
hide frame purch.
hide frame cust_sched.
hide frame supp_sched.
hide frame distr.
hide frame isite.
hide frame shipper.
hide frame calls.
hide frame paocmmt.
hide frame projtype.
hide frame pjdtype.
hide frame instype.
end.  /* if c-application-mode <> "API" */
else if c-application-mode = "API" then do:

   /* Because each transaction comment is made up of a
   variable number of pages of free-form text that may
   include pre-defined master comments, as opposed
   to a single record of data elements, the operations
   'add', 'modify', 'remove' and 'sync' behave somewhat
   differently than with other types of temp-tables.
   In particular, multiple pages of text may be inserted
   before existing pages of comments, depending on the
   values of other input fields within the temp-table.

   Conditions*
   -----------
   1   2   3   4    Action
   --- --- --- ---   ------
   Add No  No  No  : Add new (blank) page
   Add No  No  Yes : Add new page with new comment text
   Add No  Yes No  : Add new page, copy master comment
                     page, copy all master comment pages
                     if masterCmtSeq = ?
   Add No  Yes Yes : Add new page with new comment text,
                     ignore master comment
   Add Yes No  No  : Insert new (blank) page
   Add Yes No  Yes : Insert new page with new comment text
   Add Yes Yes No  : Insert new page, copy master comment
                     page, copy all master comment pages
                     if masterCmtSeq = ?
   Add Yes Yes Yes : Insert new page with new comment text,
                     ignore master comment
   Mod Yes No  No  : Set present text to null
   Mod Yes No  Yes : Replace present text with new comment
                     text, inserting pages if needed
   Mod Yes Yes No  : Replace present text with master
                     comment, inserting pages if needed
   Mod Yes Yes Yes : Replace present text with new comment
                     text, ignore master comment
   Mod No   -   -  : Raise error
   Syn No   -   -  : Same as Add actions
   Syn Yes  -   -  : Same as Modify actions
   Rem No   -   -  : Raise warning
   Rem Yes  -   -  : Delete page

   *Condition key:
   1 = operation value: Add, Modify, Remove, Sync
   2 = Does a transaction comment already exist for the
       input seq value?
   3 = Does a master comment exist for the input values of
       masterCmtSeq, ref, and lang?
   4 = Is new comment text provided in the API call?

   Unknown ttTransComment.seq values are handled as follows:

      If the operation provided is "Remove", all transaction
      comments are removed.

      If a MFG/PRO database record already contains a comment
      with an unknown seq number and matching temp-table record
      keys an exception is raised.

      If the operation provided is "Add,Modify,Sync" the next
      available seq number is calculated and used.

   */

   /* The list of entry's in validCmtPrintList identify documents
   whose status regarding whether to print the comments can be
   changed given the input parameter "file_name".
   */
   if lookup(file_name,"so_mstr,sod_det") > 0 and soc_use_btb then do:
      validCmtPrintList = "QO,SO,IN,PA,PO".
   end.
   else if
      lookup(file_name,"qo_mstr,qod_det") > 0
      or (     lookup(file_name,"so_mstr,sod_det") > 0
      and not soc_use_btb
      )
   then do:
      validCmtPrintList = "QO,SO,IN,PA".
   end.
   else if lookup(file_name,"po_mstr,pod_det,req_det") > 0 then do:
      validCmtPrintList = "PO,RC,RV".
   end.
   else if lookup(file_name,"cs") > 0 then do:
      validCmtPrintList = "PA".
   end.
   else if lookup(file_name,"ss") > 0 then do:
      validCmtPrintList = "SC".
   end.
   else if lookup(file_name,"abs_mstr") > 0 then do:
      validCmtPrintList = "SH,BL".
   end.
   else if lookup(file_name,"dss_mstr") > 0 then do:
      validCmtPrintList = "DO,PA".
   end.
   else if lookup(file_name,"dsr_mstr") > 0 then do:
      validCmtPrintList = "IS".
   end.
   else if lookup(file_name,"ds_det") > 0 then do:
      validCmtPrintList = "DO,PA".
   end.
   else if lookup(file_name,"ca_mstr") > 0 then do:
      validCmtPrintList = "CS,IT".
   end.

   repeat:
      if retry then return error.

      find next ttTransComment
         no-error.

      if not available ttTransComment then return.

      if    ttTransComment.operation <> {&ADD}
         and ttTransComment.operation <> {&MODIFY}
         and ttTransComment.operation <> {&REMOVE}
         and ttTransComment.operation <> {&SYNC}
      then do:
         /* Invalid operation in record # of # */

         {pxmsg.i
            &MSGNUM = 4667
            &ERRORLEVEL = 3
            &MSGARG1 = string(ttTransComment.apiSequence)
            &MSGARG2 = ApiContextString
            }
         return error.
      end.

      for first cmt_det
          where cmt_det.cmt_domain = global_domain and  cmt_indx = cmtindx
         and   cmt_seq  = ttTransComment.seq - 1
      exclusive-lock:
      end.

      if ttTransComment.operation = {&REMOVE} then do:
         if available cmt_det then do:
            delete cmt_det.
         end.
         else if ttTransComment.seq = ? then do:

            for first cmt_det
                where cmt_det.cmt_domain = global_domain and  cmt_indx = cmtindx
            no-lock:
            end.

            if available cmt_det then do:
               for each cmt_det
                      where cmt_det.cmt_domain = global_domain and  cmt_indx =
                      cmtindx
                  exclusive-lock:
                  delete cmt_det.
               end.
            end.
            else do:
               /* No record # of # available in database */

               {pxmsg.i
                  &MSGNUM = 4669
                  &ERRORLEVEL = 2
                  &MSGARG1 = string(ttTransComment.apiSequence)
                  &MSGARG2 = ApiContextString
                  }
            end.
         end.
         else do:
            /* No record # of # available in database */

            {pxmsg.i
               &MSGNUM = 4669
               &ERRORLEVEL = 2
               &MSGARG1 = string(ttTransComment.apiSequence)
               &MSGARG2 = ApiContextString
               }
         end.
      end.
      else
      if
         ttTransComment.seq = ?
         and available cmt_det
      then do:
         /* Record # of # cannot modify unknown comment page */

         {pxmsg.i
            &MSGNUM = 4807
            &ERRORLEVEL = 3
            &MSGARG1 = string(ttTransComment.apiSequence)
            &MSGARG2 = ApiContextString
            }
         return error.
      end.
      else
      if
         ttTransComment.operation = {&MODIFY}
         and not available cmt_det
      then do:
         /* No record # of # available in database */

         {pxmsg.i
            &MSGNUM = 4669
            &ERRORLEVEL = 3
            &MSGARG1 = string(ttTransComment.apiSequence)
            &MSGARG2 = ApiContextString
            }
         return error.
      end.

      else
      if
         ttTransComment.lang <> ?
         and not validLang(ttTransComment.lang)
      then do:
         /* Invalid # value in record # of # temp-table */

         {pxmsg.i
            &MSGNUM = 4664
            &ERRORLEVEL = 3
            &MSGARG1 = getTermLabel(""LANGUAGE"",12)
            &MSGARG2 = string(ttTransComment.apiSequence)
            &MSGARG3 = ApiContextString
            }
         return error.
      end.

      else
      if
         (ttTransComment.type <> ?
         and not validType(ttTransComment.type))
         or
         (ttTransComment.type = ?
         and not validType(""))
      then do:
         /* Invalid # value in record # of # temp-table */
         {pxmsg.i &MSGNUM = 4664 &ERRORLEVEL = 3
            &MSGARG1 = getTermLabel(""TYPE"",8)
            &MSGARG2 = string(ttTransComment.apiSequence)
            &MSGARG3 = ApiContextString
            }
         return error.
      end.

      else do:

         /* When not defaulting to the existing print value
         validate that each entry provided in ttTransComment.print
         is in validCmtPrintList
         */
         if ttTransComment.print <> ?
            and ttTransComment.print <> ""
         then do:
            do i = 1 to num-entries(ttTransComment.print):
               if lookup(entry(i,ttTransComment.print),
                  validCmtPrintList
                  ) = 0
               then do:
                  /* Invalid # value in record # of # temp-table */

                  {pxmsg.i
                     &MSGNUM = 4664
                     &ERRORLEVEL = 3
                     &MSGARG1 = getTermLabel(""PRINT_CONTROL"",15)
                     &MSGARG2 = string(ttTransComment.apiSequence)
                     &MSGARG3 = ApiContextString
                     }
                  return error.
               end.
            end.
         end.

         if ttTransComment.operation = {&ADD}
            or (ttTransComment.operation = {&SYNC}
            and not available cmt_det
            )
         then
            assign createTransComment = yes
               cmtPrint = ",QO,SO,IN,PA,PO,SH,BL,DO".
               /* These are default MFG/PRO print list for new records */
         else
            assign createTransComment = no
               cmtPrint = cmt_print.

         /* When not defaulting to the existing print value
         perform any required add or removes to the print list
         "cmtPrint" by examining each entry provided in
         ttTransComment.print.
         */
         if ttTransComment.print <> ? then do:

            /* Add entries in ttTransComment.print to cmtPrint */
            do i = 1 to num-entries(ttTransComment.print):
               if lookup(entry(i,ttTransComment.print),cmtPrint) = 0
               then
                  cmtPrint =   cmtPrint
                             + ","
                             + entry(i,ttTransComment.print).
            end.

            /* Remove entries from cmtPrint that are not in
            ttTransComment.print
            */
            do i = 1 to num-entries(validCmtPrintList):

               validPrintEntry = entry(i,validCmtPrintList).

               if lookup(validPrintEntry,ttTransComment.print) = 0
                  and lookup(validPrintEntry,cmtPrint) <> 0
               then
                  cmtPrint = replace(cmtPrint,
                                     "," + validPrintEntry,
                                     ""
                                    ).
            end.
         end. /* ttTransComment.print <> ? */

         /* Determine if any actual comment text was provided */
         commentTextProvided = no.
         do i = 1 to 15:
            if ttTransComment.cmmt[i] <> ""
               and ttTransComment.cmmt[i] <> ?
            then do:
               commentTextProvided = yes.
               leave.
            end.
         end.

         /* Calculate the number of master comment pages */
         masterCommentPageCount = 0.
         if commentTextProvided = no then do:

            if ttTransComment.masterCmtSeq <> ? then do:

               for first cd_det
                   where cd_det.cd_domain = global_domain and  cd_ref  =
                   ttTransComment.ref
                  and   cd_type = ttTransComment.type
                  and   cd_lang = ttTransComment.lang
                  and   cd_seq  = ttTransComment.masterCmtSeq - 1
               no-lock:
               end.

               if available cd_det then
                  masterCommentPageCount = 1.
            end.
            else do:
               for each cd_det
                      where cd_det.cd_domain = global_domain and  cd_ref  =
                      ttTransComment.ref
                     and   cd_type = ttTransComment.type
                     and   cd_lang = ttTransComment.lang
                  no-lock:
                  masterCommentPageCount = masterCommentPageCount + 1.
               end.
            end.
         end. /* commentTextProvided = no */

         /* Calculate how much to renumber comment pages by
         Also determine page number to use when creating a
         new page.
         */

         renumberIncrement = 0.
         if ttTransComment.seq <> ? then do:

            /* Page number to use when creating a new page */
            newPageNumber = ttTransComment.seq - 1.

            if ttTransComment.operation = {&ADD}
               and available cmt_det
            then do:

               if masterCommentPageCount = 0 then
                  renumberIncrement = 1.
               else
                  renumberIncrement = masterCommentPageCount.

            end.
            else if masterCommentPageCount <> 0 then do:

               for first cmt_det
                   where cmt_det.cmt_domain = global_domain and  cmt_indx =
                   cmtindx
                  and   cmt_seq  > ttTransComment.seq - 1
               no-lock:
               end.

               if available cmt_det
                  and cmt_seq = ?
               then do:
                  for first cmt_det
                      where cmt_det.cmt_domain = global_domain and  cmt_indx =
                      cmtindx
                     and   cmt_seq  > ttTransComment.seq - 1
                     and   cmt_seq  <> ?
                  no-lock:
                  end.
               end.

               if available cmt_det then
                  renumberIncrement =   masterCommentPageCount
                  - (   cmt_seq
                  - ( ttTransComment.seq - 1)
                  ).

            end. /* else if masterCommentPageCount <> 0 */
         end. /* ttTransComment.seq <> ? */
         else do:
            find last cmt_det
                where cmt_det.cmt_domain = global_domain and  cmt_indx = cmtindx
            no-lock no-error.
            if available cmt_det then do:
               /* Page number to use when creating a new page */
               newPageNumber = cmt_seq + 1.
            end.
            else do:
               /* Page number to use when creating a new page */
               newPageNumber = 0.
            end.
         end.

         /* Renumber comment pages when necessary */
         if renumberIncrement > 0 then do:
            if createTransComment then do:
               cmtSeq = ttTransComment.seq - 1.
            end.
            else do:
               cmtSeq = ttTransComment.seq.
            end.

            for each cmt_det
                   where cmt_det.cmt_domain = global_domain and  cmt_indx =
                   cmtindx
                  and   cmt_seq >= cmtSeq
               exclusive-lock
                  break by cmt_seq descending:
               cmt_seq =   cmt_seq
               + renumberIncrement.
            end.
         end. /* renumberIncrement > 0 */

         if commentTextProvided
            or masterCommentPageCount = 0
         then do:

            if createTransComment then do:
               create cmt_det. cmt_det.cmt_domain = global_domain.

               if cmtindx = 0 then do:
                  {mfrnseq.i cmt_det cmt_det.cmt_indx cmt_sq01}
                  cmtindx = cmt_indx.
               end.

               assign cmt_indx = cmtindx
                  cmt_seq  = newPageNumber.

               if recid(cmt_det) = -1 then.
            end.

            assign {mfaiset.i cmt_ref  ttTransComment.ref}
               {mfaiset.i cmt_type ttTransComment.type}
               {mfaiset.i cmt_lang ttTransComment.lang global_lang}
               cmt_print = cmtPrint.

            do i = 1 to 15:
               if ttTransComment.cmmt[i] <> ? then
                  cmt_cmmt[i] = ttTransComment.cmmt[i].
            end.

         end. /* if commentTextProvided or etc. */
         else do:

            /* Create tranaction comments by copying master comments */

            for each cd_det
                   where cd_det.cd_domain = global_domain and (  cd_ref  =
                   ttTransComment.ref
                  and   cd_type = ttTransComment.type
                  and   cd_lang = ttTransComment.lang
                  and   (    ttTransComment.masterCmtSeq - 1 = cd_seq
                  or ttTransComment.masterCmtSeq = ?
                  )
               ) no-lock
                  break by cd_seq:

               if createTransComment then do:
                  create cmt_det. cmt_det.cmt_domain = global_domain.

                  if cmtindx = 0 then do:
                     {mfrnseq.i cmt_det cmt_det.cmt_indx cmt_sq01}
                     cmtindx = cmt_indx.
                  end.

                  assign cmt_indx = cmtindx
                     cmt_seq  = newPageNumber.

                  if recid(cmt_det) = -1 then.
               end.
               else do:

                  for first cmt_det
                      where cmt_det.cmt_domain = global_domain and  cmt_indx =
                      cmtindx
                     and   cmt_seq  = ttTransComment.seq - 1
                  exclusive-lock:
                  end.

                  createTransComment = yes.
               end.

               assign cmt_ref       = ttTransComment.ref
                  cmt_type      = ttTransComment.type
                  cmt_lang      = ttTransComment.lang
                  cmt_print     = cmtPrint
                  newPageNumber = newPageNumber + 1.

               do i = 1 to 15:
                  cmt_cmmt[i] = cd_cmmt[i].
               end.

            end. /* for each cd_det */
         end. /* else do -> commentTextProvided or etc. */
      end. /* else do -> ttTransComment.operation = {&REMOVE} */
   end. /* repeat */
end.  /* else if c-application-mode = "API" */
