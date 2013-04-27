/* zzGTSOL.P - UPLOAD INVOICE DATA GENERATE BY GOLD-TAX INTO MFG/PRO       */
/*                                                                         */
/*  LAST MODIFIED   DAT:2004-09-01 20:04  BY: *LB01* LONG BO         */
/*  LAST MODIFIED   DAT:2005-01-07 09:52  BY: *LB02* LONG BO         */

/**************
FOR EACH usrw_wkfl EXCLUSIVE-LOCK WHERE usrw_domain = "dcec" 
    AND usrw_key1 = "GOLDTAX-MSTR" AND usrw_key5 = "DC@30416K1 0425371":
    DELETE usrw_wkfl.
END.
***************/

{mfdtitle.i "1349"}

define new shared stream rpt.
define new shared stream bf.
define new shared var v_bkbox  as char format "x(50)".
define new shared var v_inbox  as char format "x(50)".
define new shared var v_rpbox  as char format "x(50)".
define new shared var v_ptbox  as char format "x(50)".  /*���˽������*/

define new shared var v_bkfile as char format "x(50)".
define new shared var v_infile as char format "x(50)".
define new shared var v_infilex as char format "x(12)".
define new shared var v_rpfile as char format "x(50)".
define new shared var v_rpline as char format "x(100)".

define new shared variable v_postfile          as character.

define new shared var v_times  as integer.
define new shared var v_load   as logical initial yes.
define new shared var v_adj    as logical .
define new shared var v_post   as logical .

define new shared var type     as char.
define new shared var nbr      like so_nbr.
define new shared var v_dt       as date.
define new shared var v_site   like so_site.
define new shared var i        as char format "x(70)" extent 48.

DEFINE new shared VAR savepos AS INT.
define new shared var strdummy as char.

define new shared var invsite  as char.
define new shared var v_totso  as integer.
define new shared variable i3            as integer  no-undo.
define new shared variable i2            as integer  no-undo.
define variable subacct like  sod_sub.
define variable vpart like pt_part.
define variable vinv  like so_inv_nbr.
define variable inti as integer.
/*
 define temp-table solist
       fields solist_nbr like so_nbr.

{zzgtsolt.i "new"}
*/

define new shared workfile giv
 field ginv              as char
 field ginvx             as char
 field gdate             like gltr_eff_dt
 field gshipdate         like gltr_eff_dt
 field gref              as char
 field gtotamt           like glt_amt column-label "gtotamt"
 field gtaxamt           like glt_amt column-label "gtaxamt"
 field gnetamt           like glt_amt column-label "gnetamt"
 field gtaxpct           like usrw_decfld[1]
 field gcust             as   char format "x(8)"
 field gbill             as   char format "x(8)"
 field grmks             as char
 field gsite            as character
 field gnbr             as character
 field gmfgtotamt           like glt_amt column-label "gmfgtotamt"
 field gmfgtaxamt           like glt_amt column-label "gmfgtaxamt"
 field gmfgnetamt           like glt_amt column-label "gmfgnetamt"
 field gerrflag          as logical  initial no
 field gerrmsg           as character
 .

define new shared variable xsonbr like so_nbr.
define new shared workfile xinvd
  field x_ref as char     /*lb02*/
  field xnbr  like so_nbr
  field xinv  like so_inv_nbr
  field xline like sod_line
  field xpart like sod_part
  field xqty  like sod_qty_inv
  field xtot  like tx2d_totamt
  field xpric like sod_price
  field xtax  like tx2d_cur_tax_amt
  .

define new shared temp-table wrk_var       /*lb01*/
    field wrk_sonbr   like sod_nbr    /*lb01*/
    field wrk_line    like sod_line   /*lb01*/
    field wrk_qty_inv   like sod_qty_inv /*lb01*/
    field wrk_sched     like sod_sched   /*lb01*/
    index wrk_sonbr wrk_sonbr.          /*lb01*/


{zzgtos01.i}
{zzgt002.i new}

