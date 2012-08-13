/*zztlcfm.p ,to actually transfer the item from normal location to the shop floor location
based on the transfer list*/
/*Revision: 8.5f,   Last Modified: 12/20/03,    By: Kevin*/
/*Revision: 8.5f, Last modified: 05/31/2004, By: kevin, to assign the effective date as the "xxtl_effdate"*/

         /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*GI32*/ {mfdtitle.i "E"}

def var site like si_site.
def var nbr like xxtl_nbr.
def var msg-nbr as inte.
def var conf-yn as logic.
def var ok_yn as logic.
def var msg_file as char format "x(60)".
DEF VAR msg_fileerr AS CHAR FORMAT "x(60)".  /*judy*/
def var qty_tot like xxtl_qty_pick.

def temp-table tr
     field nbr like xxtl_nbr
     field site like xxtl_site
     field part like xxtl_part
     field loc_fr like xxtl_loc_fr
     field loc_to like xxtl_loc_to
     field qty_req like xxtl_qty_req
     field qty_pick like xxtl_qty_pick
     field error as char format "x(50)"
     field effdate like xxtl_effdate
     index trindex nbr part loc_fr loc_to.


FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 site colon 22
 nbr colon 22 skip(1)
 msg_file colon 22 label "日志文件"
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
setframelabels(frame a:handle) .
repeat:
    if msg_file = "" then msg_file = "c:\TL-transfer.txt".
    
    update site nbr msg_file with frame a editing:
            if frame-field = "site" then do:
                {mfnp.i si_mstr site si_site site si_site si_site}
                if recno <> ? then do:
                    disp si_site @ site with frame a.    
                end.
            end.
            else do:
                readkey.
              apply lastkey.
            end.
    end.

       IF msg_file = "" THEN DO:
            MESSAGE "错误:日志文件不能为空,请重新输入!" view-as alert-box error.
             NEXT-PROMPT msg_file WITH FRAME a.
             UNDO, RETRY.
       END.       
       msg_fileerr = msg_file + ".err".

       /*verify the input site*/ 
       find si_mstr no-lock where si_site = site no-error.
       if not available si_mstr or (si_db <> global_db) then do:
          if not available si_mstr then msg-nbr = 708.
          else msg-nbr = 5421.
          {mfmsg.i msg-nbr 3}
          undo, retry.
       end.
            
                    
                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             undo,retry.
/*J034*/          end.

      if nbr = "" then do:
           message "移仓单号不允许为空,请重新输入!" view-as alert-box error.
           next-prompt nbr with frame a.
           undo,retry.
      end.

      find first xxtl_det where xxtl_nbr = nbr no-lock no-error.
      if not available xxtl_det then do:
           message "移仓单不存在,请重新输入!" view-as alert-box error.
           next-prompt nbr with frame a.
           undo,retry.
      end.
            
      if xxtl_site <> site then do:
           message "移仓单地点与输入地点不一致,请重新输入!" view-as alert-box error.
           next-prompt nbr with frame a.
           undo,retry.           
      end.
      
      find first xxtl_det where xxtl_site = site and
                                xxtl_nbr = nbr and
                                xxtl_qty_tr > 0 no-lock no-error.
      if available xxtl_det then do:
           message "该移仓单已经确认并移仓,请重新输入!" view-as alert-box error.
           next-prompt nbr with frame a.
           undo,retry.
      end.

       conf-yn = no.
       message "确认进行移仓" view-as alert-box question buttons yes-no update conf-yn.
       if conf-yn <> yes then undo,retry.
             
      /*create the temporary file*/
      for each xxtl_det where xxtl_nbr = nbr no-lock:
            find first tr where tr.nbr = xxtl_nbr and
                                tr.part = xxtl_part and
                           tr.loc_fr = xxtl_loc_fr and
                           tr.loc_to = xxtl_loc_to no-error.
          if not available tr then do:
                 create tr.
                 assign tr.nbr = xxtl_nbr
                        tr.site = site
                        tr.part = xxtl_part
                        tr.loc_fr = xxtl_loc_fr
                        tr.loc_to = xxtl_loc_to
                        tr.qty_req = xxtl_qty_req
                        tr.qty_pick = xxtl_qty_pick
                        tr.effdate = xxtl_effdate.
          end.
          
      end. /*for each xxtl_det*/

      /*************verify every records****************/
     ok_yn = yes.
     qty_tot = 0.
     for each tr where tr.qty_pick <> 0 break by tr.site by tr.nbr by tr.part by tr.loc_fr:
            find pt_mstr where pt_part = tr.part no-lock no-error.
            if not available pt_mstr then do:
               assign tr.error = "零件号不存在".
                 ok_yn = no.
                 next.
              end.

