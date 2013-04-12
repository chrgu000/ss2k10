/* GUI CONVERTED from adcsbkmt.p (converter v1.69) Thu Jul 17 14:03:54 1997 */
/* adcsbkmt.p - CUSTOMER/SUPPLIER BANK MAINTENANCE                      */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.4      LAST MODIFIED: 10/07/93   BY: JJS *H181*          */
/* REVISION: 7.4      LAST MODIFIED: 04/11/94   BY: JJS *H286*          */
/* REVISION: 7.4      LAST MODIFIED: 09/07/94   BY: bcm *H506*          */
/* REVISION: 7.4      LAST MODIFIED: 10/10/94   BY: bcm *H560*          */
/* REVISION: 7.4      LAST MODIFIED: 02/23/95   BY  jzw *H0BM*          */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY  dxk *H0C9*          */
/* REVISION: 7.4      LAST MODIFIED: 04/19/96   BY  rxm *G 1 L 3*       */
/* REVISION: 8.5      LAST MODIFIED: 07/17/97   BY: *J1VT* Suresh Nayak */

/*J1VT*/ /* J1VT HAS MODIFIED THE G1L3 MODIFICATION COMMENT LINE BY     */
/*J1VT*/ /* CHANGING THE PATCH MARKER FROM G1L3 TO G 1 L 3 DUE TO       */
/*J1VT*/ /* PROBLEMS DURING SUBMISSION                                  */

{mfdtitle.i "121020.1"}

   define variable del-yn like mfc_logical.
/*H506*/ define variable ec_ok  like mfc_logical.

  define variable custname like ad_name. /*lb01*/
  DEFINE VARIABLE vmsg as character.
  define variable gtcode like ad_addr. /*lb01*/

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/

 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/

/*H560*/    ad_addr        colon 10 label "金税代码"
      ad__chr01   colon 30  label "票据开往" custname no-label
/*H560**    ad_addr        colon 10 **/
      ad_name        colon 10  label "客户名称"

      ad_line1       colon 10  no-label
      ad_line2       colon 10  label "注册地址"
      ad_line3       colon 10  no-label
  /*    ad_city        colon 10
      ad_state
      ad_zip
      ad_format  */
/*judy*/    /*ad_user1*/
/*judy*/ ad_user1 colon 10  view-as fill-in size 40 by 1
                  label "开户行" format "x(120)" /* ad_ctry no-label */
/*      ad_county      colon 10
      ad_attn        colon 10  */
/*      ad_attn2       label "[2]" colon 43 */
      ad_phone       colon 10 label "电话"
      ad_ext      label "分机"
  /*    ad_phone2      label "[2]" colon 43
      ad_ext2
      ad_fax         colon 10
      ad_fax2        label "[2]" colon 43
      ad_date */
/*H0C9   with frame a title color normal " Customer/Supplier Bank Address "  */
/*H0C9*/  SKIP(.4)  /*GUI*/
with frame a
   side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " 银行地址 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



   FORM /*GUI*/

 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
ad_sort   label "排序名"  colon 18   skip(1)
      ad_gst_id   colon 18  label "税号" /*ad_edi_std     colon 60
      ad_pst_id   colon 18   ad_edi_level   colon 60
      ad_vat_reg  colon 18   ad_edi_id      colon 52 */
           ad_edi_tpid    colon 18 label "账号" format "x(35)"
    SKIP(.4)  /*GUI*/
with frame b side-labels width 80 attr-space
/*J1VT*/ /* THE NEXT TWO LINES ARE PART OF THE ECO G 1 L 3. HOWEVER DUE TO   */
/*J1VT*/ /* PROBLEMS DURING SUBMISSION, THE PATCH MARKER HAS BEEN CHANGED    */
/*J1VT*/ /* FROM G 1 L 3 TO J1VT                                             */
/*J1VT   title color normal " Tax IDs and EDI ". */
/*J1VT*/  NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER.
 F-b-title = " 税标志及电子数据交换 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame b =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame b + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5. /*GUI*/



/*H506*/ /* CHECK IF INTRA-EC IS INSATLLED  */
/*H506 {gprun.i ""txecck.p"" "( output ec_ok)" }   */
/*GUI*/ if global-beam-me-up then undo, leave.


   /* DEFINE STREAMS FOR AUDIT TRAIL */
   {gpaud.i &uniq_num1 = 01
      &uniq_num2 = 02
      &db_file = ad_mstr
      &db_field = ad_addr}

   mainloop: repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

      innerloop: repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

         do with frame a on endkey undo, leave mainloop:
      prompt-for ad_addr editing:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp01.i ad_mstr ad_addr " ad_domain = global_domain and ad_addr "
       """c/s_bank""" ad_type ad_type}
         if recno <> ? then do:
          find first cm_mstr no-lock where cm_domain = global_domain and
                     cm_addr = input ad__chr01 no-error.
          if available cm_mstr then do:
            display cm_sort @ custname with frame a.
          end.

      display ad_addr ad__chr01
        ad_name
        ad_line1
        ad_line2
        ad_line3
      /*  ad_city
        ad_state
        ad_zip
        ad_format */
        /*ad_user1*/
        ad_user1    /*judy*/