/* DISPLAY SELECTION FORM */
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A


form
  RECT-FRAME       AT ROW 1 COLUMN 1.25
  RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
  skip(1)
    v_gtaxid   label "�ӿڵ�λ"          colon 20 space(2) v_adname no-label
    v_infile   label "���������ļ�"  colon 20
    v_bkfile   label "������"            colon 20
    v_rpfile   label "�����ļ�"          colon 20
    v_ptbox    label "���˽��"      colon 20
    v_times    label "���ش���"          colon 20 skip(1)
    "�� �� � �� �� �� ��"   colon 16 skip(1)
    v_load     label "����(Y)/Ԥ��(N)"   colon 20
    v_adj      label "��������"          colon 20
    v_post     label "����"              colon 20 skip
    v_drange   label "�ݲ�"              colon 20
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.
 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


v_infilex = "invoice.txt".

maninloop:
repeat:

  for each giv:
    delete giv.
  end.
  for each xinvd:
    delete xinvd.
  end.
/*  for each sotax:   */
/*    delete sotax.   */
/*  end.              */
/*  for each solist:  */
/*    delete solist.  */
/*  end.              */
  find first usrw_wkfl where usrw_domain = global_domain
       and   usrw_key1 = "GOLDTAX-CTRL"
       and   lookup(global_userid,usrw_charfld[1]) <> 0
       no-lock no-error.
  if not available usrw_wkfl then do:
    message "����:��������û���趨/û�в���Ȩ��,����ϵϵͳ����Ա.".
    pause 3.
    leave.
  end.
  else do:
    {zzgt003.i}
    if v_box[1] = "" or
       v_box[2] = "" or
       v_box[3] = "" or
       v_box[4] = "" or
       v_box[5] = ""
    then do:
      message "����:�������ݴ���,����ϵϵͳ����Ա.".
      pause 3.
      leave.
    end.
  end.

  v_dt = today.
  v_inbox = v_box[2].
  v_bkbox = v_box[3].
  v_rpbox = v_box[4].
  v_ptbox = v_box[5].

  if v_name_date[1] <> today then v_times = 1.
                              else v_times = v_name_seq[1] + 1.

  if opsys = "unix" then do:
    if substr(v_bkbox,length(v_bkbox),1) <> "/" then v_bkbox = substr(v_bkbox,1,length(v_bkbox)) + "/".
    if substr(v_inbox,length(v_inbox),1) <> "/" then v_inbox = substr(v_inbox,1,length(v_inbox)) + "/".
    if substr(v_rpbox,length(v_rpbox),1) <> "/" then v_rpbox = substr(v_rpbox,1,length(v_rpbox)) + "/".
    if substr(v_ptbox,length(v_ptbox),1) <> "/" then v_ptbox = substr(v_ptbox,1,length(v_ptbox)) + "/".
  end.

  /* check directories exist */
  assign l_out = v_inbox + "TMP" +
                 string(time,"99999") + "." + string(random(0,999),"999").
  {gprun.i ""zzgtosdexi.p"" "(l_out, output l_dir_ok)"}.
  if not l_dir_ok then do:
    message "Warning: UNABLE TO WRITE TO:" + trim(v_inbox).
    pause 3.
    leave.
  end.
  assign l_out = v_bkbox + "TMP" +
                 string(time,"99999") + "." + string(random(0,999),"999").
  {gprun.i ""zzgtosdexi.p"" "(l_out, output l_dir_ok)"}.
  if not l_dir_ok then do:
    message "Warning: UNABLE TO WRITE TO:" + trim(v_bkbox).
    pause 3.
    leave.
  end.

  assign l_out = v_rpbox + "TMP" +
                 string(time,"99999") + "." + string(random(0,999),"999").
  {gprun.i ""zzgtosdexi.p"" "(l_out, output l_dir_ok)"}.
  if not l_dir_ok then do:
    message "Warning: UNABLE TO WRITE TO:" + trim(v_rpbox).
    pause 3.
    leave.
  end.

  assign l_out = v_ptbox + "TMP" +
                 string(time,"99999") + "." + string(random(0,999),"999").
  {gprun.i ""zzgtosdexi.p"" "(l_out, output l_dir_ok)"}.
  if not l_dir_ok then do:
    message "Warning: UNABLE TO WRITE TO:" + trim(v_ptbox).
    pause 3.
    leave.
  end.

  v_infilex = v_name_def[1].

  v_infile = substr(v_inbox,1,length(v_inbox))
             + v_infilex.

  v_bkfile = substr(v_bkbox,1,length(v_bkbox))
            + "in"
            + string(month(v_dt),"99")
            + string(day(v_dt),"99")
            + string(v_times,"99") + ".txt".

  v_rpfile = substr(v_rpbox,1,length(v_rpbox))
            + "in"
            + string(month(v_dt),"99")
            + string(day(v_dt),"99")
            + string(v_times,"99") + ".rpt".

  find first ad_mstr where ad_domain = global_domain and
             ad_addr = v_companyid no-lock no-error.
  if available ad_mstr then v_adname = ad_name.
                       else v_adname = "".

  display
         v_gtaxid v_adname v_infile v_bkfile v_rpfile v_times v_drange v_ptbox
  with frame a.

    assign v_adj = v_infixrd
           v_post = no.      /* v_inpost.2004-09-02 14:10*/
  update
        v_load
        v_adj
 /*      v_post    */
  with frame a.

  if v_load = no then do:
    v_adj = no.
    v_post = no.
  end.
  else do: /*lb01*2004-09-02 09:18*/
    if v_post and (not v_adj) then do:
      message "׼�����ˣ��Զ����ڲ���".
      pause.
    end.
  end.

  if search(v_infile) = ? then do:
      message "����:�����ļ�������.".
      undo , retry.
  end.

  /*load data to workfile*/
  input from value(v_infile) no-echo.
  repeat:
    update i = "".
    savepos = SEEK(input).
    import delimiter "~~" i.
    if substring(i[17],1,3) = "DC@" then do:  /* this is the headline */

    if i[1] <> "0" then  do:        /*����*/
       next.
     end.
      create giv.
      ginv = substr(i[9],1,length(i[9])).
      gdate = date(int(substr(i[13],5,2)),
                   int(substr(i[13],7,2)),
                   int(substr(i[13],1,4))).
      gref = substr(i[17],1,length(i[17])). /*���ݺ�*/
    /*
      gtotamt = decimal(i[19]).
      gtaxpct = decimal(i[21]).
      gtaxamt = round(gtotamt / ( 1 + gtaxpct) * gtaxpct ,2).
      gnetamt = gtotamt - gtaxamt.
    */
      gnetamt = decimal(i[19]).
      gtaxpct = decimal(i[21]).
      gtaxamt = decimal(i[23]).
      gtotamt = gnetamt + gtaxamt.
      grmks = substr(i[41],1,length(i[41])).
      ginvx = ginv.
      gnbr = substring(gref,4,8). /*2004-09-02 11:22*/
      seek input to savepos.
      import  unformatted strdummy.
      next.
    end.
    else if (available giv)
    and (substring(i[1],1,1) = "0")
    then do:  /*��Ʊ��ϸ��*/
      create xinvd.
      xnbr = substring(gref,4,8).
      xinv = ginv.
      x_ref = gref. /*lb02*/
      xpart = substr(i[5],1,length(i[5])).
  /*���������˻�ΪM7000 �������˻�ΪM1000*/
      vpart = xpart.
      find first sod_det no-lock where sod_domain = global_domain and sod_nbr = xnbr
           and sod_line = 1 no-error.
      if available sod_det then do:
         assign vpart = sod_part.
      end.

      find first code_mstr no-lock where code_domain = global_domain
            and code_fldname = "ZZGTSOL-SUB-ACCT"
            and code_value = "*" no-error.
      if available code_mstr then do:
         assign subacct = code_cmmt.
      end.
      find first code_mstr no-lock where code_domain = global_domain
            and code_fldname = "ZZGTSOL-SUB-ACCT"
            and vpart begins code_value no-error.
      if available code_mstr then do:
         assign subacct = code_cmmt.
      end.
      if vpart = "" then do:
         if vpart begins "so" then subacct = "M7000". else subacct = "M1000".
      end.
      xqty = decimal(i[9]).
      xtot = decimal(i[11]).
      xtax = decimal(i[15]).
      xpric = DECIMAL(i[17]).
    seek input to savepos.
    import  unformatted strdummy.
    end.
    else if (available giv) and
     (substring(i[1],1,1) = "1") then do:
 /*           create sotax.                             */
 /*           sotax_nbr = substring(gref,4,8).          */
 /*           sotax_part = "ZK".                        */
 /*           sotax_desc1 = i[3].                       */
 /*           sotax_inv = ginv.                         */
 /*           sotax_qty = -1.                           */
 /*           sotax_tot = decimal(i[11]).               */
 /*           sotax_tax = decimal(i[15]).               */
 /*           sotax_price = DECIMAL(i[17]).             */
 /*           sotax_sub = subacct.                      */
        gerrflag = yes.
        gerrmsg = "�����ۿ����ȷ�ϴ���״��".
    seek input to savepos.
    import  unformatted strdummy.
    end.
  end.
  input close.

