/* xxpiptld.p - piptcr.p cim load                                            */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 140218.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */
/****模板*********************************************************************
 * NO,区域(库位),资产区分,图号,名称,批号,计算过程,数量,称,实物抽查核对,录抽查核
 * 1,4RSA,M5C019-K10-2-CK,阀片磐石,140125,87,,,
 * 2,4RSA,M5C209-559-12-CK,"螺栓 M6,岩田P/T",140125,44,,,
 ****************************************************************************/
{mfdeclre.i}
{xxpiptld.i}
define variable txt as character.
define variable vsite like si_site initial "GSA01".
define variable i as integer.
define variable vsn as character.
define variable vloc like loc_loc.
define variable vpart like pt_part.
define variable vserial like tag_mstr.tag_serial.
define variable vqty as character.
define variable vchk as logical.
find first icc_ctrl where no-lock no-error.
if available icc_ctrl then do:
   assign vsite = icc_site.
end.

empty temp-table b_tag no-error.
input from value(flhload).
repeat:
/*     import unformat txt.                                              */
/*     assign vsn = trim(entry(1,txt,",")) no-error.                     */
/*     assign vloc = trim(entry(2,txt,",")) no-error.                    */
/*     assign vpart = trim(entry(4,txt,",")) no-error.                   */
/*     assign vserial = trim(entry(6,txt,",")) no-error.                 */
/*     assign vqty  = trim(entry(8,txt,",")) no-error.                   */
    import delimiter "," vsn vloc txt vpart txt vserial txt vqty.
    if vloc <> "" and vpart <> "" then do:
         assign vchk = yes.
         DO i = 1 to length(vsn).
            If index("0987654321", substring(vsn,i,1)) = 0 then do:
               assign vchk = no.
            end.
         end.
         assign vchk = yes.
         DO i = 1 to length(vqty).
            If index("0987654321.", substring(vqty,i,1)) = 0 then do:
               assign vchk = no.
            end.
         end.
         if vchk then do:
            find first b_tag exclusive-lock
                 where b_tag.tag_part = vpart
                   and b_tag.tag_site = vsite
                   and b_tag.tag_loc = vloc
                   and b_tag.tag_lot = vserial no-error.
            if not available b_tag then do:
                  create b_tag.
                  assign b_tag.tag_sn = integer(vsn)
                         b_tag.tag_part = vpart
                         b_tag.tag_site = vsite
                         b_tag.tag_loc = vloc
                         b_tag.tag_lot = vserial.
            end.
            assign b_tag.tag_qty_ld = b_tag.tag_qty_ld + decimal(vqty).
         end. /* if vchk then do: */
     end. /* if vloc <> "" and vpart <> "" then do: */
end.
input close.

for each b_tag exclusive-lock where b_tag.tag_part > "ZZZZZZZZZZZZZZZZZZ":
delete b_tag.
end.

/*****检查可能的错误*********/
for each b_tag exclusive-lock:
    find first pt_mstr no-lock where pt_part = b_tag.tag_part no-error.
    if not available pt_mstr then do:
       assign tag_chk = getmsg(17).
    end.
    find first loc_mstr no-lock where loc_site = b_tag.tag_site
           and loc_loc = b_tag.tag_loc no-error.
    if not available loc_mstr then do:
       assign tag_chk = getMsg(709).
    end.
    if b_tag.tag_serial >= "ZZZZZZZZZZZZZZZZ" then do:
       assign tag_chk = getMsg(2741).
    end.
end.

/* 产生tag_nbr */

for each b_tag exclusive-lock where tag_chk = "":
    find first tag_mstr use-index tag_pslsn no-lock where
               tag_mstr.tag_part = b_tag.tag_part and
               tag_mstr.tag_site = b_tag.tag_site and
               tag_mstr.tag_loc = b_tag.tag_loc and
               tag_mstr.tag_ref = "" no-error.
    if available tag_mstr then do:
         assign b_tag.tag_nbr = tag_mstr.tag_nbr
    b_tag.tag_serial = tag_mstr.tag_serial
    b_tag.tag_qty_doc = tag_mstr.tag_cnt_qty.
    end.
    else do:
   assign b_tag.tag_serial = b_tag.tag_lot.
    end.
end.

assign vtag = 1.
find last tag_mstr where tag_mstr.tag_nbr >= 0 no-lock no-error.
       if available tag_mstr then vtag = tag_mstr.tag_nbr + 1.
assign i = vtag.
for each b_tag exclusive-lock where tag_chk = "" and b_tag.tag_nbr = 0 by tag_sn:
    assign b_tag.tag_nbr = i.
    assign i = i + 1.
end.

for each b_tag exclusive-lock:
    if b_tag.tag_nbr > 99999999 then do:
       assign tag_chk = getMsg(1571).
    end.
end.

for each b_tag exclusive-lock:
    b_tag.tag_cnt_qty = b_tag.tag_qty_ld + b_tag.tag_qty_doc.
end.
