    /*********************************************
        ����ĳ���߿��ų�ABC��������,B���ֱ����Ƿ��ų�,��Ӱ��AC��˳��,
        ����,��Ҫ���ų�(xln_used = yes),�ٸ������Ų��Ļ��ּ���˳��,
        ��������˳������Ӱ�����ʱ��,ÿ��Ҫ������! ??????
    *********************************************/

    
    
    
    /*����ÿ�����ߵ������Ų�˳��*/
    for each xln_det 
        where xln_site = site
        and   xln_used = yes /*��:���ų̵Ļ���,����xxpsmt01i08.i���ﲻ��ִ��*/
        break by xln_site by xln_line :
        if last-of(xln_line) then do:
            {gprun.i ""xxpsmt01p02.p""  "(input xln_site, input xln_line)"}
        end.
    end. /* for each xln_det */
