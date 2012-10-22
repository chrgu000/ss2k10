/*zzicmlttr2.p for inventory transfer by multiple lines(��Ʒ)��writed by Kevin,2003/12*/
/*zzicmlttr2.p for added lotserial and ref, by kevin*/
/*zzicmlttr2.p  eb2+sp7 retrofit by taofengqin on 2005/06/20 marked *tfq*cj ***********/
         /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*GI32*/ {mfdtitle.i "E"}

def new shared var site_from like si_site.
def new shared var site_to like si_site.
def var locfrom like loc_loc.
def var locto like loc_loc.
def var msg-nbr as inte.
define variable sw_reset like mfc_logical.
def temp-table tr
     field line as inte format ">>9"
     field part like pt_part
     field um like pt_um
     field qty_tr like tr_qty_loc
     field loc_from like tr_loc column-label "������λ" 
     field lot_from like ld_lot format "x(8)" column-label "��/���"          /*kevin for lot/ref*/
     field ref_from like ld_ref column-label "�ο���"           /*kevin for lot/ref*/
     field loc_to like tr_loc column-label "���տ�λ" 
     index trindex line.
def var del-yn as logic.
def var ok_yn as logic.
def var frametitle as char init "Transfer MAINTENACE".
def var trtype as char.
def var bmrecno as recid.

def var nbr like tr_nbr.
def var so_job like tr_so_job.
def var eff_date like tr_effdate.
def var rmks like tr_rmks.

/*cj*/ define variable iss_trnbr like tr_trnbr no-undo.
/*cj*/ define variable rct_trnbr like tr_trnbr no-undo.
/*cj*/ {gldydef.i new}
/*cj*/ {gldynrm.i new}

form
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
   eff_date colon 18          so_job colon 44
   nbr colon 18               rmks colon 44 skip(1)   
    site_from colon 18 label "�����ص�"
    site_to   colon 44 label "����ص�"
   locfrom colon 18 label "����ȱʡ��λ"
   locto colon 44 label "����ȱʡ��λ"
    SKIP(.4)  /*GUI*/
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
/*tfq*/ setFrameLabels(frame a:handle).

view frame a.

/*cj*add*beg*/
FORM
    SKIP(.1)
   tr.LINE
   tr.line format ">>>9" label "Line"
   tr.part
   tr.um
   tr.lot_from 
   tr.ref_from
   tr.qty_tr label "����"
   WITH FRAME e DOWN STREAM-IO .
setFrameLabels(frame e:handle).
/*cj*add*end*/

form
 SKIP(.1)  /*GUI*/
   tr.line format ">>>9" label "Line"
   tr.part
   tr.um
   tr.qty_tr
   tr.loc_from
   tr.lot_from
   tr.ref_from
   tr.loc_to
   skip(.1) 
   with /*down*/ frame c width 90 /*overlay*/ title color normal frametitle THREE-D /*GUI*/.         
/*tfq*/ setFrameLabels(frame c:handle).
eff_date = today.

