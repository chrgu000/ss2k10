/* /* icccaj.p - CYCLE COUNT RESULTS                                             */          */
/* /* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */          */
/* /* All rights reserved worldwide.  This is an unpublished work.               */          */
/* /* $Revision: 1.39.1.1 $                                                               */ */
/*                                                                                           */
/* /* REVISION: 1.0      LAST MODIFIED: 07/12/86   BY: EMB                       */          */
/* /* REVISION: 6.0      LAST MODIFIED: 03/14/90   BY: emb *D002*                */          */
/* /* REVISION: 6.0      LAST MODIFIED: 04/03/90   BY: WUG *D015*                */          */
/* /* REVISION: 6.0      LAST MODIFIED: 12/11/90   BY: emb *D242*                */          */
/* /* REVISION: 6.0      LAST MODIFIED: 12/17/90   BY: WUG *D619*                */          */
/* /* REVISION: 6.0      LAST MODIFIED: 04/12/91   BY: WUG *D525*                */          */
/* /* REVISION: 6.0      LAST MODIFIED: 04/26/91   BY: WUG *D589*                */          */
/* /* REVISION: 6.0      LAST MODIFIED: 08/01/91   BY: emb *D800*                */          */
/* /* REVISION: 7.0      LAST MODIFIED: 09/04/91   BY: pma *F003*                */          */
/* /* REVISION: 6.0      LAST MODIFIED: 11/11/91   BY: WUG *D887*                */          */
/* /* REVISION: 7.0      LAST MODIFIED: 02/03/92   BY: pma *F141*                */          */
/* /* REVISION: 7.0      LAST MODIFIED: 02/03/92   BY: pma *F172*                */          */
/* /* REVISION: 7.0      LAST MODIFIED: 06/18/92   BY: JJS *F672*(rev only)      */          */
/* /* REVISION: 7.0      LAST MODIFIED: 07/10/92   BY: pma *F757*                */          */
/* /* REVISION: 7.0      LAST MODIFIED: 02/03/93   BY: dzs *G632*                */          */
/* /* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*                */          */
/* /* REVISION: 7.4      LAST MODIFIED: 02/16/94   BY: pxd *FL60*                */          */
/* /* REVISION: 7.4      LAST MODIFIED: 08/18/94   BY: srk *FQ31*                */          */
/* /* REVISION: 7.2      LAST MODIFIED: 11/20/94   BY: qzl *FT92*                */          */
/* /* REVISION: 7.5      LAST MODIFIED: 01/23/94   BY: taf *J038*                */          */
/* /* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */          */
/* /* REVISION: 8.5      LAST MODIFIED: 09/18/95   BY: sxb *J053*                */          */
/* /* REVISION: 8.5      LAST MODIFIED: 05/01/96   BY: jym *G1MN*                */          */
/* /* REVISION: 7.3      LAST MODIFIED: 05/16/96   BY: rvw *G1S8*                */          */
/* /* REVISION: 8.5      LAST MODIFIED: 06/10/96   BY: jym *G1XS*                */          */
/* /* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: ejh *K001*                */          */
/* /* REVISION: 8.5      LAST MODIFIED: 07/31/96   BY: *G29S* Russ Witt          */          */
/* /* REVISION: 8.5      LAST MODIFIED: 08/23/96   BY: *G2CW* Russ Witt          */          */
/* /* REVISION: 8.6      LAST MODIFIED: 09/29/97   BY: *J1PS* Felcy D'Souza      */          */
/* /* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */          */
/* /* REVISION: 8.6E     LAST MODIFIED: 05/13/98   BY: *J2DD* Kawal Batra        */          */
/* /* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */          */
/* /* REVISION: 8.6E     LAST MODIFIED: 07/06/98   BY: *L034* Markus Barone      */          */
/* /* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */          */
/* /* REVISION: 9.1      LAST MODIFIED: 12/13/99   BY: *L0ML* Jyoti Thatte       */          */
/* /* REVISION: 9.1      LAST MODIFIED: 01/19/00   BY: *N077* Vijaya Pakala      */          */
/* /* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */          */
/* /* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */          */
/* /* Revision: 1.25     BY: Ellen Borden            DATE: 10/26/01  ECO: *P00G* */          */
/* /* Revision: 1.26     BY: Veena Lad               DATE: 05/08/02  ECO: *N1J0* */          */
/* /* Revision: 1.30     BY: Steve Nugent            DATE: 06/10/02  ECO: *P07Y* */          */
/* /* Revision: 1.31     BY: Manjusha Inglay         DATE: 08/16/02  ECO: *N1QP* */          */
/* /* Revision: 1.32     BY: Anitha Gopal            DATE: 12/03/02  ECO: *N217* */          */
/* /* Revision: 1.34     BY: Paul Donnelly (SB)      DATE: 06/26/03  ECO: *Q00G* */          */
/* /* Revision: 1.35     BY: Vivek Gogte             DATE: 11/24/03  ECO: *P1B2* */          */
/* /* Revision: 1.36     BY: Deepak Rao              DATE: 01/21/04  ECO: *P1KB* */          */
/* /* Revision: 1.37     BY: Veena Lad               DATE: 02/19/04  ECO: *P1PN* */          */
/* /* Revision: 1.38     BY: Robin McCarthy          DATE: 04/19/04  ECO: *P15V* */          */
/* /* Revision: 1.39     BY: Somesh Jeswani          DATE: 06/15/04  ECO: *P25V* */          */
/* /* $Revision: 1.39.1.1 $       BY: Tejasvi Kulkarni        DATE: 07/06/05  ECO: *P3RY* */ */
/* /*-Revision end---------------------------------------------------------------*/          */
/*                                                                                           */
/* /******************************************************************************/          */
/* /* All patch markers and commented out code have been removed from the source */          */
/* /* code below. For all future modifications to this file, any code which is   */          */
/* /* no longer required should be deleted and no in-line patch markers should   */          */
/* /* be added.  The ECO marker should only be included in the Revision History. */          */
/* /******************************************************************************/          */
/*                                                                                           */
/* /*V8:ConvertMode=Maintenance                                                  */          */


