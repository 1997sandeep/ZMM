@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MM - Advance WO Max amt'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_RAB_ADV_WOMAX  
as select distinct from zmm_scp_rab_adv_amt4
{
    
    key Ebeln ,
        'AGWD' as AdvType,
        zwork_done as WoPerMax 
//        case a1.adv_type
//        when 'AGWD' then a3.zwork_done
//        when 'MACH' then a3.zmach_adv
//        when 'MATR' then a3.zmat_adv
//        when 'MOBI' then a3.zmob_adv
//        when 'ROYL' then a3.zroylt
//        end as WoPerMax 
    
}
union all 

select from zmm_scp_rab_adv_amt4 
{
    
    key Ebeln ,
        'MACH' as AdvType,
        zmach_adv as WoPerMax     
}
union all 

select from zmm_scp_rab_adv_amt4 
{
    
    key Ebeln ,
        'MATR' as AdvType,
        zmat_adv as WoPerMax     
}
union all 

select from zmm_scp_rab_adv_amt4 
{
    
    key Ebeln ,
        'MOBI' as AdvType,
        zmob_adv as WoPerMax     
}
////union all 
////
////select from zmm_scp_rab_adv_amt4 
////{
////    
////    key Ebeln ,
////        'ROYL' as AdvType,
////        zroylt as WoPerMax     
////}