/*H506*                         ad_ctry when ({txnew.i}) */
/*H506*/                 /*       ad_ctry when ({txnew.i} or ec_ok )
        ad_county
        ad_attn
        ad_attn2 */
        ad_phone
        ad_ext
      /*  ad_phone2
        ad_ext2
        ad_fax
        ad_fax2
        ad_date*/
.
           display ad_sort
             ad_gst_id
          /*   ad_pst_id
             ad_vat_reg
             ad_edi_std
             ad_edi_level
             ad_edi_id */
             ad_edi_tpid
      with frame b.
         end.  /* IF RECNO */
      end.  /* PROMPT-FOR .. EDITING */
         end.  /* DO WITH FRAME A */

         if input ad_addr = "" then do:
      {mfmsg.i 40 3}  /* BLANK NOT ALLOWED */
      next-prompt ad_addr with frame a.
      undo innerloop, retry.
         end.

         /* DON'T ALLOW OTHER TYPES OF ADDRESS */
         /* MASTERS TO ALSO BE C/S_BANKS       */
         find ad_mstr using ad_addr no-lock no-error.
/*H286*/       if available ad_mstr and ad_type <> "c/s_bank" then do:
/*H286*/          {mfmsg.i 1219 3}  /* NOT A VALID CUSTOMER/SUPPLIER BANK */
/*H286*/          next-prompt ad_addr with frame a.
/*H286*/          undo innerloop, retry.
/*H286*/       end.

         do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

/*H286*/   find ad_mstr using ad_addr where ad_domain = global_domain
            and ad_type = "c/s_bank" no-error.
      if not available ad_mstr then do:
         find first adc_ctrl no-lock no-error.
         if not available adc_ctrl then do:
            create adc_ctrl.
                   adc_domain = global_domain .
         end.
         create ad_mstr. ad_domain = global_domain.
         assign ad_addr = input ad_addr
          ad_type = "c/s_bank"
          ad_date = today
          ad_format = adc_format.

/*H286*/    find ls_mstr where ls_domain = global_domain and ls_addr = ad_addr
      and ls_type = "c/s_bank" no-lock no-error.
/*H286*/             if not available ls_mstr then do:
           create ls_mstr. ls_domain = global_domain.
           assign ls_addr = ad_addr
            ls_type = "c/s_bank".
         end.
      end.

      /* WRITE OUT AUDIT TRAIL FILE BEFORE UPDATES OCCUR */
      {gpaud1.i &uniq_num1 = 01
          &uniq_num2 = 02
          &db_file  = ad_mstr}

      ad_mod_date = today.
      ad_userid = global_userid.

      recno = recid(ad_mstr).
      /* SET STATUS LINE TO SHOW F5 FOR DELETE */
      ststatus = stline[2].
      status input ststatus.
      del-yn = false.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* DO TRANSACTION */

         display ad_addr
           ad_name
           ad_line1
           ad_line2
           ad_line3
    /*       ad_city
           ad_state
           ad_zip
           ad_format */
           /*ad_user1*/
               ad_user1    /*judy*/
/*H506*                ad_ctry when ({txnew.i}) */
/*H506*/     /*          ad_ctry when ({txnew.i} or ec_ok)
           ad_county
           ad_attn
           ad_attn2 */
           ad_phone
           ad_ext
     /*      ad_phone2
           ad_ext2
           ad_fax
           ad_fax2
           ad_date */
         with frame a.

         display ad_sort
           ad_gst_id
       /*    ad_pst_id
           ad_vat_reg
           ad_edi_std
           ad_edi_level
           ad_edi_id  */
           ad_edi_tpid
         with frame b.
          find first cm_mstr no-lock where cm_domain = global_domain
                 and cm_addr = ad__chr01 no-error.
          if available cm_mstr then do:
            display cm_sort @ custname with frame a.
          end.


      /*lb01*/
      disp ad__chr01 with frame a.
      set0: do transaction on error undo, retry
        on endkey undo set0, leave innerloop:
/*GUI*/ if global-beam-me-up then undo, leave.

        set ad__chr01 go-on("F5" "CTRL-D") with frame a.
        find first cm_mstr no-lock where cm_domain = global_domain
               and cm_addr = input ad__chr01 no-error.
        if not available cm_mstr then do:
           {pxmsg.i &MSGTEXT=""客户不存在，请重新输入.""
                    &ERRORLEVEL=3}
          next-prompt ad__chr01 with frame a.
          undo set0,retry.
        end.

        {gprun.i ""zzgtgetcode.p"" "(input ad__chr01, output gtcode)"}
        if gtcode <> "" and gtcode <> ad_addr then do:
          assign vmsg="在金税代码" + gtcode + "中维护了该客户，不允许重复维护.".
          {pxmsg.i &MSGTEXT=vmsg
                    &ERRORLEVEL=3}
          next-prompt ad__chr01 with frame a.
          undo set0,retry.
        end.
          display cm_sort @ custname with frame a.
      end.
         seta: do transaction on error undo, retry
            on endkey undo seta, leave innerloop:
