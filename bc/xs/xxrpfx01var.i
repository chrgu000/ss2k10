

DEFINE {1} SHARED VARIABLE eff_date       AS CHARACTER.
DEFINE {1} SHARED VARIABLE eff_date1      AS DATE.

DEFINE {1} SHARED VARIABLE eff_time       AS CHARACTER.

DEFINE {1} SHARED VARIABLE budgetcode     LIKE CODE_value FORMAT "x(16)" .
DEFINE {1} SHARED VARIABLE budgetset      LIKE cs_set      .
DEFINE {1} SHARED VARIABLE standardset    LIKE cs_set      .
DEFINE {1} SHARED VARIABLE site          LIKE si_site.



DEFINE {1} SHARED TEMP-TABLE ttsod_det   
                  FIELD ttsod_year        AS CHARACTER
                  FIELD ttsod_month       AS CHARACTER
                  FIELD ttsod_day         AS CHARACTER
                  FIELD ttsod_time        AS CHARACTER
                  FIELD ttsod_seq         AS CHARACTER
                  FIELD ttsod_part        AS  CHARACTER
                  FIELD ttsod_qty         AS CHARACTER
                  FIELD ttsod_ck          AS CHARACTER
                  FIELD ttsod_rmks       AS CHARACTER
                  INDEX ttsod_time ttsod_time.


DEFINE {1} SHARED TEMP-TABLE ttlbfxt   
                  FIELD ttlbfxt_cmmt        AS CHARACTER FORMAT "x(100)".

DEFINE {1} SHARED VARIABLE vv_sum_ttsod    AS INTEGER.

DEFINE {1} SHARED VARIABLE vv_i    AS INTEGER.

DEFINE {1} SHARED VARIABLE vv_filename     AS CHARACTER.

DEFINE {1} SHARED VARIABLE v_mem AS MEMPTR.
