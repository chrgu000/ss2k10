/* xxbmpsrp10.p - bom runtime report                                         */
/* REVISION:101028.1 LAST MODIFIED: 10/28/10 BY: zy                          */
/* REVISION:110217.1 LAST MODIFIED: 02/17/11 BY: zy                      *2h**/
/*-Revision end--------------------------------------------------------------*/
/* Environment: Progress:10.C04   QAD:eb21sp6                                */
/*V8:ConvertMode=NoConvert                                                   */

/*** 此表用于确定那个材料是vpart下的非虚零件要显示在报表上                ****/
define {1} shared temp-table levx no-undo
  fields levx_part like pt_part
  fields levx_set  like ro_setup
  fields levx_run  like ro_run
  fields levx_qty  like ps_qty_per.

/*此表用于存储下层物料的工时准备时间明细*/
define {1} shared temp-table tmprun no-undo
  fields tmprun_part like pt_part
  fields tmprun_set  like ro_setup format "->>>>>>9.9<<<<<"
  index tmprun_part is primary tmprun_part.

/* 计算累计加工时间*/
/* 用到的表有tmpbomdet tmprundet*/
/* 用到的procedure有 gettmprundet gettmpbomdet getRunTime */

/*此表用于保存需要计算工时料号的层次数据*/
define {1} shared temp-table tmpbomdet no-undo
  fields tbd_part like ps_comp
  fields tbd_level as integer
  index tbd_part is primary tbd_part.

/*此表用于保存每个料号的累加工时*/
define {1} shared temp-table tmprundet no-undo
  fields trd_part like ro_routing
  fields trd_run  like ro_run
  index trd_part is primary trd_part.

/**此表保存最终结果                                                          */
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

/*此表用于存储BOM工艺流程的工时数据*/
define temp-table tempb no-undo
  fields tmpb_par like ps_par
  fields tmpb_comp like ps_comp
  fields tmpb_wc   like ro_wkctr
  fields tmpb_sort as   integer
  fields tmpb_set  like ro_setup
  fields tmpb_run  like ro_run
  index tmpb_par_wc is primary tmpb_par tmpb_comp tmpb_wc
  index tmpb_comp_par tmpb_comp tmpb_par.