/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                               */
/* All rights reserved worldwide.  This is an unpublished work.                      */
/*V8:ConvertMode=NoConvert                                                           */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao   /*xp001*/ */
/*-Revision end------------------------------------------------------------          */


/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

{gldydef.i new}
{gldynrm.i new}

define variable yn like mfc_logical.
define variable cc_initial like mfc_logical format "Initial/Recount"
   initial yes label "Cycle Count Type (I/R)" no-undo.
define variable tol     like icc_tol_a    label "容差额"      no-undo.
define variable tol%    like icc_tol_a%   label "容差百分比"  no-undo.
define variable qty_cnt like in_qty_oh    label "Quantity Counted"      no-undo.
define variable qty_oh_var like icc_tol_a%
                                          label "库存量差异"  no-undo.
define variable avg_iss_var like icc_tol_a%
                                          label "Annual Usage Variance" no-undo.
define variable dollar_var like icc_tol_a label "Amount Variance"       no-undo.
define variable um like pt_um             label "Unit of Measure"       no-undo.
define variable conv like um_conv.
define variable eff_date like glt_effdate label "Effective Date"        no-undo.
define variable ref like glt_ref.
define variable part like pt_part no-undo.
define variable site like ld_site no-undo.
define variable location like ld_loc no-undo.
define variable lotserial like ld_lot no-undo.
define variable dr_acct like trgl_dr_acct no-undo.
define variable dr_sub like trgl_dr_sub no-undo.
define variable dr_cc   like trgl_dr_cc no-undo.
define variable cr_acct like trgl_cr_acct no-undo.
define variable cr_sub like trgl_cr_sub no-undo.
define variable cr_cc   like trgl_cr_cc no-undo.
define variable gl_amt like glt_amt.
define variable qty_oh like ld_qty_oh.
define variable transtype like tr_type.
define variable rmks like tr_rmks.
define variable lotref like ld_ref label "Reference" no-undo.
define variable undo-input like mfc_logical.
define variable isvalidacct like mfc_logical.
define variable trans-ok like mfc_logical no-undo.
define variable gl_tmp_amt as decimal.
define variable gl_amt_fmt as character.
define variable show-usage-var like mfc_logical.
define variable inrecno as recid no-undo.

/*CUSTOMER CONSIGNMENT VARIABLES*/
{socnvars.i}
define variable consigned_line             like mfc_logical  no-undo.
define variable consigned_qty_oh           like ld_qty_oh    no-undo.
define variable consigned_cc_qty           like ld_qty_oh    no-undo.
define variable unconsigned_qty            like ld_qty_oh    no-undo.
define variable procid                     as character      no-undo.
define variable hold_trnbr                 like tr_trnbr     no-undo.

/*SUPPLIER CONSIGNMENT VARIABLES */
define variable ENABLE_SUPPLIER_CONSIGNMENT
       as character initial "enable_supplier_consignment"    no-undo.
define variable SUPPLIER_CONSIGN_CTRL_TABLE
       as character initial "cns_ctrl"                       no-undo.
define variable using_supplier_consignment as logical        no-undo.
define variable supp_consign_qty           like ld_qty_oh    no-undo.
define variable io_batch                   like cnsu_batch   no-undo.

define var v_qty_firm as logical init no .
define variable v_fqty    like xmpt_kb_fqty .
define variable v_qty_kb  like xmpt_kb_fqty .
define var qty_raim_old like xkb_kb_raim_qty .
define var v_type like xkb_type label "类型" .
define var v_id like xkb_kb_id label "看板ID".
define var trnbr like tr_trnbr.
define var v_trnbr like tr_trnbr.
define buffer xkbhhist for xkbh_hist.

