/* xxbmpsrp10.p - bom runtime report                                         */
/* REVISION:101028.1 LAST MODIFIED: 10/28/10 BY: zy                          */
/* REVISION:110217.1 LAST MODIFIED: 02/17/11 BY: zy                      *2h**/
/*-Revision end--------------------------------------------------------------*/
/* Environment: Progress:10.C04   QAD:eb21sp6                                */
/*V8:ConvertMode=NoConvert                                                   */

/*** �˱�����ȷ���Ǹ�������vpart�µķ������Ҫ��ʾ�ڱ�����                ****/
define {1} shared temp-table levx no-undo
  fields levx_part like pt_part
  fields levx_set  like ro_setup
  fields levx_run  like ro_run
  fields levx_qty  like ps_qty_per.

/*�˱����ڴ洢�²����ϵĹ�ʱ׼��ʱ����ϸ*/
define {1} shared temp-table tmprun no-undo
  fields tmprun_part like pt_part
  fields tmprun_set  like ro_setup format "->>>>>>9.9<<<<<"
  index tmprun_part is primary tmprun_part.

/* �����ۼƼӹ�ʱ��*/
/* �õ��ı���tmpbomdet tmprundet*/
/* �õ���procedure�� gettmprundet gettmpbomdet getRunTime */

/*�˱����ڱ�����Ҫ���㹤ʱ�ϺŵĲ������*/
define {1} shared temp-table tmpbomdet no-undo
  fields tbd_part like ps_comp
  fields tbd_level as integer
  index tbd_part is primary tbd_part.

/*�˱����ڱ���ÿ���Ϻŵ��ۼӹ�ʱ*/
define {1} shared temp-table tmprundet no-undo
  fields trd_part like ro_routing
  fields trd_run  like ro_run
  index trd_part is primary trd_part.

/**�˱������ս��                                                          */
define {1} shared temp-table tmpbom no-undo
  fields tbm_sn   as   integer
  fields tbm_part like pt_part
  fields tbm_comp like pt_part
  fields tbm_pqty as decimal format "->>>>>>9.9<<<<"
  fields tbm_cqty as decimal format "->>>>>9.9<<<<"
  fields tbm_cost as decimal format "->>>>>9.9<<<<"
  fields tbm_set  as decimal format "->>>>>>9.9<<<<<"
  fields tbm_run  as decimal format "->>>>>>9.9<<<<<"
  fields tbm_mtl_cst as decimal format "->>>>>>9.9<<<<"
  fields tbm_lbr_cst as decimal format "->>>>>>9.9<<<<"
  fields tbm_bdn_cst as decimal format "->>>>>>9.9<<<<"
  fields tbm_cst     as decimal format "->>>>>>9.9<<<<"
  fields tbm_unit_cost as decimal format "->>>>>>>>9.9<<<<"
  fields tbm_setdif as decimal format "->>>>>>>>9.9<<<<"
  fields tbm_rundif as decimal format "->>>>>>>>9.9<<<<"
  fields tbm_wcset as decimal format "->>>>>>9.9<<<<<" extent 15
  fields tbm_wcrun as decimal format "->>>>>>9.9<<<<<" extent 15
  index tbm_part_comp is primary tbm_part tbm_comp.

/*�˱����ڴ洢BOM�������̵Ĺ�ʱ����*/
define temp-table tempb no-undo
  fields tmpb_par like ps_par
  fields tmpb_comp like ps_comp
  fields tmpb_wc   like ro_wkctr
  fields tmpb_sort as   integer
  fields tmpb_set  like ro_setup
  fields tmpb_run  like ro_run
  index tmpb_par_wc is primary tmpb_par tmpb_comp tmpb_wc
  index tmpb_comp_par tmpb_comp tmpb_par.
