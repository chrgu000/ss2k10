/* GUI CONVERTED from adcsbkmt.p (converter v1.78) Tue Jan 31 02:18:28 2006 */
/* adcsbkmt.p - CUSTOMER/SUPPLIER BANK MAINTENANCE                      */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* REVISION: 7.4      LAST MODIFIED: 10/07/93   BY: JJS *H181*          */
/* REVISION: 7.4      LAST MODIFIED: 04/11/94   BY: JJS *H286*          */
/* REVISION: 7.4      LAST MODIFIED: 09/07/94   BY: bcm *H506*          */
/* REVISION: 7.4      LAST MODIFIED: 10/10/94   BY: bcm *H560*          */
/* REVISION: 7.4      LAST MODIFIED: 02/23/95   BY  jzw *H0BM*          */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY  dxk *H0C9*          */
/* REVISION: 7.4      LAST MODIFIED: 04/19/96   BY  rxm *G 1 L 3*       */
/* REVISION: 8.5      LAST MODIFIED: 07/17/97   BY: *J1VT* Suresh Nayak */
/* REVISION: 7.4      LAST MODIFIED: 12/29/97   BY: *H1HR* Jean Miller  */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 01/10/00   BY: *N073* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9.1.6     BY: Katie Hilbert       DATE: 04/01/01  ECO: *P002*  */
/* Revision: 1.9.1.7  BY: Katie Hilbert          DATE: 05/15/02  ECO: *P06N*  */
/* Revision: 1.9.1.9  BY: Paul Donnelly (SB)     DATE: 06/26/03  ECO: *Q00B*  */
/* Revision: 1.9.1.10 BY: Deepali Kotavadekar    DATE: 11/12/03  ECO: *P17S*  */
/* $Revision: 1.9.1.11 $       BY: Tejasvi Kulkarni       DATE: 01/31/06  ECO: *P4GV*  */
/*-Revision end---------------------------------------------------------------*/
/*V8:ConvertMode=Maintenance                                                  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* J1VT HAS MODIFIED THE G1L3 MODIFICATION COMMENT LINE BY              */
/* CHANGING THE PATCH MARKER FROM G1L3 TO G 1 L 3 DUE TO                */
/* PROBLEMS DURING SUBMISSION                                           */

{mfdtitle.i "1+ "}

define variable del-yn like mfc_logical.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/

   ad_addr        colon 10 label "Bank"
   ad_name        colon 10
   ad_line1       colon 10
   ad_line2       colon 10
   ad_line3       colon 10
   ad_city        colon 10
   ad_state
   ad_zip
   ad_format
   ad_country     colon 10  ad_ctry no-label
   ad_county      colon 56
   ad_attn        colon 10
   ad_attn2       label "[2]" colon 43
   ad_phone       colon 10
   ad_ext
   ad_phone2      label "[2]" colon 43
   ad_ext2
   ad_fax         colon 10
   ad_fax2        label "[2]" colon 43
   ad_date
 SKIP(.4)  /*GUI*/
