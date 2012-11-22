define {1} shared temp-table xxpk_det 
        field xxpk_user like pk_user
        field xxpk_part like pk_part
        field xxpk_ref  like pk_reference
        field xxpk_op   like ps_op.
define  temp-table zzpk_det 
              field  zzpk_user      like pk_user
              field  zzpk_part      like pk_part
/*G656*/      field  zzpk_reference like pk_reference
              field  zzpk_loc       like pk_loc
              field  zzpk_start     like pk_start
              field  zzpk_end       like pk_end 
              field  zzpk_lot   like pk_lot
              field  zzpk_user1 like pk_user1
              field  zzpk_user2 like pk_user2
              field  zzpk__qadc01 like pk__qadc01 
              field  zzpk_qty like pk_qty.