/*   for each xinvd no-lock break by xnbr:                                                */
/*       if first-of(xnbr) then do:                                                       */
/*          create solist.                                                                */
/*          assign solist_nbr = xnbr.                                                     */
/*       end.                                                                             */
/*   end.                                                                                 */
/*                                                                                        */
/* for each solist no-lock,                                                               */
/*     each sod_det no-lock where sod_domain = global_domain                              */
/*      and sod_nbr = solist_nbr break by sod_nbr by sod_line:                            */
/*       find first xinvd exclusive-lock where xnbr = sod_nbr                             */
/*              and xpart = sod_part and xqty = sod_qty_inv and xline = 0 no-error.       */
/*       if available xinvd then do:                                                      */
/*          assign xline = sod_line.                                                      */
/*       end.                                                                             */
/* end.                                                                                   */
/*                                                                                        */
/* /* output to xinvd.txt.                         */                                     */
/*   for each xinvd no-lock:                                                              */
/* /*      display xinvd with width 300 stream-io. */                                     */
/*       find first sod_det no-lock where sod_domain = global_domain                      */
/*              and sod_nbr = xnbr and sod_line = xline no-error.                         */
/*       find first sotax exclusive-lock where sotax_nbr = xnbr                           */
/*              and sotax_line = xline no-error.                                          */
/*       if not available sotax then do:                                                  */
/*       create sotax.                                                                    */
/*       assign sotax_nbr  = xnbr                                                         */
/*              sotax_line = xline                                                        */
/*              sotax_inv  = xinv                                                         */
/*              sotax_part = xpart                                                        */
/*              sotax_qty  = xqty                                                         */
/*              sotax_tot  = xtot                                                         */
/*              sotax_price = xpric                                                       */
/*              sotax_so_price = sod_price when available sod_det.                        */
/*              sotax_tax  = xtax.                                                        */
/*       end.                                                                             */
/*   end.                                                                                 */
/* /* output close. */                                                                    */
 
