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

/*��ʱ�����ڷָ�ʱ���*/
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

FUNCTION getMult RETURNS DECIMAL (qty as decimal, mult as decimal) :
/*------------------------------------------------------------------------------
  Purpose:  �Ա���Բ��.
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