/*GUI*/ if global-beam-me-up then undo, leave.

      set ad_name
          ad_line1
          ad_line2
          ad_line3
      /*    ad_city
          ad_state
          ad_zip
          ad_format */
          /*ad_user1   when (not {txnew.i})*/
              ad_user1 /*judy*/
/*H506*               ad_ctry when ({txnew.i}) */
/*H506*/     /*         ad_ctry when ({txnew.i} or ec_ok)
          ad_county
          ad_attn
          ad_attn2 */
          ad_phone
          ad_ext  /*
          ad_phone2
          ad_ext2
          ad_fax
          ad_fax2
          ad_date */
      go-on("F5" "CTRL-D") with frame a.

      if lastkey = keycode("F5") or lastkey = keycode ("CTRL-D")
      then do:
         del-yn = true.
         {mfmsg01.i 11 1 del-yn}  /* CONFIRM DELETE */
         if not del-yn then next mainloop.

/*J1VT*/             /* THE NEXT TWO LINES ARE PART OF  ECO G 1 L 3. HOWEVER */
/*J1VT*/             /* DUE TO PROBLEMS DURING SUBMISSION, THE PATCH MARKER  */
/*J1VT*/             /* HAS BEEN CHANGED FROM G 1 L 3 TO J1VT                */
/*J1VT*/             /* DELETE EDI SHIP IDs FOR THIS ADDRESS */
/*J1VT*/             {gprun.i ""gpsfiddl.p"" "(input ad_addr)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/* CHECK FOR EXISTING CSBD_DET (QAD_WKFL) BEFORE DELETION ALLOWED */
         delete ad_mstr.
         clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
         clear frame b.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
         leave innerloop.
      end.

/*
      /* VALIDATE FORMAT CODE */
      if ad_format <> 0 then do:
         find first code_mstr where code_domain = global_domain
                and code_fldname = "ad_format"
      and code_value = string(ad_format) no-lock no-error.
         if not available code_mstr then do:
      {mfmsg.i 716 4} /* VALUE MUST EXIST
             iN GENERALIZED CODES */
      next-prompt ad_format with frame a.
      undo seta, retry.
         end.
      end.
*/
      /* VALIDATE COUNTRY CODE */
/*H506*           if {txnew.i} then do: */
/*H506*/          if {txnew.i} or ec_ok  then do:
/*J1VT**       if not {gpctry.v ad_ctry ""yes""} then do:        */
/*J1VT*/       if not {gpctry.v ad_ctry ""no""} then do:
/*H0BM*                 {mfmsg03.i 902 3 """Country Code""" """" """"} */
/*H0BM*/                {mfmsg.i 861 3} /* COUNTRY CODE DOES NOT EXIST */
      /* next-prompt ad_ctry with frame a. */
      undo seta, retry.
         end.
         else do:
/*judy*/
      /*find ctry_mstr where ctry_domain = global_domain and ctry_ctry_code = ad_ctry
         no-lock no-error.
      if available ctry_mstr then do:
         ad_user1 = ctry_country.
         display ad_user1 with frame a.
      end.*/
/*judy*/
         end.
      end.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* SETA */

         /* SET STATUS LINE SO F5, F9, AND F10 DO NOT SHOW */
         ststatus = stline[3].
         status input ststatus.

         setb: do transaction on error undo, retry
            on endkey undo setb, leave innerloop.
/*GUI*/ if global-beam-me-up then undo, leave.

      if ad_sort = "" then do:
         ad_sort = ad_name.
         display ad_sort with frame b.
      end.

      set ad_sort
          ad_gst_id /*
          ad_pst_id
          ad_vat_reg
          ad_edi_std
          ad_edi_level
          ad_edi_id */
          ad_edi_tpid
      with frame b.

      /* BLANK SORT NAME NOT ALLOWED; */
      /* IT IS NEEDED FOR REPORTS.    */
      if ad_sort = "" then do:
         ad_sort = ad_name.
         display ad_sort with frame b.
      end.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* SETB */

         /* PROCESSING ENDED NORMALLY */
         leave innerloop.
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* INNERLOOP */

      /* COMPARE ORIGINAL AND CURRENT FILES */
      /* CREATE AUDIT TRIAL FOR FIELDS THAT */
      /* HAVE BEEN MODIFED                  */
      {gpaud2.i &uniq_num1 = 01
          &uniq_num2 = 02
          &db_file = ad_mstr
          &db_field = ad_addr
          &db_field1 = """"}

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* MAINLOOP */

   /* DELETE TEMPORARY FILES USED FOR AUDIT TRAIL */
   {gpaud3.i &uniq_num1 = 01
       &uniq_num2 = 02
       &db_file = ad_mstr
       &db_field = ad_addr}