/* for each sotax exclusive-lock where sotax_part = "ZK":                                 */
/*     for each sod_det no-lock WHERE sod_domain = global_domain                          */
/*          and sod_nbr = sotax_nbr break by sod_nbr by sod_line:                         */
/*          if first-of(sod_nbr) then do:                                                 */
/*             assign inti = 0.                                                           */
/*          end.                                                                          */
/*          if inti <= sod_line then inti = sod_line.                                     */
/*          if sod_part = sotax_part then do:                                             */
/*             assign sotax_line = sod_line.                                              */
/*          end.                                                                          */
/*          if last-of(sod_nbr) and sotax_line = 0 then do:                               */
/*             assign sotax_line = sod_line + 1.                                          */
/*          end.                                                                          */
/*     end.                                                                               */
/*     if sotax_line = 0 then assign sotax_line = 999.                                    */
/* end.                                                                                   */
/*                                                                                        */
/* /*   output to sotax.txt.                                        */                    */
/* /*      for each sotax no-lock:                                  */                    */
/* /*          display sotax with width 300 stream-io.              */                    */
/* /*      end.                                                     */                    */
/* /*   output close.                                               */                    */
/*                                                                                        */
/* /* FOR EACH tx2d_det NO-LOCK WHERE tx2d_domain = "dcec"                                */  */        
/* /*      AND tx2d_ref = "30410KF1" AND tx2d_tr_type = "13":                             */  */        
/* /*     DISPLAY tx2d_Line tx2d_totamt tx2d_tottax tx2d_cur_tax_amt tx2d_cur_recov_amt.  */  */        
/* /* END.                                                                                */  */        
/*                                                                                        */
/* if v_load then do:                                                                     */
/*          /*CIM_LOAD ��soivmt.p�޸�˰��Ϣ*/                                             */
/*         {gprun.i ""zzgtsoltc.p""}                                                      */
/* end.                                                                                   */
/*                                                                                        */
/* output to sotaxdiff.txt.                                                                      */
/* for each solist no-lock,                                                                      */
/*     each tx2d_det no-lock where tx2d_domain = global_domain                                   */
/*          and tx2d_ref = solist_nbr and tx2d_tr_type = "13",                                   */
/*     each sod_det no-lock where sod_domain = global_domain                                     */
/*          and sod_nbr = solist_nbr and sod_line = tx2d_line                                    */
/*     with frame sotaxdif width 300:                                                            */
/*     find first sotax no-lock where sotax_nbr = solist_nbr                                     */
/*            and sotax_line = tx2d_line no-error.                                               */
/*     if available sotax then do:                                                               */
/*         display tx2d_ref tx2d_line sod_part                                                   */
/*             sotax_tot + sotax_tax label "total A"                                             */
/*             tx2d_totamt when available tx2d_det                                               */
/*             sotax_tot + sotax_tax - tx2d_totamt label "TOT_DIF" when available tx2d_det       */
/*             sotax_tot tx2d_tottax when available tx2d_det                                     */
/*             sotax_tot - tx2d_tottax label "TAXBASE_DIF" when available tx2d_det               */
/*             sotax_tax tx2d_cur_tax_amt when available tx2d_det                                */
/*             sotax_tax - tx2d_cur_tax_amt label "TAX_DIF" when available tx2d_det              */
/*             sotax_price sotax_so_price @ sod_price                                            */
/*             sotax_price - sotax_so_price label "Price_Dif"                                    */
/*              with stream-io.                                                                  */
/*      end.                                                                                     */
/*      else do:                                                                                 */
/*         display tx2d_ref tx2d_line sod_part                                                   */
/*                 tx2d_totamt                                                                   */
/*                 tx2d_tottax                                                                   */
/*                 tx2d_cur_tax_amt                                                              */
/*                 sod_price with stream-io.                                                     */
/*      end.                                                                                     */
/* end.                                                                                          */
/* output close.                                                                                 */

  {mfselbpr.i "printer" 132}
    {mfphead.i}
  /*load into mfg*/
/*  {zzgtsola.i}  */

  do transaction: /*2004-09-02 11:07 */
    {gprun.i ""yygtsoll.p""}
  end.

/*   output stream rpt to xinvd2.txt.                                 */
/*     for each xinvd:                                                */
/*         display stream rpt xinvd with width 300 stream-io.         */
/*     end.                                                           */
/*   output stream rpt close.                                         */

  {mfrtrail.i}

end. /*main repeat*/
