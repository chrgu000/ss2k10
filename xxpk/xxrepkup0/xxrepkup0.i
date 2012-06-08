/* xxrepkup0.i - REPETITIVE PICK LIST HARD ALLOCATIONS                       */
/*V8:ConvertMode=Maintenance                                                 */

define {1} shared temp-table tmp_ld
		fields tld_site like ld_site
		fields tld_part like ld_part
		fields tld_abc  like pt_abc
		fields tld_pk   like pt__qad20
		fields tld_tp   like pt__qad19
		fields tld_loc  like ld_loc
		fields tld_lot  like ld_lot
		fields tld_ref  like ld_ref
		fields tld_qty  like ld_qty_oh
		fields tld_sort as   character
		index tld_part tld_part tld_lot.

/*临时表用于分割时间段*/
DEFINE {1} SHARED TEMP-TABLE tmp_file0 no-undo
    FIELDS t0_date   LIKE rps_rel_date
    FIELDS t0_record LIKE rps_record
    FIELDS t0_site   LIKE si_site
    FIELDS t0_line   LIKE ln_line
    FIELDS t0_sn     AS   INTEGER
    FIELDS t0_part   LIKE pt_part
    FIELDS t0_wktime AS   DECIMAL
    FIELDS t0_tttime AS   DECIMAL
    FIELDS t0_time   AS   DECIMAL
    FIELDS t0_start  as   integer
    FIELDS t0_end    as   integer
    FIELDS t0_qtya   like rps_qty_req
    FIELDS t0_qty    like rps_qty_req
    FIELDS t0_user1  LIKE rps_user1
    INDEX t0_idx1 IS PRIMARY t0_date t0_site t0_line t0_user1.

DEFINE {1} SHARED TEMP-TABLE tmp_file1 no-undo
    FIELDS t1_sn LIKE xxlnw_sn
    FIELDS t1_start like xxlnw_stime
    fields t1_end   like xxlnw_etime
    fields t1_pick  like xxlnw_ptime
    FIELDS t1_avli AS DECIMAL.


/*临时表用于记录成品对应物料领料关系*/
define {1} SHARED temp-table xx_pklst no-undo
  fields xx_site like si_site
  fields xx_line like op_wkctr
  fields xx_nbr  as character format "x(10)"
  fields xx_comp like wod_part
  fields xx_qty_req like wod_qty_req
  fields xx_qty_need like wod_qty_req
  fields xx_qty_iss  like wod_qty_iss
  fields xx_um like pt_um
  fields xx_par  like wo_part
  fields xx_due_date like wo_due_date
  fields xx_op  like wr_op
  fields xx_mch like wr_mch
  fields xx_start like wr_start.

FORM  t0_date
/*    t0_record   */
      t0_site
      t0_line
      t0_sn
      t0_part
      t0_wktime
      t0_tttime
      t0_start
      t0_end
      t0_qtyA
      t0_qty
      t0_user1
with frame tmpfile0 width 300 down attr-space.

FORM  t0_date t0_site t0_line t0_part
      t0_wktime
      t0_tttime
      t0_start
      t0_end
      t0_qtya
      t0_qty
      xx_comp
      xx_qty_req
      xx_nbr
      xx_op
      xx_start
      t0_time
with frame detail001 width 300 down attr-space.

FUNCTION getMult RETURNS DECIMAL (qty as decimal, mult as decimal) :
/*------------------------------------------------------------------------------
  Purpose:  以倍数圆整.
    Notes:
------------------------------------------------------------------------------*/

  if mult <> 0 AND qty / mult <> truncate(qty / mult,0)
  then
      RETURN  MAX(qty,(truncate (qty / mult,0) + 1) * mult).
  ELSE
      RETURN qty.
END FUNCTION.

procedure getld:
		define input parameter iLine as character.
		define input parameter iPart as character.

end procedure.

/* run gett0(input today - 2 ,input today  ,           */
/*                     input "gsa01" ,input "gsa01" ,  */
/*                     input "HPS",input "HPS").       */
/*                                                     */
/* output to xxxxxssxx.txt.                            */
/*     for each tmp_file0:                             */
/*     display t0_date                                 */
/*             t0_record                               */
/*             t0_site                                 */
/*             t0_line                                 */
/*             t0_sn                                   */
/*             t0_part                                 */
/*             t0_wktime                               */
/*             t0_tttime                               */
/*             string(t0_start ,"hh:mm:ss") @ t0_start */
/*             string(t0_end ,"hh:mm:ss") @ t0_end     */
/*             t0_qtyA                                 */
/*             t0_qty                                  */
/*             t0_user1                                */
/*  with width 300 stream-io.                          */
/* end.                                                */
/* output close.                                       */