repeat:
   
   update eff_date so_job nbr rmks site_from site_to locfrom locto with frame a.
   
   find si_mstr no-lock where si_site = site_from no-error.
      if not available si_mstr or
         (si_db <> global_db) then do:
      if not available si_mstr then msg-nbr = 708.
      else msg-nbr = 5421.
      /*tfq {mfmsg.i msg-nbr 3}*/
      {pxmsg.i
               &MSGNUM=msg-nbr
               &ERRORLEVEL=3
             }

      next-prompt site_from with frame a.
      undo, retry.
   end.
   {gprun.i ""gpsiver.p""
     "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/            /*tfq {mfmsg.i 725 3}  */  /* USER DOES NOT HAVE */
/*J034*/           {pxmsg.i
               &MSGNUM=725
               &ERRORLEVEL=3
             }
                     /* ACCESS TO THIS SITE*/
                  next-prompt site_from with frame a.
/*J034*/             undo,retry.
/*J034*/          end.
  

   find si_mstr no-lock where si_site = site_to no-error.
      if not available si_mstr or
         (si_db <> global_db) then do:
      if not available si_mstr then msg-nbr = 708.
      else msg-nbr = 5421.
      /*tfq {mfmsg.i msg-nbr 3}*/
      {pxmsg.i
               &MSGNUM=msg-nbr
               &ERRORLEVEL=3
             }

      next-prompt site_to with frame a.
      undo, retry.
   end.
   {gprun.i ""gpsiver.p""
     "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/          /*tfq   {mfmsg.i 725 3}  */  /* USER DOES NOT HAVE */
/*J034*/           {pxmsg.i
               &MSGNUM=725
               &ERRORLEVEL=3
             }
                     /* ACCESS TO THIS SITE*/
                  next-prompt site_to with frame a.
/*J034*/             undo,retry.
/*J034*/          end.
   
   if locfrom <> "" then do:
       find loc_mstr where loc_site = site_from and loc_loc = locfrom no-lock no-error.
       if not available loc_mstr then do:
           message "��λ������,����������!" view-as alert-box error.
           next-prompt locfrom with frame a.
           undo,retry.
       end.
   end.

   if locto <> "" then do:
       find loc_mstr where loc_site = site_to and loc_loc = locto no-lock no-error.
       if not available loc_mstr then do:
           message "��λ������,����������!" view-as alert-box error.
           next-prompt locto with frame a.
           undo,retry.
       end.
   end.
   
   for each tr:
       delete tr.
   end.
   
   sw_reset = yes.   
   mainloop1:   
            repeat:
/*/*GUI*/ if global-beam-me-up then undo, leave.*/                  /*eyes*/

/*FIND LAST BOM USE-INDEX BOMINDEX. ASSIGN BOM.OPTYPE = "DEL".*/
/*F0PV*/    if not batchrun then do:

               /* {1} = File-name (eg pt_mstr)                    */
               /* {2} = Index to use (eg pt_part)                 */
               /* {3} = Field to select records by (eg pt_part)   */
               /* {4} = Field(s) to display from primary file     */
               /* {5} = Field to highlight (eg pt_part)           */
               /* {6} = Frame name                                */
               /* {7} = Selection Criterion                       */
               /* {8} = Message number for the status line        */
/*G1DT*/       /* {9} = Exclusive lock needed (Y/N)            */

               {mpscrad4.i
                  tr
                  trindex              
                  tr.line
                  "tr.line tr.part um tr.qty_tr tr.loc_from tr.lot_from tr.ref_from tr.loc_to"
                  tr.line
                  c
                  yes
                  8808
                  yes
               }

/*F0PV*/     end.    /* if not batchrun then do */
             
           if keyfunction(lastkey) = "end-error"
            or lastkey = keycode("F4")
            or keyfunction(lastkey) = "."
            or lastkey = keycode("CTRL-E") then do:
               
             /*cj*/ HIDE FRAME c .
             /*cj*/ CLEAR FRAME e ALL NO-PAUSE .
               for each tr no-lock:
                   disp tr /*cj*/ WITH FRAME e .
                   /*cj*/ DOWN 1 WITH FRAME e .
               end.
               ok_yn = no.
               {mfgmsg10.i 12 1 ok_yn}
            
               if not ok_yn then undo mainloop1,leave.
               else if ok_yn then leave.
               if ok_yn = ? then do:
                   sw_reset = yes.
                   undo mainloop1,retry.
               end.
            
            end. /*if keyfunction*/
             
             
               if recno = ?
               and keyfunction(lastkey) <> "insert-mode"
               and keyfunction(lastkey) <> "go"
               and keyfunction(lastkey) <> "return"
               then leave.

               if yes /*keyfunction(lastkey) <> "end-error"*/
               then do on error undo, retry:
/*GUI*/ /*if global-beam-me-up then undo, leave.*/                 /*eyes*/


/*F0PV            repeat*/ do
/*GA32*/          transaction:
/*/*GUI*/ if global-beam-me-up then undo, leave.*/               /*eyes*/

/* 
/*GA32*/             if false then do:                        
/*GA32*/                update tr.line validate (true,"") with frame c.
/*GA32*/             end.
*/

/*GA32*/             if recno = ? then do:
/*GA32*/                create tr.
                        
/*GA32*/                prompt-for tr.line with frame c.
/*GA32*/                delete tr.
/*GA32*/                find first tr where tr.line = input tr.line no-lock no-error.
/*GA32*/                if available tr then do:
/*GA32*/                   recno = recid(tr).
/*GA32*/                end.
/*GA32*/                else do:                           
                           prompt-for tr.part with frame c.                   /*eyes*/
                           find pt_mstr where pt_part = input tr.part no-lock no-error.        /*eyes*/
                           if not available pt_mstr then do:
                              /*tfq  {mfmsg.i 16 3} */
                              {pxmsg.i
               &MSGNUM=16
               &ERRORLEVEL=3
             }

                                undo,retry.
                           end.                           

/*G1ZV*/   if can-find(first isd_det where
/*G1ZV*/              isd_status = string(pt_status,"x(8)") + "#"
/*G1ZV*/              and (isd_tr_type = "iss-tr" or isd_tr_type = "rct-tr")) then do:
/*F089*/     /*tfq {mfmsg02.i 358 3 pt_status} */
                {pxmsg.i
               &MSGNUM=358
               &ERRORLEVEL=3
               &MSGARG1=pt_status
             }

/*F089*/      undo, retry.
/*F089*/   end.

/*GA32*/                   create tr.
/*GA32*/                   assign tr.line = input tr.line.
                           assign tr.part = input tr.part.                   /*eyes*/
                           assign tr.um = pt_um.
                       
                        if locfrom <> "" then do:
                           assign tr.loc_from = locfrom.                  /*kevin*/
                        end.   
                        else do:  
                           find in_mstr where in_site = site_from and in_part = tr.part no-lock no-error.
                          if available in_mstr then assign tr.loc_from = in_user1.
                        end.  

                        if locto <> "" then do:
                             assign tr.loc_to = locto.                       /*kevin*/
                        end.
                        else do:          
                           find in_mstr where in_site = site_to and in_part = tr.part no-lock no-error.
                           if available in_mstr then assign tr.loc_to = in_user1.
                        end.   
                                                  
                           
                    /*                                                      
                           find first ld_det where ld_site = site_from and ld_loc = tr.loc_from
                           and ld_lot = tr.lot_from and ld_ref = tr.ref_from                  /*kevin*/
                           and ld_part = tr.part no-lock no-error.
                           if available ld_det then assign tr.qty_tr = ld_qty_oh.
                       */
                           
                           disp tr.line tr.part tr.um with frame c.
                           
                           /*prompt-for tr.qty_tr with frame c.
                           if input tr.qty_tr = 0 then do:
                                 message "����: ת����������Ϊ��0��!".
                                 undo,retry.
                           end.*/
                           
                           /*assign tr.qty_tr = input tr.qty_tr.*/
                           recno = recid(tr).
/*GA32*/                end.
/*GA32*/             end.

/*F0PV*/             find tr exclusive-lock where recid(tr) = recno.
/*GA32*/             display tr.line tr.part tr.um tr.qty_tr tr.loc_from tr.lot_from tr.ref_from tr.loc_to with frame c.
                     
                     
/*GA32*/             set tr.qty_tr tr.loc_from tr.lot_from tr.ref_from tr.loc_to with frame c editing:
                        ststatus = stline[2].
                        status input ststatus.
                        readkey.
                        /* DELETE */
                        del-yn = no.
                        if lastkey = keycode("F5")
                        or lastkey = keycode("CTRL-D")
                        then do:
                           del-yn = yes.
                        /*tfq   {mfmsg01.i 11 1 del-yn} */
                        {pxmsg.i
               &MSGNUM=11
               &ERRORLEVEL=1
               &CONFIRM=del-yn
             }

                           if del-yn then do:
                              /*delete tr.*/
                              leave.                              
                           end.
                        end.
                        else do:
                           apply lastkey.
                        end.                
                        
                     end. /* editing */
                     
                     if tr.qty_tr = 0 then do:
                                 message "����: ת����������Ϊ��0��!".
                                 undo,retry.
                     end.
                     find loc_mstr where loc_site = site_from and loc_loc = tr.loc_from no-lock no-error.
                     if not available loc_mstr then do:
                              message "����: ��λ" + tr.loc_from + "�ڵص�" + site_from + "������,����������!".
                              undo,retry.
                     end.                     
                     
   /*verify the from_loc, whether the location can do transaction "iss-tr"*/
   find isd_det no-lock
        where isd_tr_type = "iss-tr"
          and isd_status =
          (if available loc_mstr and loc_status <> "" then loc_status
          else si_status) no-error.
   if available isd_det then do:
   {pxmsg.i
               &MSGNUM=373
               &ERRORLEVEL=3
               &MSGARG1="if available loc_mstr then loc_status
         else si_status"
             }

       /*TFQ {mfmsg02.i 373 3
        "if available loc_mstr then loc_status
         else si_status"
                }*/
       next-prompt loc_from with frame c.
       undo, retry.   
   end.
   
                     find loc_mstr where loc_site = site_to and loc_loc = tr.loc_to no-lock no-error.
                     if not available loc_mstr then do:
                              message "����: ��λ" + tr.loc_to + "�ڵص�" + site_to + "������,����������!".
                              undo,retry.
                     end.
   /*verify the loc_to, whether the location can do transaction "rct-tr"*/
   find isd_det no-lock
        where isd_tr_type = "rct-tr"
          and isd_status =
          (if available loc_mstr and loc_status <> "" then loc_status
          else si_status) no-error.
   if available isd_det then do:
      /*TFQ {mfmsg02.i 373 3
        "if available loc_mstr then loc_status
         else si_status"
                } */ 
          {pxmsg.i
               &MSGNUM=373
               &ERRORLEVEL=3
               &MSGARG1="if available loc_mstr then loc_status
         else si_status"
             }
       
       next-prompt loc_to with frame c.
       undo, retry.   
   end.
                     
                     find first ld_det where ld_site = site_from and ld_loc = tr.loc_from and ld_part = tr.part
                     and ld_lot = tr.lot_from and ld_ref = tr.ref_from and ld_qty_oh >= tr.qty_tr no-lock no-error.
                     if not available ld_det then do:
                           message "����: ׼��ת�ƵĿ�治��,����������!".
                           undo,retry.
                     end.
                     
                     if not del-yn then do:                                                                     
                        next mainloop1.
                     end.  
                     else do:                       
                        delete tr.                        
                        clear frame c.
                        next mainloop1.
                     end.
               end. /*do transaction*/               

            end. /*if keyfunction(lastkey)*/
          end. /*mailloop1,repeat*/            
          if not ok_yn then undo,retry.        /*Kevin*/   
/*end. /*repeat*/*/                    /*kevin*/

/*Kevin *****************Modified by iclotr01.p****************************************************************************/
/*F701   define new shared variable site_from like pt_site              */
/*F701          label "From Site" no-undo.                              */
/*F701   define new shared variable loc_from like pt_loc                */
/*F701          label "From Location" no-undo.                          */
/*F701   define new shared variable site_to like pt_site                */
/*F701          label "To Site" no-undo.                                */
/*F701   define new shared variable loc_to like pt_loc                  */
/*F701          label "To Location" no-undo.                            */
     define new shared variable lotserial like sr_lotser no-undo.

     define new shared variable lotserial_qty like sr_qty no-undo.
/*     define new shared variable nbr like tr_nbr label "����" no-undo.*/              /*kevin*/
/*     define new shared variable so_job like tr_so_job no-undo.*/                   /*kevin*/
/*     define new shared variable rmks like tr_rmks no-undo.*/                         /*kevin*/

     define new shared variable transtype as character
        format "x(7)" initial "ISS-TR".
     define new shared variable from_nettable like mfc_logical.
     define new shared variable to_nettable like mfc_logical.
     define new shared variable null_ch as character initial "".
/*       define shared variable mfguser as character.           *G247* */
     define new shared variable old_mrpflag like pt_mrp.
/*F0FH   define new shared variable eff_date as date.   */
/*/*F0FH*/ define new shared variable eff_date like tr_effdate.*/                  /*kevin*/
     define new shared variable intermediate_acct like trgl_dr_acct.
     define new shared variable intermediate_cc like trgl_dr_cc.
     define new shared variable from_expire like ld_expire.
     define new shared variable from_date like ld_date.
/*F701   def var lotref_from like ld_ref label "From Ref".                   */
/*F701   def var lotref_to like ld_ref label "To Ref".                       */
/*F003*/ define variable glcost like sct_cst_tot.
/*F190*/ define buffer lddet for ld_det.
/*F190   define variable status_to like tr_status label "Status" no-undo.    */
/*F190   define variable status_from like tr_status label "Status" no-undo.  */
/*F190*/ define variable undo-input like mfc_logical.
/*F190*/ define variable yn like mfc_logical.
/*F190*/ define variable assay like tr_assay.
/*F190*/ define variable grade like tr_grade.
/*F190*/ define variable expire like tr_expire.
/*/*F701*/ define shared variable trtype as character.*/                      /*kevin*/
/*/*F701*/ define new shared variable site_from like pt_site no-undo.*/           /*kevin*/
/*/*F701*/ define new shared variable loc_from like pt_loc no-undo.*/             /*kevin*/
/*F701*/ define new shared variable lotser_from like sr_lotser no-undo.
/*F701*/ define new shared variable lotref_from like ld_ref no-undo.
/*F701*/ define new shared variable status_from like ld_status no-undo.
/*/*F701*/ define new shared variable site_to like pt_site no-undo.*/             /*kevin*/
/*/*F701*/ define new shared variable loc_to like pt_loc no-undo.*/               /*kevin*/
/*F701*/ define new shared variable lotser_to like sr_lotser no-undo.
/*F701*/ define new shared variable lotref_to like ld_ref no-undo.
/*F701*/ define variable ld_recid as recid.
/*J1W2*/ define variable ld_recid_from as recid no-undo.
/*J1W2*/ define variable lot_control like clc_lotlevel no-undo.
/*J1W2*/ define variable errmsg as integer no-undo.
/*J1W2*/ define variable lot_found like mfc_logical no-undo.
/*J1W2*/ define buffer lddet1 for ld_det.
/*J1W2*/ define variable mesg_desc as character no-undo.

/*F0FH*/ {gpglefdf.i}

/*F701   NOTE ALL REFERENCES TO "LOTSER_FROM" WERE PREVIOUSLY "LOTSERIAL"*/
/*F701   NOTE ALL REFERENCES TO "LOTSER_TO"   WERE PREVIOUSLY "LOTSERIAL"*/

    trtype = "LOT/SER".
         
    for each tr:

     /* DISPLAY */
/*G0V9*/ transloop:
/*kevin
     repeat
/*F701*/ with frame a:
kevin*/
/*added by kevin*/
   do /*transaction*/  on error undo , leave on endkey undo , leave:
/*end added by kevin*/

/*GUI*/ if global-beam-me-up then undo, leave.

/*J038*/    {gprun.i ""gplotwdl.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*kevin
/*F701*/    clear frame a all no-pause.
/*kevin
/*FM01*/    nbr = "".
/*FM01*/    so_job = "".
/*FM01*/    rmks = "".
/*F701*/    lotserial_qty = 0.
/*F0FH*/    eff_date = today.
kevin*/
/*F701*/    find pt_mstr where pt_part = global_part no-lock no-error.
/*F701*/    if available pt_mstr then
/*F701*/    display pt_part pt_desc1 pt_um lotserial_qty.

        prompt-for pt_part with frame a editing:
           /* FIND NEXT/PREVIOUS RECORD */
           {mfnp.i pt_mstr pt_part pt_part pt_part pt_part pt_part}
           if recno <> ? then display pt_part  pt_desc1 pt_desc2 pt_um
           pt_site @ site_from
/*F701         pt_site @ site_to  */
           pt_loc @ loc_from
/*F701         pt_loc @ loc_to    */
           with frame a.
        end.
        status input.

/*FR46*     find pt_mstr using pt_part no-lock. */
/*FR46*/    find pt_mstr using pt_part no-lock no-error.
/*FR46*/    if not available pt_mstr then do:
/*FR46*/         /*TFQ  {mfmsg.i 7179 3}  */
 {pxmsg.i
               &MSGNUM=7179
               &ERRORLEVEL=3
                           }
/*Item does not exist */
/*FR46*/          undo, retry.
/*FR46*/    end.

        display pt_desc1 pt_desc2 pt_um
/*F701*/            pt_site @ site_from
/*F701*/            pt_loc @ loc_from
/*F701*/            lotserial_qty
/*FS18*/            "" @ lotser_from
/*FS18*/            "" @ lotref_from
        with frame a.
/*F701            display                                   */
/*F701            pt_site @ site_from pt_site @ site_to     */
/*F701            pt_loc @ loc_from pt_loc @ loc_to         */
/*F701            0 @ lotserial_qty                         */
/*F701/*F190*/    "" @ status_from                          */
/*F701/*F190*/    "" @ status_to                            */
/*F701            with frame a.                             */
kevin*/
/*added by kevin*/
      find pt_mstr where pt_part = tr.part no-lock no-error.
/*end added by kevin*/

        old_mrpflag = pt_mrp.

        /* SET GLOBAL PART VARIABLE */
        global_part = pt_part.

/*F701      do on error undo, retry:                          */
/*GH52* /*F701*/    repeat transaction on error undo, retry:  */

/*F0D2*/    xferloop:
/*/*GH52*/    repeat:*/                         /*marked by kevin*/
            do /*tfq transaction*/ on error undo , leave:     /*added by kevin*/
/*GUI*/ if global-beam-me-up then undo, leave.

/*F0FH  *F701* set lotserial_qty nbr so_job rmks with frame a. */

/*G1D2*/       toloop:
/*G1D2*/       do for lddet on error undo, retry /*with frame a*/:          /*kevin*/
/*GUI*/ if global-beam-me-up then undo, leave.


/*kevin
/*F0FH*/       display eff_date with frame a.
/*F0FH*/       set lotserial_qty eff_date nbr so_job rmks with frame a.
/*F701*/       if lotserial_qty = 0 then do:
/*F701*/         /*TFQ {mfmsg.i 7100 3}  */
          {pxmsg.i
               &MSGNUM=7100
               &ERRORLEVEL=3
                            }
/*quantity is zero*/
/*F701*/          undo, retry.
/*F701*/       end.

/*F0FH*/      {gpglef.i ""IC"" glentity eff_date}
kevin*/
             lotserial_qty = tr.qty_tr.                /*kevin*/

/*G1FP*/       from-loop:
/*G1FP*/       do on error undo:
/*GUI*/ if global-beam-me-up then undo, leave.

/*kevin
           set site_from loc_from
/*F701*/       lotser_from
           lotref_from
/*F190         site_to loc_to lotref_to  */
/*F701         lotserial lotserial_qty   */
           with frame a
           editing:
/*J034*/          assign
          global_site = input site_from
          global_loc = input loc_from
          global_lot = input lotser_from.
          readkey.
          apply lastkey.
           end.

/*J034*/          find si_mstr where si_site = site_from no-lock no-error.
/*J034*/          if not available si_mstr then do:
/*J034*/         /*TFQ    {mfmsg.i 708 3} */
 {pxmsg.i
               &MSGNUM=708
               &ERRORLEVEL=3
                            }
 /* SITE DOES NOT EXIST */
/*J034*/             next-prompt site_from with frame a.
/*G1FP*/             undo from-loop, retry from-loop.
/*J034*/          end.

/*J034*/          {gprun.i ""gpsiver.p""
           "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/           /*TFQ  {mfmsg.i 725 3} */   /* USER DOES NOT HAVE */
/*J034*/           {pxmsg.i
               &MSGNUM=725
               &ERRORLEVEL=3
                            }
                      /* ACCESS TO THIS SITE*/
/*J034*/             next-prompt site_from with frame a.
/*J034*/             undo from-loop, retry from-loop.
/*J034*/          end.
kevin*/

/*added by kevin*/
              assign 
                  site_from
                  loc_from = tr.loc_from
                  lotser_from = tr.lot_from
                  lotref_from = tr.ref_from.
/*end added by kevin*/

/*kevin
/*G1D2*/         assign
/*G1D2*/         site_to   = pt_site
/*G1D2*/         loc_to    = pt_loc
/*G1D2*/         lotser_to = lotser_from
/*G1D2*/         lotref_to = lotref_from.
kevin*/

/*G1D2* * * BEGIN COMMENT OUT *
 * /*F190*/       find ld_det where ld_part = pt_part and ld_site = site_from
 * /*F190*/       and ld_loc = loc_from and ld_lot = lotser_from
 * /*F190*/       and ld_ref = lotref_from no-lock no-error.
 *G1D2* * * END COMMENT OUT */

/*G1D2*/         find ld_det where ld_det.ld_part = pt_part
/*G1D2*/           and ld_det.ld_site = site_from
/*G1D2*/           and ld_det.ld_loc = loc_from
/*G1D2*/           and ld_det.ld_lot = lotser_from
/*G1D2*/           and ld_det.ld_ref = lotref_from no-lock no-error.

/*G1D2* /*F0D2*/       if not available ld_det then do transaction: */
/*G1D2*/       if not available ld_det then do:
/*F0D2*/          find si_mstr where si_site = site_from no-lock no-error.
/*F0D2*/          find loc_mstr where loc_site = site_from
/*F0D2*/                          and loc_loc = loc_from no-lock no-error.

/*F0D2*/          if not available si_mstr then do:
/*F0D2*/             /* site does not exist */
/*F0D2*/          /*TFQ   {mfmsg.i 708 3}*/
 {pxmsg.i
               &MSGNUM=708
               &ERRORLEVEL=3
                           }

/*G1FP*/             undo from-loop, retry from-loop.
/*F0D2*//*G1FP*            undo xferloop, retry xferloop. */
/*F0D2*/          end.
/*F0D2*/          if not available loc_mstr then do:
/*F0D2*/             if not si_auto_loc then do:
/*F0D2*/                /* Location/lot/item/serial does not exist */
/*F0D2*/             /*TFQ   {mfmsg.i 305 3} */
 {pxmsg.i
               &MSGNUM=305
               &ERRORLEVEL=3
                            }

/*G1FP*/                next-prompt loc_from.
/*G1FP*/                undo from-loop, retry from-loop.
/*F0D2*//*G1FP*                  undo xferloop, retry xferloop. */
/*F0D2*/             end.
/*F0D2*/             else do:
/*F0D2*/                find is_mstr where is_status = si_status
/*F0D2*/                no-lock no-error.
/*F0D2*/                if available is_mstr and is_overissue then do:
/*F0D2*/                   create loc_mstr.
/*F0D2*/                   assign
/*F0D2*/                      loc_site = si_site
/*F0D2*/                      loc_loc = loc_from
/*F0D2*/                      loc_date = today
/*F0D2*/                      loc_perm = no
/*F0D2*/                      loc_status = si_status.
/*F0D2*/                end.
/*F0D2*/                else do:
/*F0D2*/                   /* quantity available in site loc for lot serial */
/*F0D2*/                  /*TFQ {mfmsg02.i 208 3 0} */
 {pxmsg.i
               &MSGNUM=208
               &ERRORLEVEL=3
               &MSGARG1=0
             }

/*F0D2*/                   undo xferloop, retry xferloop.
/*F0D2*/                end.
/*F0D2*/             end.
/*F0D2*/          end.
/*F0D2*/
/*G0SQ /*F0D2*/   find is_mstr where is_status = si_status      */
/*G0SQ*/          find is_mstr where is_status = loc_status
/*F0D2*/          no-lock no-error.
/*F0D2*/          if available is_mstr and is_overissue

/*F0NL/*F0D2*/    and ((pt_lot_ser <> "" and lotser_from <> "") or     */
/*F0NL/*F0D2*/        (pt_lot_ser =  "" and lotser_from =  ""))        */
/*F0NL*/          and  (pt_lot_ser =  "" )

/*F0D2*/          then do:
/*F0D2*/             create ld_det.

/*G1D2* * BEGIN COMMENT OUT *
 * /*F0D2*/             assign
 * /*F0D2*/                ld_site = site_from
 * /*F0D2*/                ld_loc = loc_from
 * /*F0D2*/                ld_part = pt_part
 * /*F0D2*/                ld_lot = lotser_from
 * /*F0D2*/                ld_ref = lotref_from
 * /*F0D2*/                ld_status = loc_status.
 *G1D2* END COMMENT OUT */

/*G1D2*/               assign
/*G1D2*/                  ld_det.ld_site = site_from
/*G1D2*/                  ld_det.ld_loc = loc_from
/*G1D2*/                  ld_det.ld_part = pt_part
/*G1D2*/                  ld_det.ld_lot = lotser_from
/*G1D2*/                  ld_det.ld_ref = lotref_from
/*G1D2*/                  ld_det.ld_status = loc_status
/*G1ZM*/                  status_from = loc_status.

/*F0D2*/          end.
/*F0D2*/          else do:
/*F0D2*/             /* Location/lot/item/serial does not exist */
/*F0D2*/             /*TFQ {mfmsg.i 305 3}*/
 {pxmsg.i
               &MSGNUM=305
               &ERRORLEVEL=3
                         }

/*F0D2*/             undo xferloop, retry xferloop.
/*F0D2*/          end.
/*F0D2*/       end.
/*F0D2****
/*F190*/ *     if not available ld_det then do:
/*F190*/ *        /*message "Invalid item/site/loc/lot/ref combination.".*/
/*F190*/ *     /*TFQ   {mfmsg.i 305 3} */
 {pxmsg.i
               &MSGNUM=305
               &ERRORLEVEL=3
                         }

/*F190*/ *        undo, retry.
/*F190*/ *     end.
**F0D2****/
/*G1D2* /*FO32*/       else if ld_qty_oh - lotserial_qty - ld_qty_all < 0 */
/*G1D2*/         else if ld_det.ld_qty_oh - lotserial_qty -
/*G1D2*/                 ld_det.ld_qty_all < 0
/*G1ZM*/                   and ld_det.ld_qty_all > 0
/*G1ZM*/                   and ld_det.ld_qty_oh > 0
/*G1ZM*/                   and lotserial_qty > 0
/*FO32*/       then do:
/*G1D2* /*F0RN*/          status_from = ld_status. */
/*G1D2*/            status_from = ld_det.ld_status.
/*/*F0RN*/          display status_from with frame a.*/      /*kevin,for multiple*/
/*FO32*/          yn = yes.
/*FO32*/          /*message "Allocated inventory must be transferred
/*FO32*/                     to do this. Are you sure" */
/*/*FO32*/          {mfmsg01.i 434 2 yn}*/                    /*kevin,for cimload*/
/*FO32*/          if not yn then undo, retry.
/*FO32*/       end.
/*F190*/       else do:
/*G1D2* /*F190*/          status_from = ld_status. */
/*G1D2*/            status_from = ld_det.ld_status.
/*G1ZM* /*F190*/          display status_from with frame a. */
/*F190*/       end.
/*/*G1ZM*/              display status_from with frame a.*/       /*kevin,for multiple*/

/*J1W2*/       ld_recid_from = recid(ld_det).

/*FT37*/
/*J038*        ADDED BLANKS FOR TRNBR and TRLINE       */
          {gprun.i ""icedit.p"" "(""ISS-TR"",
                     site_from,
                     loc_from,
                     pt_part,
                     lotser_from,
                     lotref_from,
                     lotserial_qty,
                     pt_um,
                     """",
                     """",
                     output undo-input)"
          }
/*GUI*/ if global-beam-me-up then undo, leave.

/*FT37*/       if undo-input then undo, retry.

/*G1FP*/       end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* from-loop */

/*G1D2* * BEGIN COMMENT OUT *
 * /*F190*/       assign
 * /*FR46*        site_to   = site_from */
 * /*FR46*        loc_to    = loc_from  */
 * /*FR46*/       site_to   = pt_site
 * /*FR46*/       loc_to    = pt_loc
 * /*F190*/       lotser_to = lotser_from
 * /*F190*/       lotref_to = lotref_from.
 *
 * /*F190*/       toloop:
 * /*F190*/       do for lddet on error undo, retry
 * /*F701*/       with frame a:
 *G1D2* * * END COMMENT OUT */

/*G1FP*/          send-loop:
/*G1FP*/          do on error undo:
/*GUI*/ if global-beam-me-up then undo, leave.


/*/*F701*/          display site_to loc_to lotser_to lotref_to.*/                /*kevin,for multiple*/
/*
/*F701*/          if trtype = "LOT/SER" then do:
/*F190*/             set site_to loc_to
/*F701*/             lotser_to
/*F190*/             lotref_to with frame a editing:
/*F190*/                global_site = input site_to.
/*F190*/                global_loc = input loc_to.
/*F190*/                global_lot = input lotser_to.
/*F190*/                readkey.
/*F190*/                apply lastkey.
/*F190*/             end.
/*F701*/          end.
/*F701*/          else do:
/*F701*/             set site_to loc_to with frame a editing:
/*GC07*/                /*added "input" to global_site asnd global_loc below*/
/*F701*/                global_site = input site_to.
/*F701*/                global_loc = input loc_to.
/*F701*/                readkey.
/*F701*/                apply lastkey.
/*F701*/             end.
/*F701*/          end.

/*J034*/          find si_mstr where si_site = site_to no-lock no-error.
/*J034*/          if not available si_mstr then do:
/*J034*/            /*TFQ {mfmsg.i 708 3} */
 {pxmsg.i
               &MSGNUM=708
               &ERRORLEVEL=3
                           }
  /* SITE DOES NOT EXIST */
/*J034*/             next-prompt site_to with frame a.
/*J034*/             undo toloop, retry.
/*J034*/          end.

/*J034*/          {gprun.i ""gpsiver.p""
          "(input site_to, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/           /*TFQ  {mfmsg.i 725 3}*/    /* USER DOES NOT HAVE */
/*J034*/            {pxmsg.i
               &MSGNUM=725
               &ERRORLEVEL=3
                         }
                     /* ACCESS TO THIS SITE*/
/*J034*/             next-prompt site_to with frame a.
/*J034*/             undo toloop, retry.
/*J034*/          end.
kevin*/

/*added by kevin*/
               assign site_to
                      loc_to = tr.loc_to
                      lotser_to = tr.lot_from
                      lotref_to = tr.ref_from.
/*end added by kevin*/
              
/*J1W2*           BEGIN ADDED SECTION */
                  if (pt_lot_ser <> "") and (lotser_from <> lotser_to)
                  then do:
                     /* PERFORM COMPLIANCE CHECK  */
                     {gprun.i ""gpltfnd1.p"" "(pt_part,
                                               lotser_to,
                                               """",
                                               """",
                                               output lot_control,
                                               output lot_found,
                                               output errmsg)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     if ( lot_control > 0 and lot_found ) then do:
                        /* SERIAL NUMBER ALREADY EXISTS */
/*kevin                        {mfmsg.i 7482 3}
                        next-prompt lotser_to.            ***kevin*/
                        undo, retry.
                     end.
                  end.
/*J1W2*           END ADDED SECTION */

/*GH52  ********************  DELETED  ***************************************
/*F190*/          /*CREATE TO-LOCATION AND ERROR CHECK FOR ASSAY, GRADE, ETC.*/
/*F190*/          if not can-find(first loc_mstr where loc_site = site_to
/*F190*/          and loc_loc = loc_to) then do:
/*F190*/             {mfmsg.i 229 3} /* Location master does not exist*/
/*F190*/             undo toloop, retry.
/*F190*/          end.
************************************************************************GH52*/

/*F190*/          find lddet where lddet.ld_part = pt_part
/*F190*/                       and lddet.ld_site = site_to
/*F190*/                       and lddet.ld_loc  = loc_to
/*F190*/                       and lddet.ld_lot  = lotser_to
/*F190*/                       and lddet.ld_ref  = lotref_to
/*F190*/          no-error.
/*F701***************** REPLACED FOLLOWING SECTION **************************
/*F190*/          if available lddet and ld_qty_oh <> 0 then do:
/*F190*/             status_to = lddet.ld_status.
/*/*F190*/             display status_to with frame a.*/                        /*kevin*/

/*kevin
/*F190*/             if lddet.ld_grade  <> ld_det.ld_grade
/*F190*/             or lddet.ld_expire <> ld_det.ld_expire
/*F190*/             or lddet.ld_assay  <> ld_det.ld_assay then do:
/*F190*/             /*TFQ   {mfmsg.i 1913 4} */
                         {pxmsg.i
               &MSGNUM=1913
               &ERRORLEVEL=4
                            }
 /*Assay, grade, expiration must match*/
/*F190*/                undo, retry.
/*F190*/             end.
kevin*/

/*F190*/             if  status_from <> status_to then do:
/*F190*/                yn = yes.
/*/*F190*/                bell.*/                                               /*kevin*/
/*/*F190*/                {mfmsg01.i 1912 1 yn}  /*Change status of xfer items?*/*/       /*kevin,for cimload*/
/*F190*/                if not yn then undo, retry.
/*F190*/             end.
/*F190*/          end.

/*F190*/          else do:
/*F190*/             if not available lddet then do:
/*F190*/                create lddet.
/*F190*/                assign
/*F190*/                ld_site = site_to
/*F190*/                ld_loc = loc_to
/*F190*/                ld_part = pt_part
/*F190*/                ld_lot = lotserial
/*F190*/                ld_ref = lotref_to.
/*F190*/             end.
/*F190*/             assign
/*F190*/             lddet.ld_assay = ld_det.ld_assay
/*F190*/             lddet.ld_grade = ld_det.ld_grade
/*F190*/             lddet.ld_expire = ld_det.ld_expire.
/*F190*/             find loc_mstr where loc_site = site_to
/*F190*/             and loc_loc = loc_to.
/*F190*/             status_to = loc_status.
/*/*F190*/             display status_to with frame a.*/                      /*kevin, for multiple*/
/*/*F190*/          {mfmsg.i 1911 1}  /*Status may be changed*/*/                  /*kevin,for cimload*/
/*F190*/             bell.
/*marked by kevin,for cimload
/*F190*/             statusloop: do on error undo, retry:
/*/*F190*/                set status_to with frame a.*/                      
/*F190*/                if not can-find (first is_mstr where
/*F190*/                is_status = status_to) then do:
/*F190*/                /*TFQ   {mfmsg.i 361 3} */
 {pxmsg.i
               &MSGNUM=361
               &ERRORLEVEL=3
                            }
 /*inventory status does not exist*/
/*F190*/                   undo statusloop, retry.
/*F190*/                end.
/*F190*/             end.
end marked by kevin,for cimload*/
                    status_to = status_from.                    /*added by kevin,for cimload*/
/*F190*/             lddet.ld_status = status_to.
/*F190*/          end.
**F701***************** REPLACED PRECEDING SECTION **************************/

/*F701*/          ld_recid = ?.
/*F701*/          if not available lddet then do:
/*GH52/*F701*/             find loc_mstr where loc_site = site_to  */
/*GH52/*F701*/             and loc_loc = loc_to no-lock no-error.  */
/*F701*/             create lddet.
/*F701*/             assign
/*F701*/             lddet.ld_site = site_to
/*F701*/             lddet.ld_loc = loc_to
/*F701*/             lddet.ld_part = pt_part
/*F701*/             lddet.ld_lot = lotser_to
/*GH52 /*F701*/      lddet.ld_ref = lotref_to        */
/*GH52*/             lddet.ld_ref = lotref_to.
/*GH52*/             find loc_mstr where loc_site = site_to and
/*GH52*/             loc_loc = loc_to no-lock no-error.
/*GH52*/             if available loc_mstr then do:
/*GH52*/               lddet.ld_status = loc_status.
/*GH52*/             end.
/*GH52*/             else do:
/*GK75/*GH52*/        find si_mstr where si_site = loc_site no-lock no-error. */
/*GK75*/              find si_mstr where si_site = site_to no-lock no-error.
/*GH52*/                if available si_mstr then do:
/*GH52*/                 lddet.ld_status = si_status.
/*GH52*/                end.
/*GH52*/             end.
/*GH52/*F701*/       lddet.ld_status = loc_status.      */
/*F701*/             ld_recid = recid(lddet).
/*F701*/          end.

/*/*F701*/          display lddet.ld_status with frame a.*/               /*kevin, for multiple*/

/*F701*/          /*ERROR CONDITIONS*/
/*F701*/          if  ld_det.ld_site = lddet.ld_site
/*F701*/          and ld_det.ld_loc  = lddet.ld_loc
/*F701*/          and ld_det.ld_part = lddet.ld_part
/*F701*/          and ld_det.ld_lot  = lddet.ld_lot
/*F701*/          and ld_det.ld_ref  = lddet.ld_ref then do:
/*F701*/           /*TFQ  {mfmsg.i 1919 3} */
 {pxmsg.i
               &MSGNUM=1919
               &ERRORLEVEL=3
                            }
 /*Data results in null transfer*/
/*F701*/             undo, retry.
/*F701*/          end.

/*kevin,for multiple
/*J1W2*           BEGIN ADDED SECTION */
                  if (pt_lot_ser = "S")
                  then do:
             /* LDDET EXACTLY MATCHES THE USER'S 'TO' CRITERIA */
                     if lddet.ld_part = pt_part
                        and lddet.ld_site = site_to
                        and lddet.ld_loc  = loc_to
                        and lddet.ld_lot  = lotser_to
                        and lddet.ld_ref  = lotref_to
                        and lddet.ld_qty_oh > 0
                     then do:
                        mesg_desc = lddet.ld_site + ', ' + lddet.ld_loc.
                        /* SERIAL EXISTS AT SITE, LOCATION */
                      /*TFQ  {mfmsg02.i 79 2 mesg_desc } */
                       {pxmsg.i
               &MSGNUM=79
               &ERRORLEVEL=2
               &MSGARG1=mesg_desc
             }

                     end.
                     else do:
                        find first lddet1 where lddet1.ld_part = pt_part
                             and lddet1.ld_lot  = lotser_to
                             and lddet1.ld_qty_oh > 0
                             and recid(lddet1) <> ld_recid_from
                             no-lock no-error.
                        if available lddet1 then do:
                           mesg_desc = lddet1.ld_site + ', ' + lddet1.ld_loc.
                           /* SERIAL EXISTS AT SITE, LOCATION */
                          /*tfq {mfmsg02.i 79 2 mesg_desc } */
                           {pxmsg.i
               &MSGNUM=79
               &ERRORLEVEL=2
               &MSGARG1=mesg_desc
             }

                        end.
                     end.
                  end.
/*J1W2*           END ADDED SECTION */
end by kevin*/

/*F701*/          if lddet.ld_qty_oh = 0 then do:
/*F701*/             assign
/*G319*/             lddet.ld_date  = ld_det.ld_date
/*F701*/             lddet.ld_assay = ld_det.ld_assay
/*F701*/             lddet.ld_grade = ld_det.ld_grade
/*F701*/             lddet.ld_expire = ld_det.ld_expire.
/*F701*/          end.
/*F701*/          else do:
/*kevin/*F701*/             /*Assay, grade or expiration conflict. Xfer not allowed*/
/*F701*/             if lddet.ld_grade  <> ld_det.ld_grade
/*F701*/             or lddet.ld_expire <> ld_det.ld_expire
/*F701*/             or lddet.ld_assay  <> ld_det.ld_assay then do:
/*F701*/              /*tfq  {mfmsg.i 1918 4}*/
 {pxmsg.i
               &MSGNUM=1918
               &ERRORLEVEL=4
                          }

/*F701*/                undo, retry.
/*F701*/             end.                     *************kevin*/
/*F701*/          end.

/*F701*/          if status_from <> lddet.ld_status then do:
/*F701*/             if lddet.ld_qty_oh = 0 then do:
/*F701*/                if trtype = "LOT/SER" then do:
/*F701*/                   /*To-loc has zero balance. Status may be changed*/
/*kevin/*F701*/                   {mfmsg.i 1911 1}
/*F701*/                   bell.                           **********kevin*/
/*F701*/                   statusloop: do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

/*/*F701*/                      set lddet.ld_status with frame a.*/             /*kevin*/
/*F701*/                      if not can-find (first is_mstr where
/*F701*/                      is_status = lddet.ld_status) then do:
/*F701*/                        /*inventory status does not exist*/
/*F701*/                  /*tfq      {mfmsg.i 361 3} */
 {pxmsg.i
               &MSGNUM=361
               &ERRORLEVEL=3
                            }

/*F701*/                        undo statusloop, retry.
/*F701*/                      end.
/*F701*/                   end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*F701*/                end. /*ld_qty_oh = 0 and trtype = "LOT/SER"*/

/*F701*/                else do:
/*marked by kevin, for cimload
/*F701*/                   yn = no.
/*/*F701*/                   bell.*/                                /*kevin*/
/*F701*/                   /*Status conflict.  Use "to" status?*/
/*/*F701*/                   {mfmsg01.i 1917 1 yn}*/                 /*kevin*/
/*F701*/                   if not yn then do:
/*F701*/                      yn = yes.
/*F701*/                      /*Status conflict.  Use "from" status?*/
/*/*F701*/                      {mfmsg01.i 1916 1 yn}*/                    /*kevin*/
/*F701*/                      if yn then do:
/*F701*/                         lddet.ld_status = ld_det.ld_status.
/*/*F701*/                         display lddet.ld_status.*/              /*kevin*/
/*F701*/                      end.
/*F701*/                      else do:
/*F701*/                         undo, retry.
/*F701*/                      end.
/*F701*/                   end.
end marked by kevin,for cimload*/
/*F701*/                end. /*ld_qty_oh = 0 and trtype <> "LOT/SER"*/
/*F701*/             end. /*ld_qty_oh = 0*/

/*marked by kevin, for cimload
/*J038/*F701*/       else do:  */
/*J17R* *J038*       else if trtype = "LOT/SER" then do: */
/*J17R*/             else do:
/*F701*/                /*Status conflict.  Use "to" status?*/
/*F701*/                yn = yes.
/*kevin/*F701*/                bell.
/*F701*/                {mfmsg01.i 1917 1 yn}*/                    /*kevin*/
/*F701*/                if not yn then undo, retry.
/*F701*/             end. /*ld_qty_oh <> 0 & LOT/SER*/
/*J17R*     ** BEGIN DELETE SECTION **
.*J038*             else do:
.*J038*                /*STATUS IN TO LOC DOES NOT MATCH STATUS IN FROM LOC*/
.*J038*                /*tfq{mfmsg.i 1910 4} */
                     {pxmsg.i
               &MSGNUM=1910
               &ERRORLEVEL=4
                          }

.*J038*                undo, retry.
.*J038*             end. *ld_qty_oh <> 0 & Not LOT/SER*
*J17R*     ** END DELETE SECTION **/
end marked by kevin,for cimload*/

/*F701*/          end. /*lddet.ld_status <> ld_det.ld_status*/

/*kevin
/*F895*/          find is_mstr where is_status = lddet.ld_status no-lock.
/*F895*/          if not is_overissue and lddet.ld_qty_oh + lotserial_qty < 0
/*F895*/          then do:
/*F895*/             /*Transfer will result in negative qty at "to" loc*/
/*F895*/           /*tfq  {mfmsg.i 1920 3} */
 {pxmsg.i
               &MSGNUM=1920
               &ERRORLEVEL=3
                          }

/*F895*/             undo, retry.
/*F895*/          end.
kevin*/

/*FT37*/       /*ICEDIT.P BELOW WAS ICEDIT.I*/
/*J038*        ADDED BLANKS FOR TRNBR and TRLINE       */
           {gprun.i ""icedit.p"" "(""RCT-TR"",
                       site_to,
                       loc_to,
                       pt_part,
                       lotser_to,
                       lotref_to,
                       lotserial_qty,
                       pt_um,
                       """",
                       """",
                       output undo-input)"
           }
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0S4*/           if undo-input and batchrun then undo transloop,
/*H0S4*/              retry transloop.
/*G1FP*/           if undo-input and
/*G1FP*/             can-find(si_mstr where si_site = site_to) and
/*G1FP*/             not can-find(loc_mstr where loc_site = site_to and
/*G1FP*/                loc_loc = loc_to) then
/*G1FP*/             next-prompt loc_to.
/*FT37*/       if undo-input then undo, retry.

/*GH52*/         release lddet.
/*GH52*/         release ld_det.
/*J038*        ADDED BLANKS FOR TRNBR and TRLINE. Done during 1/11/96 merge.*/
/*G0V9*/       {gprun.i ""icedit.p"" "(""ISS-TR"",
                       site_from,
                       loc_from,
                       pt_part,
                       lotser_from,
                       lotref_from,
                       lotserial_qty,
                       pt_um,
                       """",
                       """",
                       output undo-input)"
           }
/*GUI*/ if global-beam-me-up then undo, leave.

/*G0V9*/       if undo-input then undo transloop, retry transloop.
/*G1D2*  /*F190*/       end.   /*toloop*/  */

/*G1FP*/       end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* send-loop */

/*FT37 **************moved the icedits before toloop *************************
*
* /*G102*/       /*PT_PART BELOW WAS GLOBAL_PART*/
* /*F190*/       /*ICEDIT.P BELOW WAS ICEDIT.I*/
*               {gprun.i ""icedit.p"" "(""ISS-TR"",
*                                       site_from,
*                                       loc_from,
*                                       pt_part,
*                                       lotser_from,
*                                       lotref_from,
*                                       lotserial_qty,
*                                       pt_um,
*                                       output undo-input)"
*               }
* /*F190*/       if undo-input then undo, retry.
* /*F190*/       /*ICEDIT.P BELOW WAS ICEDIT.I*/
*               {gprun.i ""icedit.p"" "(""RCT-TR"",
*                                       site_to,
*                                       loc_to,
*                                       pt_part,
*                                       lotser_to,
*                                       lotref_to,
*                                       lotserial_qty,
*                                       pt_um,
*                                       output undo-input)"
*               }
* /*F190*/       if undo-input then undo, retry.
***************end of moved section *****************************************/