/*G1ZV*/   if can-find(first isd_det where
/*G1ZV*/              isd_status = string(pt_status,"x(8)") + "#"
/*G1ZV*/              and (isd_tr_type = "iss-tr" or isd_tr_type = "rct-tr")) then do:
               assign tr.error = "零件状态代码的限定过程 " + pt_status.
               ok_yn = no.
               next.
/*F089*/   end.

   /*verify the 'from' location*/
   find loc_mstr where loc_site = tr.site and loc_loc = tr.loc_fr no-lock no-error.
   if not available loc_mstr then do:
         assign tr.error = "移出库位 " + tr.site + "," + tr.loc_fr + " 不存在".
         ok_yn = no.
         next.
   end.

   /*verify the status of loc_from*/
   find isd_det no-lock
        where isd_tr_type = "iss-tr"
          and isd_status =
          (if available loc_mstr and loc_status <> "" then loc_status
          else si_status) no-error.
   if available isd_det then do:
       assign tr.error = "移出库位 " + tr.site + "," + tr.loc_fr + " 的状态为受限制状态".
         ok_yn = no.
         next.
   end.

            /* DO NOT CHECK LOCATION TYPES FOR WAREHOUSING INTERFACE */
            /*For from location type*/            
            if not can-find(whl_mstr where whl_site = tr.site
            and whl_loc = tr.loc_fr no-lock) then do:

               if available pt_mstr and pt_loc_type <> "" then
               if ((available loc_mstr and loc_type <> pt_loc_type)
               or (not available loc_mstr)) then do:
                  assign tr.error = "零件的库位类型与移出库位的库位类型不一致".
                 ok_yn = no.
                  next.
               end.

            end.  /* IF NOT WAREHOUSE INTERFACE LOCATION */ 

   
   /*verify the 'to' location*/
   find loc_mstr where loc_site = tr.site and loc_loc = tr.loc_to no-lock no-error.
   if not available loc_mstr then do:
         assign tr.error = "车间库位 " + tr.site + "," + tr.loc_to + " 不存在".
         ok_yn = no.
         next.
   end.

   /*verify the status of loc_from*/
   find isd_det no-lock
        where isd_tr_type = "rct-tr"
          and isd_status =
          (if available loc_mstr and loc_status <> "" then loc_status
          else si_status) no-error.
   if available isd_det then do:
         assign tr.error = "车间库位 " + tr.site + "," + tr.loc_to + " 的状态为受限制状态".
         ok_yn = no.
         next.
   end.

            /* DO NOT CHECK LOCATION TYPES FOR WAREHOUSING INTERFACE */
            /*For to location type*/
            if not can-find(whl_mstr where whl_site = tr.site
            and whl_loc = tr.loc_to no-lock) then do:

               if available pt_mstr and pt_loc_type <> "" then
               if ((available loc_mstr and loc_type <> pt_loc_type)
               or (not available loc_mstr)) then do:
                  assign tr.error = "零件的库位类型与车间库位的库位类型不一致".
                 ok_yn = no.
                  next.
               end.

            end.  /* IF NOT WAREHOUSE INTERFACE LOCATION */
            

   /*verify whether the quantity on hand more than or equel the picked quantity*/
   find ld_det where ld_site = tr.site and ld_part = tr.part 
                     and ld_loc = tr.loc_fr
                     and ld_lot = "" and ld_ref = ""                          /*kevin*/
                     and ld_qty_oh >= tr.qty_pick no-lock no-error.     
   if not available ld_det then do:
        assign tr.error = "零件 " + tr.part + " 在 " + tr.site + "," + tr.loc_fr + " 的库存不足".
         ok_yn = no.
         next.
   end.                  
                    
                    /*added by kevin,01/18/2004*/
                    qty_tot = qty_tot + tr.qty_pick.
                    if last-of(tr.loc_fr) then do:
                        if qty_tot <> 0 then do:
                              find ld_det where ld_site = tr.site and ld_loc = tr.loc_fr
                                               and ld_part = tr.part and ld_lot = "" and ld_ref = ""
                              no-lock no-error.
                              if available ld_det then do:
                                 if ld_qty_oh < qty_tot then do:       
                                     assign tr.error = tr.site + "," + tr.loc_fr
                                                    + "的待移仓总量:" + string(qty_tot) + ",大于库存量:" + string(ld_qty_oh). 
                                     ok_yn = no.        
                                     next.
                                 end.
                              end.     
                        end.
                        
                        qty_tot = 0.
                    end.   
                       
     end. /*for each tr*/           


         /***********create the log file by Kevin*************/
         output to value(msg_file).
         for each tr no-lock:
                disp tr.nbr label "移仓单"
                     tr.site label "地点"
                     tr.part label "零件号"
                     tr.loc_fr label "移出库位"
                     tr.loc_to label "车间库位"
                     tr.qty_pick label "待移仓量"
                     tr.error with width 255 stream-io.
         end.
         output close.
