FIND FIRST b_ex_cnt WHERE b_ex_site = {1} AND b_ex_loc = {2} NO-LOCK NO-ERROR.
IF AVAILABLE b_ex_cnt THEN do:
   MESSAGE {1} {2} '该地点库位处于盘点库存更新状态,不能操作该业务！' VIEW-AS ALERT-BOX. 
   LEAVE.
END.
