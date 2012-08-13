/* xglogdef.i         定义cim日志临时表     */
/* create by: hou     2006.03.07            */

define {1} shared temp-table tt_log no-undo
   field tt_obj   as char
   field tt_id    as char
   field tt_desc  as char
   field tt_date  as date
   field tt_time  as char.
