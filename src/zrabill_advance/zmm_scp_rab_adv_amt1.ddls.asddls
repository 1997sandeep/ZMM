@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MM - Advance Max amount'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zmm_scp_rab_adv_amt1 
as select from ZMMT_SCP_RAB_ADV_CDS2 as b   
{
   key b.ebeln as Ebeln,
   b.zmob_adv / 100 as zmob_adv,
   b.zmach_adv / 100 as zmach_adv,
   b.zmat_adv / 100 as zmat_adv,
   b.zwork_done / 100 as zwork_done,
   b.zroylt / 100 as zroylt
   
}
