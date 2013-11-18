/* SS - 091127.1 By: Bill Jiang */

DEFINE {1} SHARED TEMP-TABLE ttwo
   FIELD ttwo_fpos LIKE xxice_fpos
   FIELD ttwo_ar LIKE xxicar_ar
   /*
   FIELD ttwo_site LIKE xxpcwo_site
   */
   FIELD ttwo_part LIKE xxpcwo_part
   FIELD ttwo_lot LIKE xxpcwo_lot
   FIELD ttwo_usage_tot LIKE xxicar_usage_tot
   FIELD ttwo_usage_pct LIKE xxicar_usage_tot
   INDEX ttwo_fpos_part_lot IS UNIQUE ttwo_fpos /* ttwo_site */ ttwo_part ttwo_lot
   INDEX ttwo_fpos ttwo_fpos
   .

DEFINE {1} SHARED TEMP-TABLE ttwo2
   FIELD ttwo2_fpos LIKE xxice_fpos
   FIELD ttwo2_usage_tot LIKE xxicar_usage_tot
   INDEX ttwo2_fpos IS UNIQUE ttwo2_fpos
   .