/*judy*/
         output to value(msg_file).
      for each tr WHERE tr.ERROR <> ""  no-lock:
       disp tr.nbr label "移仓单"
            tr.site label "地点"
            tr.part label "零件号"
            tr.loc_fr label "移出库位"
            tr.loc_to label "车间库位"
            tr.qty_pick label "待移仓量"
            tr.error with width 255 stream-io.
    end.
    output close.

/*judy*/

      
      if ok_yn then do:
              message "移仓单数据校验成功!" view-as alert-box message.
      END.
      ELSE  do:
             OS-COMMAND notepad  value(msg_fileerr) .       /*judy*/
            OS-DELETE value(msg_fileerr) .                           /*judy*/
        /* message "移仓单数据校验失败,请察看日志文件!" view-as alert-box error.*/
         undo,retry.
      END. 
      
      /**********************start actually transfer item************************/
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
/*     define new shared variable nbr like tr_nbr label "订单" no-undo.*/          /*kevin*/
     define new shared variable so_job like tr_so_job no-undo.
     define new shared variable rmks like tr_rmks no-undo.

     define new shared variable transtype as character
        format "x(7)" initial "ISS-TR".
     define new shared variable from_nettable like mfc_logical.
     define new shared variable to_nettable like mfc_logical.
     define new shared variable null_ch as character initial "".
/*       define shared variable mfguser as character.           *G247* */
     define new shared variable old_mrpflag like pt_mrp.
/*F0FH   define new shared variable eff_date as date.   */
/*F0FH*/ define new shared variable eff_date like tr_effdate.
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
/*/*F701*/ define shared variable trtype as character.*/                     /*kevin*/
         define variable trtype as character.                                /*kevin*/
/*F701*/ define new shared variable site_from like pt_site no-undo.
/*F701*/ define new shared variable loc_from like pt_loc no-undo.
/*F701*/ define new shared variable lotser_from like sr_lotser no-undo.
/*F701*/ define new shared variable lotref_from like ld_ref no-undo.
/*F701*/ define new shared variable status_from like ld_status no-undo.
/*F701*/ define new shared variable site_to like pt_site no-undo.
/*F701*/ define new shared variable loc_to like pt_loc no-undo.
/*F701*/ define new shared variable lotser_to like sr_lotser no-undo.
/*F701*/ define new shared variable lotref_to like ld_ref no-undo.
/*F701*/ define variable ld_recid as recid.
/*J1W2*/ define variable ld_recid_from as recid no-undo.
/*J1W2*/ define variable lot_control like clc_lotlevel no-undo.
/*J1W2*/ define variable errmsg as integer no-undo.
/*J1W2*/ define variable lot_found like mfc_logical no-undo.
/*J1W2*/ define buffer lddet1 for ld_det.
/*J1W2*/ define variable mesg_desc as character no-undo.

/*judy 05/08/09*/  define variable iss_trnbr like tr_trnbr no-undo.
/*judy 05/08/09*/  define variable rct_trnbr like tr_trnbr no-undo.

/*F0FH*/ {gpglefdf.i}
/*judy 05/08/09*/    {gldydef.i NEW}
/*judy 05/08/09*/    {gldynrm.i NEW}


/*F701   NOTE ALL REFERENCES TO "LOTSER_FROM" WERE PREVIOUSLY "LOTSERIAL"*/
/*F701   NOTE ALL REFERENCES TO "LOTSER_TO"   WERE PREVIOUSLY "LOTSERIAL"*/

    trtype = "LOT/SER".

/*added by kevin*/
/*G0V9*/ transloop:
   do transaction on error undo , leave on endkey undo , leave:
/*end added by kevin*/
         
    for each tr where tr.qty_pick <> 0:

     /* DISPLAY */
/*kevin
/*G0V9*/ transloop:
     repeat
/*F701*/ with frame a:
kevin*/

/*GUI*/ if global-beam-me-up then undo, leave.