form  with frame c 8 down no-attr-space width 80.
form  v_type v_id xkb_kb_raim_qty  with frame d  width 80 attr-space .
setFrameLabels(frame d:handle).


{gpglefv.i}

form
   space(1)
   cc_initial     skip(1)
   part           colon 20
   icc_tol_flag   colon 62
   site           colon 20
   tol%           colon 62 
   location       colon 20
   tol            colon 62
   lotserial      colon 20
   glxcst         colon 62
   lotref         colon 20 format "x(8)"
   ld_cnt_date    colon 62
   pt_desc1       colon 20
   ld_qty_oh      colon 62 format "->>,>>>,>>9.9<<<<<<<<"
   label "Qty On Hand"
   pt_desc2       colon 22 no-label
   qty_cnt        colon 20
   qty_oh_var     colon 62 format "->>>>>>.99%"
   um             colon 20
   avg_iss_var    colon 62 format "->>>>>>.99%"
   conv           colon 20
   dollar_var     colon 62
   skip(1)
   rmks           colon 20
   eff_date       colon 20
   dr_acct        colon 20 label "Dr Acct"
   dr_sub         no-label
   dr_cc          no-label
   cr_acct        label "Cr"
   cr_sub         no-label
   cr_cc          no-label
   gl_amt         colon 20
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find first gl_ctrl where gl_domain = global_domain no-lock.

eff_date = today.

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}

