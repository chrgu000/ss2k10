/* gpfsupb.p - Sales Forecast consumption subroutine                    */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3      LAST MODIFIED: 05/07/96   BY: emb *G1V6* */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown   */

     define shared variable grs like a6fcs_fcst_qty extent 156 no-undo.
     define shared variable net like a6fcs_fcst_qty extent 156 no-undo.

     /* Note: The following assign statements are intentionally
     structured as assignments of large numbers of values at once
     as a performance consideration enhancement.  Progress will
     usually perform better if the number of assign statements
     can be minimized -- particularly when dealing with database
     variable assignments, but also where local variables
     are concerned. */

     assign
        grs[01] = grs[53] grs[02] = grs[54] grs[03] = grs[55]
        grs[04] = grs[56] grs[05] = grs[57] grs[06] = grs[58]
        grs[07] = grs[59] grs[08] = grs[60] grs[09] = grs[61]
        grs[10] = grs[62] grs[11] = grs[63] grs[12] = grs[64]
        grs[13] = grs[65] grs[14] = grs[66] grs[15] = grs[67]
        grs[16] = grs[68] grs[17] = grs[69] grs[18] = grs[70]
        grs[19] = grs[71] grs[20] = grs[72] grs[21] = grs[73]
        grs[22] = grs[74] grs[23] = grs[75] grs[24] = grs[76]
        grs[25] = grs[77] grs[26] = grs[78] grs[27] = grs[79]
        grs[28] = grs[80] grs[29] = grs[81] grs[30] = grs[82]
        grs[31] = grs[83] grs[32] = grs[84] grs[33] = grs[85]
        grs[34] = grs[86] grs[35] = grs[87] grs[36] = grs[88]
        grs[37] = grs[89] grs[38] = grs[90] grs[39] = grs[91]
        grs[40] = grs[92] grs[41] = grs[93] grs[42] = grs[94]
        grs[43] = grs[95] grs[44] = grs[96] grs[45] = grs[97]
        grs[46] = grs[98] grs[47] = grs[99] grs[48] = grs[100]
        grs[49] = grs[101] grs[50] = grs[102] grs[51] = grs[103]
        grs[52] = grs[104]

        net[01] = net[53] net[02] = net[54] net[03] = net[55]
        net[04] = net[56] net[05] = net[57] net[06] = net[58]
        net[07] = net[59] net[08] = net[60] net[09] = net[61]
        net[10] = net[62] net[11] = net[63] net[12] = net[64]
        net[13] = net[65] net[14] = net[66] net[15] = net[67]
        net[16] = net[68] net[17] = net[69] net[18] = net[70]
        net[19] = net[71] net[20] = net[72] net[21] = net[73]
        net[22] = net[74] net[23] = net[75] net[24] = net[76]
        net[25] = net[77] net[26] = net[78] net[27] = net[79]
        net[28] = net[80] net[29] = net[81] net[30] = net[82]
        net[31] = net[83] net[32] = net[84] net[33] = net[85]
        net[34] = net[86] net[35] = net[87] net[36] = net[88]
        net[37] = net[89] net[38] = net[90] net[39] = net[91]
        net[40] = net[92] net[41] = net[93] net[42] = net[94]
        net[43] = net[95] net[44] = net[96] net[45] = net[97]
        net[46] = net[98] net[47] = net[99] net[48] = net[100]
        net[49] = net[101] net[50] = net[102] net[51] = net[103]
        net[52] = net[104].

     assign
        grs[53] = grs[105] grs[54] = grs[106] grs[55] = grs[107]
        grs[56] = grs[108] grs[57] = grs[109] grs[58] = grs[110]
        grs[59] = grs[111] grs[60] = grs[112] grs[61] = grs[113]
        grs[62] = grs[114] grs[63] = grs[115] grs[64] = grs[116]
        grs[65] = grs[117] grs[66] = grs[118] grs[67] = grs[119]
        grs[68] = grs[120] grs[69] = grs[121] grs[70] = grs[122]
        grs[71] = grs[123] grs[72] = grs[124] grs[73] = grs[125]
        grs[74] = grs[126] grs[75] = grs[127] grs[76] = grs[128]
        grs[77] = grs[129] grs[78] = grs[130] grs[79] = grs[131]
        grs[80] = grs[132] grs[81] = grs[133] grs[82] = grs[134]
        grs[83] = grs[135] grs[84] = grs[136] grs[85] = grs[137]
        grs[86] = grs[138] grs[87] = grs[139] grs[88] = grs[140]
        grs[89] = grs[141] grs[90] = grs[142] grs[91] = grs[143]
        grs[92] = grs[144] grs[93] = grs[145] grs[94] = grs[146]
        grs[95] = grs[147] grs[96] = grs[148] grs[97] = grs[149]
        grs[98] = grs[150] grs[99] = grs[151] grs[100] = grs[152]
        grs[101] = grs[153] grs[102] = grs[154] grs[103] = grs[155]
        grs[104] = grs[156]

        net[53] = net[105] net[54] = net[106] net[55] = net[107]
        net[56] = net[108] net[57] = net[109] net[58] = net[110]
        net[59] = net[111] net[60] = net[112] net[61] = net[113]
        net[62] = net[114] net[63] = net[115] net[64] = net[116]
        net[65] = net[117] net[66] = net[118] net[67] = net[119]
        net[68] = net[120] net[69] = net[121] net[70] = net[122]
        net[71] = net[123] net[72] = net[124] net[73] = net[125]
        net[74] = net[126] net[75] = net[127] net[76] = net[128]
        net[77] = net[129] net[78] = net[130] net[79] = net[131]
        net[80] = net[132] net[81] = net[133] net[82] = net[134]
        net[83] = net[135] net[84] = net[136] net[85] = net[137]
        net[86] = net[138] net[87] = net[139] net[88] = net[140]
        net[89] = net[141] net[90] = net[142] net[91] = net[143]
        net[92] = net[144] net[93] = net[145] net[94] = net[146]
        net[95] = net[147] net[96] = net[148] net[97] = net[149]
        net[98] = net[150] net[99] = net[151] net[100] = net[152]
        net[101] = net[153] net[102] = net[154] net[103] = net[155]
        net[104] = net[156].