/*GK75*/       hide message.
/*F701         update nbr so_job rmks with frame a.                       */
/*F701      end.                                                          */

/*G102*/       /* RESET GLOBAL PART VARIABLE IN CASE IT HAS BEEN CHANGED*/
/*G102*/       global_part = pt_part.
/*F003*/       global_addr = "".

           /*PASS BOTH LOTSER_FROM & LOTSER_TO IN PARAMETER LOTSERIAL*/
/*F701*/       lotserial = lotser_from.
/*F701*/       if lotser_to = "" then substring(lotserial,40,1) = "#".
/*F701*/       else substring(lotserial,19,18) = lotser_to.

/*G1D2*  /*GH52*/       do transaction: */
/*F003         INPUT PARAMETER ORDER:                                        */
/*F003         TR_LOT, TR_SERIAL, LOTREF_FROM, LOTREF_TO QUANTITY, TR_NBR,   */
/*F003         TR_SO_JOB, TR_RMKS, PROJECT, TR_EFFDATE, SITE_FROM, LOC_FROM, */
/*F003         SITE_TO, LOC_TO, TEMPID                                       */
/*F003         GLCOST                                                        */
/*F190         ASSAY, GRADE, EXPIRE                                          */
/*F0FH         added eff_date                                                */
/*cj*del*beg*
/*F003*/       {gprun.i ""icxfer.p"" "("""",
                       lotserial,
                       lotref_from,
                       lotref_to,
                       lotserial_qty,
                       nbr,
                       so_job,
                       rmks,
                       """",
                       eff_date,
                       site_from,
                       loc_from,
                       site_to,
                       loc_to,
                       no,
                       output glcost,
                       input-output assay,
                       input-output grade,
                       input-output expire)"
           }