repeat with frame a:
   update cc_initial with frame a.

   find first icc_ctrl where icc_domain = global_domain no-lock.

   loopb:
   repeat on error undo, retry with frame a:
      assign
         qty_cnt = 0
         qty_oh_var = 0
         avg_iss_var = 0
         dollar_var = 0
         transtype = "CYC-CNT".

      update
         part
      with frame a
      editing:
         global_part = input part.
         /* FIND NEXT/PREVIOUS */
         {mfnp.i pt_mstr part  " pt_domain = global_domain and pt_part "
                 part pt_part pt_part}

         if recno<> ? then do:
            display
               pt_part @ part
               pt_desc1
               pt_desc2
               pt_um   @ um
               pt_site @ site
               pt_loc  @ location
               ""      @ lotserial
               ""      @ lotref.
         end.
      end.

      find pt_mstr
         where pt_domain = global_domain
         and pt_part = part
      no-lock no-error.

      if not available pt_mstr then do:
         {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3} /*Item master does not exist*/
         undo, retry.
      end.
      assign
         site = pt_site
         lotserial = ""
         lotref    = ""
         location = pt_loc.

      do on error undo loopb, retry loopb:
         run ip-upd-frm-a.
      end.

      if (lotserial <> "") then do:
         {gprun.i ""gpltfnd.p""
                  "(input part,
                    input lotserial,
                    input """",
                    input """",
                    input """",
                    output trans-ok)"}

         if not trans-ok then do:
            undo loopb, retry.
         end.
      end.

      find pl_mstr
         where pl_domain = global_domain
         and   pl_prod_line = pt_prod_line
      no-lock.

      find pld_det
         where pld_domain = global_domain
         and   pld_prodline = pt_prod_line
         and   pld_site = site
         and   pld_loc = location
      no-lock no-error.

      if not available pld_det then do:
         find pld_det
            where pld_domain = global_domain
            and   pld_prodline = pt_prod_line
            and pld_site = site
            and pld_loc = ""
         no-lock no-error.

         if not available pld_det then do:
            find pld_det
               where pld_domain = global_domain
               and   pld_prodline = pt_prod_line
               and   pld_site = ""
               and   pld_loc = ""
            no-lock no-error.
         end.
      end.

      find ld_det
         where ld_domain = global_domain
         and   ld_part   = part
         and   ld_site   = site
         and   ld_loc    = location
         and   ld_lot    = lotserial
         and   ld_ref    = lotref
      no-lock no-error.

      if available ld_det then recno = recid(ld_det).

      find si_mstr
         where si_domain = global_domain
         and   si_site = site
      no-lock no-error.

      {gprun.i ""gpincr.p""
               "(input no,
                 input part,
                 input site,
                 input if available si_mstr then si_gl_set
                       else """",
                 input if available si_mstr then si_cur_set
                       else """",
                 input if available pt_mstr then pt_abc
                       else """",
                 input if available pt_mstr then pt_avg_int
                       else 0,
                 input if available pt_mstr then pt_cyc_int
                       else 0,
                 input if available pt_mstr then pt_rctpo_status
                       else """",
                 input if available pt_mstr then pt_rctpo_active
                       else no,
                 input if available pt_mstr then pt_rctwo_status
                       else """",
                 input if available pt_mstr then pt_rctwo_active
                       else no,
                 output inrecno)"}

      find in_mstr where recid(in_mstr) = inrecno
      no-lock no-error.

      find ptp_det no-lock
         where ptp_domain = global_domain
         and   ptp_part = in_part
         and   ptp_site = in_site
      no-error.

      {gpsct03.i &cost=sct_cst_tot}

      qty_oh = 0.
      if available ld_det then qty_oh = ld_qty_oh.

      global_part = pt_part.

      if in_abc = "a" then
        assign
            tol = icc_tol_a
            tol% = icc_tol_a%.
      else if in_abc = "b" then
         assign
            tol = icc_tol_b
            tol% = icc_tol_b%.
      else if in_abc = "c" then
         assign
            tol = icc_tol_c
            tol% = icc_tol_c%.
      else
         assign
            tol = icc_tol_o
            tol% = icc_tol_o%.

      if available pld_det then
         assign
            dr_acct = pld_inv_acct
            dr_sub  = pld_inv_sub
            dr_cc   = pld_inv_cc
            cr_acct = pld_dscracct
            cr_sub  = pld_dscr_sub
            cr_cc   = pld_dscr_cc.
      else
         assign
            dr_acct = pl_inv_acct
            dr_sub  = pl_inv_sub
            dr_cc   = pl_inv_cc
            cr_acct = pl_dscr_acct
            cr_sub  = pl_dscr_sub
            cr_cc   = pl_dscr_cc.

     assign
         um = pt_um
         conv = 1.

      display
         pt_desc1
         pt_desc2 um
         qty_oh @ ld_qty_oh
         glxcst
         dr_acct dr_sub dr_cc
         cr_acct cr_sub cr_cc
         tol tol%
         icc_tol_flag.

      if available ld_det then
         if ld_cnt_date = ? then display in_cnt_date @ ld_cnt_date.
      else display ld_cnt_date.

      update
         qty_cnt
         um conv
      with frame a.

   /*xp001*/

   clear frame c all no-pause .
   clear frame d all no-pause .
   
   kbloop:
   do on error undo, retry:
       find first wc_mstr where wc_domain = global_domain and wc_wkctr = location no-lock no-error .
       if not avail wc_mstr then do: /*非车间库位*/
           v_qty_kb = 0 .
           find first xmpt_mstr where xmpt_domain =global_domain and xmpt_site = site and xmpt_part = part no-lock no-error .
           find first xppt_mstr where xppt_domain =global_domain and xppt_site = site and xppt_part = part no-lock no-error .
           if ( avail xmpt_mstr ) or  ( avail xppt_mstr ) then do:

               view frame c .
               view frame d .


               for each xkb_mstr where xkb_domain =global_domain and xkb_site = site and xkb_loc = location 
                   and xkb_lot = lotserial and xkb_ref = lotref and xkb_status = "U" and xkb_part = part no-lock :
                   disp xkb_type xkb_kb_id  xkb_kb_raim_qty  with frame c .
                   down 1 with frame c .
                   v_qty_kb = v_qty_kb  + xkb_kb_raim_qty  .
               end.
    
               if v_qty_kb = qty_cnt then do:
                   message "看板信息全部正确?" view-as alert-box
                           question buttons yes-no title "" update choice AS logical.
                   if choice then do:
                       for each xkb_mstr where xkb_domain =global_domain and xkb_site = site and xkb_loc = location
                           and xkb_lot = lotserial and xkb_ref = lotref  and xkb_status = "U" and xkb_part = part exclusive-lock:
                           assign xkb_qty_cnt = xkb_kb_raim_qty xkb_cnt_date = today .
                       end.
                   end.
                   else do:
                       setline:
                       repeat: 
                           clear frame d all no-pause .
                    
                           assign  v_type = "" v_id  = 0 qty_raim_old = 0 .
                           update v_type v_id with frame d  .
                    
                           find xkb_mstr where xkb_domain =global_domain and xkb_site = site and xkb_loc = location
                               and xkb_lot = lotserial and xkb_ref = lotref  and xkb_status = "U" and xkb_part = part 
                               and xkb_type = v_type and xkb_kb_id = v_id  exclusive-lock no-error .
                           if  avail xkb_mstr then do:
                               disp xkb_type @ v_type
                                    xkb_kb_id @ v_id
                                    xkb_kb_raim_qty with frame d.
                               assign qty_raim_old = xkb_kb_raim_qty .
                    
                               update xkb_kb_raim_qty with frame d .
                    
                                if xkb_kb_id <> 000  and xkb_kb_id <> 999  then do:                                    
                                    if v_type = "M" then do:
                                        find xmpt_mstr where xmpt_domain = global_domain and xmpt_site = xkb_site and xmpt_part = xkb_part no-lock no-error .
                                        v_fqty = if avail xmpt_mstr then xmpt_kb_fqty else 0  .
                                        v_qty_firm = if avail xmpt_mstr then xmpt_qty_firm else no .

                                    end.
                                    if v_type = "P" then do:
                                        find xppt_mstr where xppt_domain = global_domain and xppt_site = xkb_site and xppt_part = xkb_part no-lock no-error .
                                        v_fqty = if avail xppt_mstr then xppt_kb_fqty else 0  .
                                        v_qty_firm = if avail xppt_mstr then xppt_qty_firm else no .
                                    end.
    
                                    if (xkb_kb_raim_qty ) > xkb_kb_qty then do:
                                        message "看板余量超过看板容量"   .
                                        if v_qty_firm = yes then undo , retry.
                                    end.
                                end.  

                               if qty_raim_old <> xkb_kb_raim_qty  then do:
                                   assign xkb_qty_cnt = xkb_kb_raim_qty xkb_cnt_date = today .
                    
                                   v_trnbr = 0.
                                   {xxkbhist.i  &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit046.p'"
                                                &qty="xkb_kb_qty"     &ori_qty="qty_raim_old" &tr_trnbr="v_trnbr"
                                                &b_status="xkb_status"       &c_status="xkb_status"
                                                &rain_qty="xkb_kb_raim_qty"}
                                    if xkb_kb_raim_qty = 0 then do:
                                         {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit046.p'"
                                                &qty="xkb_kb_qty"     &ori_qty="qty_raim_old" &tr_trnbr="v_trnbr"
                                                &b_status="'U'"       &c_status="'A'"
                                                &rain_qty="xkb_kb_raim_qty"}  
                                    end.                                                 

                               end.                                   
                           end.
                           else do:
                                 message "无对应记录,请重新输入.".
                           end.
                    
                           clear frame c all no-pause .
                           v_qty_kb = 0  .
                           for each xkb_mstr where xkb_domain =global_domain and xkb_site = site and xkb_loc = location
                               and xkb_lot = lotserial and xkb_ref = lotref and xkb_status = "U" and xkb_part = part  no-lock :
                               disp xkb_type xkb_kb_id xkb_kb_raim_qty skip with frame c .
                               down 1 with frame c .
                               v_qty_kb = v_qty_kb  + xkb_kb_raim_qty  .
                           end.
                           if v_qty_kb = qty_cnt then do:
                               message "确认保存?" update choice2 as logical.
                               if choice2 then leave .
                           end.
                           else do:
                               message "看板库存与盘点信息不一致,请修改对应记录" .
                           end.
                       end. /* SETLINE:  */
                   end.
               end.    /* if v_qty_kb = qty_cnt */
               else do:
                   message "看板库存与盘点信息不一致,请修改对应记录" .
                   setline:
                   repeat:
                
                       clear frame d all no-pause .
                
                       assign  v_type = "" v_id  = 0 qty_raim_old = 0  .
                       update v_type v_id with frame d  .
               
                       find xkb_mstr where xkb_domain =global_domain and xkb_site = site and xkb_loc = location
                           and xkb_lot = lotserial and xkb_ref = lotref  and xkb_status = "U" and xkb_part = part 
                           and xkb_type = v_type and xkb_kb_id = v_id exclusive-lock no-error .
                       if avail xkb_mstr then do:
                           disp xkb_type @ v_type
                                xkb_kb_id @ v_id
                                xkb_kb_raim_qty with frame d.
                           assign qty_raim_old = xkb_kb_raim_qty .
                
                           update xkb_kb_raim_qty with frame d .


                                if xkb_kb_id <> 000  and xkb_kb_id <> 999  then do:                                    
                                    if v_type = "M" then do:
                                        find xmpt_mstr where xmpt_domain = global_domain and xmpt_site = xkb_site and xmpt_part = xkb_part no-lock no-error .
                                        v_fqty = if avail xmpt_mstr then xmpt_kb_fqty else 0  .
                                        v_qty_firm = if avail xmpt_mstr then xmpt_qty_firm else no .

                                    end.
                                    if v_type = "P" then do:
                                        find xppt_mstr where xppt_domain = global_domain and xppt_site = xkb_site and xppt_part = xkb_part no-lock no-error .
                                        v_fqty = if avail xppt_mstr then xppt_kb_fqty else 0  .
                                        v_qty_firm = if avail xppt_mstr then xppt_qty_firm else no .
                                    end.
    
                                    if (xkb_kb_raim_qty ) > xkb_kb_qty then do:
                                        message "看板余量超过看板容量"       .
                                        if v_qty_firm = yes then undo , retry.
                                    end.
                                end. 
                
                           if qty_raim_old <> xkb_kb_raim_qty  then do:
                               assign xkb_qty_cnt = xkb_kb_raim_qty xkb_cnt_date = today .
                
                               v_trnbr =  0 .
                               {xxkbhist.i  &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                            &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit046.p'"
                                            &qty="xkb_kb_qty"     &ori_qty="qty_raim_old" &tr_trnbr="v_trnbr"
                                            &b_status="xkb_status"       &c_status="xkb_status"
                                            &rain_qty="xkb_kb_raim_qty"}
                                            
                                if xkb_kb_raim_qty = 0 then do:
                                     {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                            &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit046.p'"
                                            &qty="xkb_kb_qty"     &ori_qty="qty_raim_old" &tr_trnbr="v_trnbr"
                                            &b_status="'U'"       &c_status="'A'"
                                            &rain_qty="xkb_kb_raim_qty"}  
                                end.                                            

                           end.                                   
                       end.
                       else do:
                            message "无对应记录,请重新输入.".
                       end.
                
                       clear frame c all no-pause .
                       v_qty_kb = 0  .
                       for each xkb_mstr where xkb_domain =global_domain and xkb_site = site and xkb_loc = location
                           and xkb_lot = lotserial and xkb_ref = lotref and xkb_status = "U" and xkb_part = part  no-lock :
                           disp xkb_type xkb_kb_id xkb_kb_raim_qty skip with frame c .
                           down 1 with frame c .
                           v_qty_kb = v_qty_kb  + xkb_kb_raim_qty  .
                       end.
                       if v_qty_kb = qty_cnt then do:
                           message "确认保存?" update choice3 as logical.
                           if choice3 then leave .
                       end.
                       else do:
                           message "看板库存与盘点信息不一致,请修改对应记录" .
                       end.
                   end. /* SETLINE: DO: */
               end.
           end.  /* if ( avail */
           else do:
               hide frame c no-pause.
               hide frame d no-pause .
               view frame a .
               leave kbloop .
           end.
       end.   /*非车间库位*/
   end. /*kbloop*/

   clear frame c all no-pause .
   clear frame d all no-pause .
   message "" .
   message "" .