with frame a 
   side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = (getFrameTitle("BANK_ADDRESS",19)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
ad_sort     colon 18
   ad_gst_id   colon 18
   ad_pst_id   colon 18
   ad_vat_reg  colon 18
 SKIP(.4)  /*GUI*/
with frame b side-labels width 80  attr-space
    NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER.
 F-b-title = (getFrameTitle("TAX_IDS",23)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame b =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame b + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5. /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/* DEFINE STREAMS FOR AUDIT TRAIL */
{gpaud.i &uniq_num1 = 01
         &uniq_num2 = 02
         &db_file = ad_mstr
         &db_field = ad_addr}

mainloop:
repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

   innerloop:
   repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

      do with frame a on endkey undo, leave mainloop:

         prompt-for ad_addr
         editing:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp01.i ad_mstr ad_addr ad_addr
               """c/s_bank"""  " ad_mstr.ad_domain = global_domain and ad_type
               "  ad_type}
            if recno <> ? then do:
               display
                  ad_addr
                  ad_name
                  ad_line1
                  ad_line2
                  ad_line3
                  ad_city
                  ad_state
                  ad_zip
                  ad_format
                  ad_country
                  ad_ctry
                  ad_county
                  ad_attn
                  ad_attn2
                  ad_phone
                  ad_ext
                  ad_phone2
                  ad_ext2
                  ad_fax
                  ad_fax2
                  ad_date.

               display
                  ad_sort
                  ad_gst_id
                  ad_pst_id
                  ad_vat_reg
               with frame b.
            end.  /* if recno */
         end.  /* prompt-for ad_addr */
      end.  /* do with frame a*/

      if input ad_addr = "" then do:
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}  /* BLANK NOT ALLOWED */
         next-prompt ad_addr with frame a.
         undo innerloop, retry.
      end. /* if input ad_addr = "" then do: */

      /* DON'T ALLOW OTHER TYPES OF ADDRESS */
      /* MASTERS TO ALSO BE C/S_BANKS       */
find ad_mstr using  ad_addr where ad_mstr.ad_domain = global_domain  no-lock
no-error.
      if available ad_mstr and ad_type <> "c/s_bank" then do:
         {pxmsg.i &MSGNUM=1219 &ERRORLEVEL=3}  /* NOT A VALID CUSTOMER/SUPPLIER BANK */
         next-prompt ad_addr with frame a.
         undo innerloop, retry.
      end. /* if available ad_mstr and ad_type <> "c/s_bank" then do: */

      do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

         find ad_mstr using ad_addr  where ad_mstr.ad_domain = global_domain
         and  ad_type = "c/s_bank"
            no-error.
         if not available ad_mstr then do:
            find first adc_ctrl  where adc_ctrl.adc_domain = global_domain
            no-lock no-error.
            if not available adc_ctrl then do:  create adc_ctrl.
            adc_ctrl.adc_domain = global_domain. end.
            create ad_mstr. ad_mstr.ad_domain = global_domain.
            assign
               ad_addr = input ad_addr
               ad_type = "c/s_bank"
               ad_date = today
               ad_format = adc_format.

            find ls_mstr  where ls_mstr.ls_domain = global_domain and  ls_addr
            = ad_addr
               and ls_type = "c/s_bank"
               no-lock no-error.
            if not available ls_mstr then do:
               create ls_mstr. ls_mstr.ls_domain = global_domain.
               assign
                  ls_addr = ad_addr
                  ls_type = "c/s_bank".
            end. /* if not available ls_mstr */
         end. /* if not available ad_mstr */

         /* WRITE OUT AUDIT TRAIL FILE BEFORE UPDATES OCCUR */
         {gpaud1.i &uniq_num1 = 01
                   &uniq_num2 = 02
                   &db_file  = ad_mstr}

         assign
            ad_mod_date = today
            ad_userid = global_userid
            recno = recid(ad_mstr)
            del-yn = false
            /* SET STATUS LINE TO SHOW F5 FOR DELETE */
            ststatus = stline[2].

         status input ststatus.
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* do transaction */

      display
         ad_addr
         ad_name
         ad_line1
         ad_line2
         ad_line3
         ad_city
         ad_state
         ad_zip
         ad_format
         ad_country
         ad_ctry
         ad_county
         ad_attn
         ad_attn2
         ad_phone
         ad_ext
         ad_phone2
         ad_ext2
         ad_fax
         ad_fax2
         ad_date
      with frame a.

      display
         ad_sort
         ad_gst_id
         ad_pst_id
         ad_vat_reg
      with frame b.

      seta:
      do transaction on error undo, retry
            on endkey undo seta, leave innerloop:
/*GUI*/ if global-beam-me-up then undo, leave.

         set
            ad_name
            ad_line1
            ad_line2
            ad_line3
            ad_city
            ad_state
            ad_zip
            ad_format
            ad_ctry
            ad_county
            ad_attn
            ad_attn2
            ad_phone
            ad_ext
            ad_phone2
            ad_ext2
            ad_fax
            ad_fax2
            ad_date
            go-on("F5" "CTRL-D") with frame a.

         if lastkey = keycode("F5") or lastkey = keycode ("CTRL-D")
         then do:
            del-yn = true.
            /* PLEASE CONFIRM DELETE */
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
            if not del-yn then next mainloop.

            /* THE NEXT TWO LINES ARE PART OF  ECO G 1 L 3. HOWEVER */
            /* DUE TO PROBLEMS DURING SUBMISSION, THE PATCH MARKER  */
            /* HAS BEEN CHANGED FROM G 1 L 3 TO J1VT                */
            /* DELETE EDI SHIP IDs FOR THIS ADDRESS */
            {gprun.i ""gpsfiddl.p"" "(input ad_addr)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            /* CHECK FOR EXISTING csbd_det BEFORE DELETION ALLOWED */
            if can-find(first csbd_det
                           where csbd_domain = global_domain
                           and   csbd_bank   = ad_addr)
            then do:

               /* CANNOT DELETE. BANK ATTACHED TO ATLEAST ONE CUSTOMER */
               /* /SUPPLIER                                            */
               {pxmsg.i &MSGNUM=6400 &ERRORLEVEL=3}

               next-prompt ad_addr with frame a.
               undo innerloop, retry innerloop.

            end. /* IF CAN-FIND(FIRST csbd_det... */

            for first ls_mstr
               fields (ls_domain ls_addr ls_type)
               where ls_domain = global_domain
               and   ls_addr   = ad_addr
               and   ls_type   = "c/s_bank"
               exclusive-lock:

               delete ls_mstr.

            end. /* FOR FIRST ls_mstr */

            delete ad_mstr.
            clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
            clear frame b.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
            leave innerloop.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* if F5 or CTRL-D */

         /* VALIDATE FORMAT CODE */
         if ad_format <> 0 then do:
            find first code_mstr  where code_mstr.code_domain = global_domain
            and  code_fldname = "ad_format"
               and code_value = string(ad_format)
               no-lock no-error.
            if not available code_mstr then do:
               /* VALUE MUST EXIST IN GENERALIZED CODES */
               {pxmsg.i &MSGNUM=716 &ERRORLEVEL=4}
               next-prompt ad_format with frame a.
               undo seta, retry.
            end. /* if not available code_mstr then do: */
         end. /* if ad_format <> 0 */

         /* VALIDATE COUNTRY CODE */

         if not {gpctry.v ad_ctry ""no""} then do:

            {pxmsg.i &MSGNUM=861 &ERRORLEVEL=3} /* COUNTRY CODE DOES NOT EXIST */
            next-prompt ad_ctry with frame a.
            undo seta, retry.
         end. /* if not {gpctry.v ad_ctry ""no""} then do: */
         else do:
            find ctry_mstr where ctry_ctry_code = ad_ctry
               no-lock no-error.
            if available ctry_mstr then do:
               ad_country = ctry_country.
               display ad_country with frame a.
            end. /* if available ctry_mstr then do: */
         end. /* else do: */

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* seta */

      /* SET STATUS LINE SO F5, F9, AND F10 DO NOT SHOW */
      ststatus = stline[3].
      status input ststatus.

      setb:
      do transaction on error undo, retry
            on endkey undo setb, leave innerloop:
/*GUI*/ if global-beam-me-up then undo, leave.

         if ad_sort = "" then do:
            ad_sort = ad_name.
            display ad_sort with frame b.
         end. /* if ad_sort = "" then do: */

         set
            ad_sort
            ad_gst_id
            ad_pst_id
            ad_vat_reg
         with frame b.

         /* BLANK SORT NAME NOT ALLOWED; */
         /* IT IS NEEDED FOR REPORTS.    */
         if ad_sort = "" then do:
            ad_sort = ad_name.
            display ad_sort with frame b.
         end. /* if ad_sort = "" then do: */
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* setb */

      /* PROCESSING ENDED NORMALLY */
      leave innerloop.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* innerloop */

   /* COMPARE ORIGINAL AND CURRENT FILES */
   /* CREATE AUDIT TRIAL FOR FIELDS THAT */
   /* HAVE BEEN MODIFIED                  */
   {gpaud2.i &uniq_num1 = 01
             &uniq_num2 = 02
             &db_file = ad_mstr
             &db_field = ad_addr
             &db_field1 = """"}

end.  /* mainloop */

/* DELETE TEMPORARY FILES USED FOR AUDIT TRAIL */
{gpaud3.i &uniq_num1 = 01
          &uniq_num2 = 02
          &db_file = ad_mstr
          &db_field = ad_addr}