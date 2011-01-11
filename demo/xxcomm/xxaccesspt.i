/* SS - 110111.1 By: zhangyun */
/*------------------------------------------------------------------------
  File:
  Description: 根据物料字段控制用户权限。
  Input Parameters:
      <none>
  Output Parameters:
      <none>
------------------------------------------------------------------------*/

&if defined(accesspt) = 0 &then
function accesspt returns logical
        (input iPart as character,input iField as character):
/*------------------------------------------------------------------------------
  Purpose: 根据物料字段控制用户权限。
    Notes:
------------------------------------------------------------------------------*/
define variable fldval as character.
define variable ret as logical.
ret = no.
  for first pt_mstr no-lock where pt_domain = global_domain
        and pt_part = iPart:
  end.
  IF ifield = "pt_status" THEN DO:
      ASSIGN fldval = pt_status.
  END.
  ELSE IF ifield = "pt_prod_line" THEN DO:
      ASSIGN fldval = pt_prod_line.
  END.
  ELSE IF ifield = "pt_part_type" THEN DO:
      ASSIGN fldval = pt_part_type.
  END.
  ELSE IF ifield = "pt_dsgn_grp" THEN DO:
      ASSIGN fldval = pt_dsgn_grp.
  END.
  ELSE IF ifield = "pt_group" THEN DO:
      ASSIGN fldval = pt_group.
  END.
  ELSE IF ifield = "pt_promo" THEN DO:
      ASSIGN fldval = pt_promo.
  END.

  FOR FIRST code_mstr NO-LOCK WHERE code_domain = global_domain
      AND code_fldname = fldval
      AND (code_value = global_userid OR code_value = ""):
  END.
  IF AVAILABLE code_mstr THEN DO:
      ASSIGN ret = YES.
  END.

  return ret.
end function.
    &global-define accesspt ""
&endif