*cj*del*end*/
/*cj*add*beg*/
     {gprun.i ""icxfer.p""
        "("""",
          lotserial,
          lotref_from,
          lotref_to,
          lotserial_qty,
          nbr,
          so_job,
          rmks,
          """",
          eff_date,
          site_from,
          loc_from,
          site_to,
          loc_to,
          no,
          """",
          ?,
          """",
          0,
          output glcost,
          output iss_trnbr,
          output rct_trnbr,
          input-output assay,
          input-output grade,
          input-output expire)"}
/*cj*add*end*/
/*GUI*/ if global-beam-me-up then undo, leave.


/*GH52*/       end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /*end transaction toloop */

/*GH52*/       do transaction:
/*F701*/       if ld_recid <> ? then
/*F701*/       find ld_det where ld_recid = recid(ld_det) no-error.
/*GE98 /*F701*/ if available ld_det and ld_det.ld_qty_oh = 0 then delete ld_det. */
/*GE98*/       if available ld_det then do:
/*GE98*/          find loc_mstr no-lock
/*GE98*/             where loc_site = ld_det.ld_site
/*GE98*/               and loc_loc  = ld_det.ld_loc.
/*GE98*/          if ld_det.ld_qty_oh = 0
/*GE98*/          and ld_det.ld_qty_all = 0
/*GE98*/          and not loc_perm
/*GE98*/          and not can-find(first tag_mstr
/*GE98*/                            where tag_site   = ld_det.ld_site
/*GE98*/                              and tag_loc    = ld_det.ld_loc
/*GE98*/                              and tag_part   = ld_det.ld_part
/*GE98*/                              and tag_serial = ld_det.ld_lot
/*GE98*/                              and tag_ref    = ld_det.ld_ref)
/*GE98*/          then delete ld_det.
/*GE98*/       end.
/*GH52*/       end. /* end transaction */

           /*display global_part @ pt_part with frame a.*/               /*kevin*/
/*F701*/    end.
/*GUI*/ if global-beam-me-up then undo, leave.

 /*repeat transaction*/
     end.
/*GUI*/ if global-beam-me-up then undo, leave.

  end. /*for each tr*/
  
end. /*repeat*/