/*xp001*/




      /* CALCULATE UM CONVERSION */
      if um <> pt_um then do:
         /* ALLOW UOM CONVERSION WHEN ENTERING THE QUANTITY */
         /* WITH A DIFFERENT VALID UOM */
         if not conv entered then do:
            {gprun.i ""gpumcnv.p""
                     "(input um,
                       input pt_um,
                       input pt_part,
                       output conv)"}

            if conv = ? then do:
               {pxmsg.i &MSGNUM=33 &ERRORLEVEL=2}
               conv = 1.
            end.
            display conv with frame a.
         end.
      end.

      qty_cnt = qty_cnt * conv.

      /*CALCULATE GL AMOUNT*/
      gl_amt = (qty_cnt - qty_oh) * glxcst.

      {gprun.i ""gpcurrnd.p""
               "(input-output gl_amt,
                 input gl_rnd_mthd)"}

      gl_amt_fmt = gl_amt:format.

      {gprun.i ""gpcurfmt.p""
               "(input-output gl_amt_fmt,
                 input gl_rnd_mthd)"}

      gl_amt:format = gl_amt_fmt.

      display gl_amt.

      /*CALCULATE TOLERANCES */
      qty_oh_var = ((1 - qty_cnt / qty_oh) * 100).
      if qty_oh_var = ? and qty_cnt = 0 then qty_oh_var = 0.
      if qty_oh_var = ? and qty_cnt <> 0 then qty_oh_var = 100.
      if qty_oh_var < 0 then qty_oh_var = - qty_oh_var.

      assign
         avg_iss_var = 0
         show-usage-var = yes.

      if in_avg_iss = 0 then do:
         if not qty_cnt = qty_oh then do:
            show-usage-var = no.
            if not icc_tol_flag then do:
               /* ANNUAL USAGE VARIANCE CANNOT BE CALCULATED */
               {pxmsg.i &MSGNUM=1292 &ERRORLEVEL=2}
            end.
            avg_iss_var = 999999.99.
         end.
      end.
      else
         avg_iss_var = ((qty_cnt - qty_oh) / (in_avg_iss * 365)) * 100.

      if avg_iss_var < 0 then avg_iss_var = - avg_iss_var.

      dollar_var = (qty_cnt * glxcst) - (qty_oh * glxcst).

      {gprun.i ""gpcurrnd.p""
               "(input-output dollar_var,
                 input gl_rnd_mthd)"}

      if dollar_var < 0 then dollar_var = - dollar_var.

      gl_amt_fmt = dollar_var:format.

      {gprun.i ""gpcurfmt.p""
               "(input-output gl_amt_fmt,
                 input gl_rnd_mthd)"}

      dollar_var:format = gl_amt_fmt.

      display qty_oh_var.

      if show-usage-var then
         display
           avg_iss_var.
      else
         display "" @ avg_iss_var.

      display dollar_var.

      if (icc_tol_flag and qty_oh_var > tol%)
         or (dollar_var > tol)
         or (not icc_tol_flag and avg_iss_var > tol%)
      then do:
         {pxmsg.i &MSGNUM=201 &ERRORLEVEL=2} /* Count is out of tolerance */
         if cc_initial then do:
            {pxmsg.i &MSGNUM=202 &ERRORLEVEL=1}
            /* Quantity on hand will not be changed */
         end.
         if cc_initial then transtype = "CYC-ERR".
      end.
      if cc_initial = no then transtype = "CYC-RCNT".

      if transtype = "CYC-ERR" then gl_amt = 0.

      {gprun.i ""icedit.p""
               "(input transtype,
                 input site,
                 input location,
                 input part,
                 input lotserial,
                 input lotref,
                 input qty_cnt,
                 input um,
                 input """",
                 input """",
                 output undo-input )"}

      if undo-input then undo, retry.

      seta:
      do on error undo,retry:
         update rmks
            eff_date
            cr_acct
            cr_sub
            cr_cc
         with frame a.

         /* CHECK GL EFFECTIVE DATE */
         find si_mstr
            where si_domain = global_domain
            and   si_site = site
         no-lock no-error.

         {gpglef1.i
            &module = ""IC""
            &entity = si_entity
            &date = eff_date
            &prompt = "eff_date"
            &frame = "a"
            &loop = "seta"}

         /* CHECK GL ACCOUNT/COST CENTER */

         /* INITIALIZE SETTINGS */
         {gprunp.i "gpglvpl" "p" "initialize"}

         /* SET PROJECT VERIFICATION TO NO */
         {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}

         /* CHECK GL ACCOUNT/SUB ACCOUNT/COST CENTER */
         {gprunp.i "gpglvpl" "p" "validate_fullcode"
                   "(input cr_acct,
                     input cr_sub,
                     input cr_cc,
                     input """",
                     output isvalidacct)"}

         if not isvalidacct then do:
            next-prompt cr_acct.
            undo, retry.
         end.
      end.

      yn = yes.
      {mfmsg01.i 12 1 yn}
      if not yn then undo, retry.

      /* CHECK TO SEE IF CONSIGNMENT IS ACTIVE */
      {gprun.i ""gpmfc01.p""
               "(input ENABLE_CUSTOMER_CONSIGNMENT,
                 input 10,
                 input ADG,
                 input CUST_CONSIGN_CTRL_TABLE,
                 output using_cust_consignment)"}

      /* RESETTING THE CONSIGNED QUANTITY TO ZERO */
      assign
         consigned_cc_qty = 0
         supp_consign_qty = 0.

      /* CUSTOMER CONSIGNMENT */
      if available ld_det
         and using_cust_consignment
         and qty_cnt < qty_oh
         and ld_cust_consign_qty <> 0
      then do:
         assign
            consigned_qty_oh = ld_cust_consign_qty
            unconsigned_qty = qty_oh - consigned_qty_oh.

         if unconsigned_qty < (qty_oh - qty_cnt) then do:
            consigned_cc_qty = (qty_oh - qty_cnt) - unconsigned_qty.
         end.
      end. /* IF AVAILABLE ld_det ... */

      /* SUPPLIER CONSIGNMENT */
      if available ld_det
         and using_supplier_consignment
         and qty_cnt < qty_oh
         and ld_supp_consign_qty <> 0
      then do:

            supp_consign_qty = qty_oh - qty_cnt.

      end. /* IF AVAILABLE ld_det ... */

      {ictrans.i
         &addrid=""""
         &bdnstd=0
         &cracct=cr_acct
         &crsub=cr_sub
         &crcc=cr_cc
         &crproj=""""
         &curr=""""
         &dracct=dr_acct
         &drsub=dr_sub
         &drcc=dr_cc
         &drproj=""""
         &effdate=eff_date
         &exrate=0
         &exrate2=0
         &exratetype=""""
         &exruseq=0
         &glamt=gl_amt
         &lbrstd=0
         &line=0
         &location=location
         &lotnumber=""""
         &lotserial=lotserial
         &lotref=lotref
         &mtlstd=0
         &ordernbr=""""
         &ovhstd=0
         &part=part
         &perfdate=?
         &price=glxcst
         &quantityreq=qty_cnt
         &quantityshort=0
         &quantity="if transtype = ""CYC-ERR"" then 0
           else qty_cnt - qty_oh"
         &revision=""""
         &rmks=rmks
         &shiptype=""""
         &site=site
         &slspsn1=""""
         &slspsn2=""""
         &sojob=""""
         &substd=0
         &transtype=transtype
         &msg=0
         &ref_site=tr_site}

      assign
         hold_trnbr = tr_hist.tr_trnbr.

      if available in_mstr then in_cnt_date = eff_date.

      if using_cust_consignment and consigned_cc_qty > 0 and
         transtype <> "CYC-ERR" then do:

         /* BACKOUT THE CONSIGNED PORTION OF THE CYCLE COUNT THAT*/
         /* REPORTED.  CREATE A CONSIGNMENT USAGE FOR THAT PORTION*/
         /* THAT IS BACKED OUT.                                   */
         {ictrans.i
            &addrid=""""
            & bdnstd=0
            &cracct=cr_acct
            &crsub=cr_sub
            &crcc=cr_cc
            &crproj=""""
            &curr=""""
            &dracct=dr_acct
            &drsub=dr_sub
            &drcc=dr_cc
            &drproj=""""
            &effdate=eff_date
            &exrate=0
            &exrate2=0
            &exratetype=""""
            &exruseq=0
            &glamt="gl_amt * -1"
            &lbrstd=0
            &line=0
            &location=location
            &lotnumber=""""
            &lotserial=lotserial
            &lotref=lotref
            &mtlstd=0
            &ordernbr=""""
            &ovhstd=0
            &part=part
            &perfdate=?
            &price=glxcst
            &quantityreq="qty_cnt + consigned_cc_qty"
            &quantityshort=0
            &quantity=consigned_cc_qty
            &revision=""""
            &rmks=string(hold_trnbr)
            &shiptype=""""
            &site=site
            &slspsn1=""""
            &slspsn2=""""
            &sojob=""""
            &substd=0
            &transtype=""CN-CNT""
            &msg=0
            &ref_site=tr_site}

         {gprunmo.i &program = "socnuse.p" &module = "ACN"
                    &param   = """(input part,
                                   input site,
                                   input location,
                                   input lotserial,
                                   input lotref,
                                   input um,
                                   input consigned_cc_qty,
                                   input transtype,
                                   input eff_date)"""}

      end. /* If using_cust_consignment*/

      if using_supplier_consignment
         and supp_consign_qty > 0
         and transtype <> "CYC-ERR"
      then do:

         {gprunmo.i &program = ""ictrancn.p"" &module  = "ACN"
                    &param   = """(input '',
                                   input '',
                                   input 0,
                                   input '',
                                   input supp_consign_qty,
                                   input lotserial,
                                   input part,
                                   input site,
                                   input location,
                                   input lotref,
                                   input eff_date,
                                   input hold_trnbr,
                                   input false,
                                   input-output io_batch)"""}

      end. /* IF using_supplier_consignment */

      run find-ld-det.

   end. /*loopb*/
end.

PROCEDURE find-ld-det:

   /* TO AVOID DEAD-LOCK BETWEEN SESSIONS, RELEASING THE LOCK ON    */
   /* ld_det RECORD. ALSO CHANGED THE LOCK TO EXCLUSIVE FROM SHARED */
   find ld_det
      where ld_domain = global_domain
      and   ld_site = site
      and   ld_loc = location
      and   ld_part = part
      and   ld_lot = lotserial
      and   ld_ref = lotref
   exclusive-lock no-error.

   if available ld_det then ld_cnt_date = eff_date.

   release ld_det.
END PROCEDURE.

PROCEDURE ip-upd-frm-a:

   /* THIS PROCEDURE ALLOWS UPDATE OF SEVERAL FIELDS IN FRAME A.  */

   clear frame a.
   display
      cc_initial
      part
      site
      location
      lotserial
      lotref
   with frame a.

   do on endkey undo, return error:
      set
         site
         location
         lotserial
         lotref
      with frame a
      editing:
         assign
            global_site = input site
            global_loc = input location
            global_lot = input lotserial.

         if frame-field = "site" then do:
            /* FIND NEXT/PREVIOUS */
            {mfnp05.i ld_det ld_part_loc " ld_domain = global_domain and
            ld_part  = input part"
               ld_loc location}

            if recno<> ? then do:
               display
                  ld_site @ site
                  ld_loc @ location
                  ld_lot @ lotserial
                  ld_ref format "x(8)" @ lotref
               with frame a.
            end.
         end.
         else
            if frame-field = "location" then do:
            /* FIND NEXT/PREVIOUS */
            {mfnp05.i ld_det ld_part_loc
               " ld_domain = global_domain and ld_part  = input part
                 and ld_site = input site" ld_loc location}

            if recno<> ? then do:
               display
                  ld_site @ site
                  ld_loc @ location
                  ld_lot @ lotserial
                  ld_ref format "x(8)" @ lotref
               with frame a.
            end.
         end.
         else
            if frame-field = "lotserial" then do:
            /* FIND NEXT/PREVIOUS */
            {mfnp05.i ld_det ld_part_loc
               " ld_domain = global_domain and ld_part  = input part and
               ld_site = input site
                 and ld_loc = input location"
               ld_loc location}

            if recno<> ? then do:
               display
                  ld_site @ site
                  ld_loc @ location
                  ld_lot @ lotserial
                  ld_ref format "x(8)" @ lotref
               with frame a.
            end.
         end.
         else do:
            status input.
            readkey.
            apply lastkey.
         end.
      end. /* EDITING */
   end. /* do on endkey */

END PROCEDURE.  /* ip-upd-frm-a */