/*J038*/    {gprun.i ""gplotwdl.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*added by kevin*/
           /*eff_date = today.*/            /*eyes, 05/31/2004*/
                      eff_date = tr.effdate.                 /*eyes, 05/31/2004*/
/*end added by kevin*/

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
/*FR46*/          {mfmsg.i 7179 3} /*Item does not exist */
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
            do /*tfq transaction */ on error undo , leave:     /*added by kevin*/
/*GUI*/ if global-beam-me-up then undo, leave.

/*F0FH  *F701* set lotserial_qty nbr so_job rmks with frame a. */

/*G1D2*/       toloop:
/*G1D2*/       do for lddet on error undo, retry with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


/*kevin
/*F0FH*/       display eff_date with frame a.
/*F0FH*/       set lotserial_qty eff_date nbr so_job rmks with frame a.
/*F701*/       if lotserial_qty = 0 then do:
/*F701*/          {mfmsg.i 7100 3} /*quantity is zero*/
/*F701*/          undo, retry.
/*F701*/       end.

/*F0FH*/      {gpglef.i ""IC"" glentity eff_date}
kevin*/
             lotserial_qty = tr.qty_pick.                /*kevin*/

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
/*J034*/             {mfmsg.i 708 3}  /* SITE DOES NOT EXIST */
/*/*J034*/             next-prompt site_from with frame a.*/                          /*kevin,12/23/2003*/
/*G1FP*/             undo from-loop, retry from-loop.
/*J034*/          end.

/*J034*/          {gprun.i ""gpsiver.p""
           "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*/*J034*/             next-prompt site_from with frame a.*/                        /*kevin*/
/*J034*/             undo from-loop, retry from-loop.
/*J034*/          end.
kevin*/

/*added by kevin*/
              assign 
                  site_from = site
                  loc_from = tr.loc_fr
                  lotser_from = ""
                  lotref_from = "".
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
/*F0D2*/             {mfmsg.i 708 3}
/*G1FP*/             undo from-loop, retry from-loop.
/*F0D2*//*G1FP*            undo xferloop, retry xferloop. */
/*F0D2*/          end.
/*F0D2*/          if not available loc_mstr then do:
/*F0D2*/             if not si_auto_loc then do:
/*F0D2*/                /* Location/lot/item/serial does not exist */
/*F0D2*/                {mfmsg.i 305 3}
/*/*G1FP*/                next-prompt loc_from.*/                         /*kevin,12/23*/
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
/*F0D2*/                 /*tfq  {mfmsg02.i 208 3 0} */
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
/*F0D2*/             {mfmsg.i 305 3}
/*F0D2*/             undo xferloop, retry xferloop.
/*F0D2*/          end.
/*F0D2*/       end.
/*F0D2****
/*F190*/ *     if not available ld_det then do:
/*F190*/ *        /*message "Invalid item/site/loc/lot/ref combination.".*/
/*F190*/ *        {mfmsg.i 305 3}
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
/*J034*/             {mfmsg.i 708 3}  /* SITE DOES NOT EXIST */
/*J034*/             next-prompt site_to with frame a.
/*J034*/             undo toloop, retry.
/*J034*/          end.

/*J034*/          {gprun.i ""gpsiver.p""
          "(input site_to, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             next-prompt site_to with frame a.
/*J034*/             undo toloop, retry.
/*J034*/          end.
kevin*/

/*added by kevin*/
               assign site_to = site
                      loc_to = tr.loc_to
                      lotser_to = ""
                      lotref_to = "".
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
/*F190*/                {mfmsg.i 1913 4} /*Assay, grade, expiration must match*/
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
/*F190*/                   {mfmsg.i 361 3} /*inventory status does not exist*/
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
/*F701*/             {mfmsg.i 1919 3} /*Data results in null transfer*/
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
                       /*tfq {mfmsg02.i 79 2 mesg_desc }  */
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
                         /*tfq  {mfmsg02.i 79 2 mesg_desc } */
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
/*F701*/                {mfmsg.i 1918 4}
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
/*F701*/                        {mfmsg.i 361 3}
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
.*J038*                {mfmsg.i 1910 4}
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
/*F895*/             {mfmsg.i 1920 3}
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
/*/*G1FP*/             next-prompt loc_to.*/                           /*kevin,12/23/2003*/
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
/*judy 05/08/09*/    """",
/*judy 05/08/09*/    """",
 /*judy 05/08/09*/   """",
  /*judy 05/08/09*/   0,
                       output glcost,
/*judy 05/08/09*/   output iss_trnbr,
/*judy 05/08/09*/   output rct_trnbr,
                       input-output assay,
                       input-output grade,
                       input-output expire)"
            }                      
 
 
/*GUI*/ if global-beam-me-up then undo, leave.


/*GH52*/       end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /*end transaction toloop */
/*tfq*/        do on error undo, leave :
/*GH52*/      /*tfq  do transaction: */
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

        /******************update the transfer list field xxtl_qty_tr by Kevin*****************/
        find xxtl_det where xxtl_nbr = tr.nbr and xxtl_part = tr.part 
                       and xxtl_loc_fr = tr.loc_fr and xxtl_loc_to = tr.loc_to no-error.
        if available xxtl_det then do:
              assign xxtl_qty_tr = tr.qty_pick.
        end.
        
/*GUI*/ if global-beam-me-up then undo, leave.
  
  end. /*for each tr*/

 /*repeat transaction*/
     end.
               
end. /*repeat*/
