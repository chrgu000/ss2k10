{mfdeclre.i}
{gplabel.i}

DEFINE INPUT PARAMETER prgm AS CHAR.
DEFINE INPUT PARAMETER bfid AS INTEGER.
DEFINE NEW SHARED VARIABLE cimcase AS CHAR. /*used to identify the cim program*/

 ASSIGN cimcase = prgm.

 CASE prgm:
     WHEN 'poporc.p' THEN
          {gprun.i ""mgwrfl01.p"" "(input bfid)"}

    WHEN 'iclotr02.p' THEN
          {gprun.i ""mgwrfl02.p"" "(input bfid)"}

    WHEN 'iclotr0201.p' THEN
          {gprun.i ""mgwrfl0201.p"" "(input bfid)"}

    WHEN 'icunis.p' THEN
          {gprun.i ""mgwrfl03.p"" "(input bfid)"}

    WHEN 'icunrc.p' THEN
          {gprun.i ""mgwrfl04.p"" "(input bfid)"}

     WHEN "rcshmt.p" THEN
            {gprun.i ""mgwrfl05.p"" "(input bfid)"}

     WHEN "iclotr04.p" THEN
            {gprun.i ""mgwrfl06.p"" "(input bfid)"}

    WHEN "rebkfl.p" THEN
            {gprun.i ""mgwrfl10.p"" "(INPUT bfid)"}

    WHEN "sosois.p" THEN 
            {gprun.i ""mgwrfl11.p"" "(input bfid)"}

    WHEN "wowoisrc.p" THEN
            {gprun.i ""mgwrfl12.p"" "(input bfid)"}

    WHEN "wowomt.p"  THEN
            {gprun.i ""mgwrfl13.p"" "(input bfid)"}

   WHEN "sfoptr01.p" THEN
            {gprun.i ""mgwrfl14.p"" "(input bfid)"}

END CASE.

   
