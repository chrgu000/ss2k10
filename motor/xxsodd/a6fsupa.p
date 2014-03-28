/* gpfsupa.p - Sales Forecast consumption subroutine                    */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3      LAST MODIFIED: 05/07/96   BY: emb *G1V6* */
/* REVISION: 8.6      LAST MODIFIED: 04/13/98   BY: *J2JD* Sachin Shah  */
/* REVISION: 8.6E     LAST MODIFIED: 08/31/98   BY: *L084* A. Shobha    */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown   */
   {mfglobal.i}
     define input parameter fcspart as character no-undo.
     define input parameter fcssite as character no-undo.
     define input parameter fcsyear as integer no-undo.

     define shared variable grs like a6fcs_fcst_qty extent 156 no-undo.
     define shared variable net like a6fcs_fcst_qty extent 156 no-undo.

/*J2JD**     find a6fcs_sum no-lock where a6fcs_part = fcspart **/
/*J2JD**     and a6fcs_site = fcssite and a6fcs_year = fcsyear no-error. **/

/*J2JD*/ for first a6fcs_sum
/*J2JD*/ fields (a6fcs_fcst_qty a6fcs_part a6fcs_site a6fcs_sold_qty a6fcs_year)
/*J2JD*/ no-lock
/*J2JD*/ where a6fcs_domain = global_domain AND a6fcs_part = fcspart
/*J2JD*/   and a6fcs_site = fcssite
/*J2JD*/   and a6fcs_year = fcsyear : end.

     if available a6fcs_sum then do:

        /* Note: The following assign statements are intentionally
        structured as assignments of large numbers of values at once
        as a performance consideration enhancement.  Progress will
        usually perform better if the number of assign statements
        can be minimized -- particularly when dealing with database
        variable assignments, but also where local variables
        are concerned. */

        assign
         grs[105] = a6fcs_fcst_qty[1]
         grs[106] = a6fcs_fcst_qty[2]
         grs[107] = a6fcs_fcst_qty[3]
         grs[108] = a6fcs_fcst_qty[4]
         grs[109] = a6fcs_fcst_qty[5]
         grs[110] = a6fcs_fcst_qty[6]
         grs[111] = a6fcs_fcst_qty[7]
         grs[112] = a6fcs_fcst_qty[8]
         grs[113] = a6fcs_fcst_qty[9]
         grs[114] = a6fcs_fcst_qty[10]
         grs[115] = a6fcs_fcst_qty[11]
         grs[116] = a6fcs_fcst_qty[12]
         grs[117] = a6fcs_fcst_qty[13]
         grs[118] = a6fcs_fcst_qty[14]
         grs[119] = a6fcs_fcst_qty[15]
         grs[120] = a6fcs_fcst_qty[16]
         grs[121] = a6fcs_fcst_qty[17]
         grs[122] = a6fcs_fcst_qty[18]
         grs[123] = a6fcs_fcst_qty[19]
         grs[124] = a6fcs_fcst_qty[20]
         grs[125] = a6fcs_fcst_qty[21]
         grs[126] = a6fcs_fcst_qty[22]
         grs[127] = a6fcs_fcst_qty[23]
         grs[128] = a6fcs_fcst_qty[24]
         grs[129] = a6fcs_fcst_qty[25]
         grs[130] = a6fcs_fcst_qty[26]
         grs[131] = a6fcs_fcst_qty[27]
         grs[132] = a6fcs_fcst_qty[28]
         grs[133] = a6fcs_fcst_qty[29]
         grs[134] = a6fcs_fcst_qty[30]
         grs[135] = a6fcs_fcst_qty[31]
         grs[136] = a6fcs_fcst_qty[32]
         grs[137] = a6fcs_fcst_qty[33]
         grs[138] = a6fcs_fcst_qty[34]
         grs[139] = a6fcs_fcst_qty[35]
         grs[140] = a6fcs_fcst_qty[36]
         grs[141] = a6fcs_fcst_qty[37]
         grs[142] = a6fcs_fcst_qty[38]
         grs[143] = a6fcs_fcst_qty[39]
         grs[144] = a6fcs_fcst_qty[40]
         grs[145] = a6fcs_fcst_qty[41]
         grs[146] = a6fcs_fcst_qty[42]
         grs[147] = a6fcs_fcst_qty[43]
         grs[148] = a6fcs_fcst_qty[44]
         grs[149] = a6fcs_fcst_qty[45]
         grs[150] = a6fcs_fcst_qty[46]
         grs[151] = a6fcs_fcst_qty[47]
         grs[152] = a6fcs_fcst_qty[48]
         grs[153] = a6fcs_fcst_qty[49]
         grs[154] = a6fcs_fcst_qty[50]
         grs[155] = a6fcs_fcst_qty[51]
         grs[156] = a6fcs_fcst_qty[52].

         assign
         net[105] = a6fcs_fcst_qty[01] - a6fcs_sold_qty[01]
         net[106] = a6fcs_fcst_qty[02] - a6fcs_sold_qty[02]
         net[107] = a6fcs_fcst_qty[03] - a6fcs_sold_qty[03]
         net[108] = a6fcs_fcst_qty[04] - a6fcs_sold_qty[04]
         net[109] = a6fcs_fcst_qty[05] - a6fcs_sold_qty[05]
         net[110] = a6fcs_fcst_qty[06] - a6fcs_sold_qty[06]
         net[111] = a6fcs_fcst_qty[07] - a6fcs_sold_qty[07]
         net[112] = a6fcs_fcst_qty[08] - a6fcs_sold_qty[08]
         net[113] = a6fcs_fcst_qty[09] - a6fcs_sold_qty[09]
         net[114] = a6fcs_fcst_qty[10] - a6fcs_sold_qty[10]
         net[115] = a6fcs_fcst_qty[11] - a6fcs_sold_qty[11]
         net[116] = a6fcs_fcst_qty[12] - a6fcs_sold_qty[12]
         net[117] = a6fcs_fcst_qty[13] - a6fcs_sold_qty[13]
         net[118] = a6fcs_fcst_qty[14] - a6fcs_sold_qty[14]
         net[119] = a6fcs_fcst_qty[15] - a6fcs_sold_qty[15]
         net[120] = a6fcs_fcst_qty[16] - a6fcs_sold_qty[16]
         net[121] = a6fcs_fcst_qty[17] - a6fcs_sold_qty[17]
         net[122] = a6fcs_fcst_qty[18] - a6fcs_sold_qty[18]
         net[123] = a6fcs_fcst_qty[19] - a6fcs_sold_qty[19]
         net[124] = a6fcs_fcst_qty[20] - a6fcs_sold_qty[20]
         net[125] = a6fcs_fcst_qty[21] - a6fcs_sold_qty[21]
         net[126] = a6fcs_fcst_qty[22] - a6fcs_sold_qty[22]
         net[127] = a6fcs_fcst_qty[23] - a6fcs_sold_qty[23]
         net[128] = a6fcs_fcst_qty[24] - a6fcs_sold_qty[24]
         net[129] = a6fcs_fcst_qty[25] - a6fcs_sold_qty[25]
         net[130] = a6fcs_fcst_qty[26] - a6fcs_sold_qty[26]
         net[131] = a6fcs_fcst_qty[27] - a6fcs_sold_qty[27]
         net[132] = a6fcs_fcst_qty[28] - a6fcs_sold_qty[28]
         net[133] = a6fcs_fcst_qty[29] - a6fcs_sold_qty[29]
         net[134] = a6fcs_fcst_qty[30] - a6fcs_sold_qty[30]
         net[135] = a6fcs_fcst_qty[31] - a6fcs_sold_qty[31]
         net[136] = a6fcs_fcst_qty[32] - a6fcs_sold_qty[32]
         net[137] = a6fcs_fcst_qty[33] - a6fcs_sold_qty[33]
         net[138] = a6fcs_fcst_qty[34] - a6fcs_sold_qty[34]
         net[139] = a6fcs_fcst_qty[35] - a6fcs_sold_qty[35]
         net[140] = a6fcs_fcst_qty[36] - a6fcs_sold_qty[36]
         net[141] = a6fcs_fcst_qty[37] - a6fcs_sold_qty[37]
         net[142] = a6fcs_fcst_qty[38] - a6fcs_sold_qty[38]
         net[143] = a6fcs_fcst_qty[39] - a6fcs_sold_qty[39]
         net[144] = a6fcs_fcst_qty[40] - a6fcs_sold_qty[40]
         net[145] = a6fcs_fcst_qty[41] - a6fcs_sold_qty[41]
         net[146] = a6fcs_fcst_qty[42] - a6fcs_sold_qty[42]
         net[147] = a6fcs_fcst_qty[43] - a6fcs_sold_qty[43]
         net[148] = a6fcs_fcst_qty[44] - a6fcs_sold_qty[44]
         net[149] = a6fcs_fcst_qty[45] - a6fcs_sold_qty[45]
         net[150] = a6fcs_fcst_qty[46] - a6fcs_sold_qty[46]
         net[151] = a6fcs_fcst_qty[47] - a6fcs_sold_qty[47]
         net[152] = a6fcs_fcst_qty[48] - a6fcs_sold_qty[48]
         net[153] = a6fcs_fcst_qty[49] - a6fcs_sold_qty[49]
         net[154] = a6fcs_fcst_qty[50] - a6fcs_sold_qty[50]
         net[155] = a6fcs_fcst_qty[51] - a6fcs_sold_qty[51]
         net[156] = a6fcs_fcst_qty[52] - a6fcs_sold_qty[52].

     end.
     else do:

        assign
         grs[105] = 0 grs[106] = 0 grs[107] = 0 grs[108] = 0
         grs[109] = 0 grs[110] = 0 grs[111] = 0 grs[112] = 0
         grs[113] = 0 grs[114] = 0 grs[115] = 0 grs[116] = 0
         grs[117] = 0 grs[118] = 0 grs[119] = 0 grs[120] = 0
         grs[121] = 0 grs[122] = 0 grs[123] = 0 grs[124] = 0
         grs[125] = 0 grs[126] = 0 grs[127] = 0 grs[128] = 0
         grs[129] = 0 grs[130] = 0 grs[131] = 0 grs[132] = 0
         grs[133] = 0 grs[134] = 0 grs[135] = 0 grs[136] = 0
         grs[137] = 0 grs[138] = 0 grs[139] = 0 grs[140] = 0
         grs[141] = 0 grs[142] = 0 grs[143] = 0 grs[144] = 0
         grs[145] = 0 grs[146] = 0 grs[147] = 0 grs[148] = 0
         grs[149] = 0 grs[150] = 0 grs[151] = 0 grs[152] = 0
         grs[153] = 0 grs[154] = 0 grs[155] = 0 grs[156] = 0

         net[105] = 0 net[106] = 0 net[107] = 0 net[108] = 0
         net[109] = 0 net[110] = 0 net[111] = 0 net[112] = 0
         net[113] = 0 net[114] = 0 net[115] = 0 net[116] = 0
         net[117] = 0 net[118] = 0 net[119] = 0 net[120] = 0
         net[121] = 0 net[122] = 0 net[123] = 0 net[124] = 0
         net[125] = 0 net[126] = 0 net[127] = 0 net[128] = 0
         net[129] = 0 net[130] = 0 net[131] = 0 net[132] = 0
         net[133] = 0 net[134] = 0 net[135] = 0 net[136] = 0
         net[137] = 0 net[138] = 0 net[139] = 0 net[140] = 0
         net[141] = 0 net[142] = 0 net[143] = 0 net[144] = 0
         net[145] = 0 net[146] = 0 net[147] = 0 net[148] = 0
         net[149] = 0 net[150] = 0 net[151] = 0 net[152] = 0
         net[153] = 0 net[154] = 0 net[155] = 0 net[156] = 0.

     end.
