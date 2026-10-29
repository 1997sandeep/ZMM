@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MM - Advance Max amount'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zmm_scp_rab_adv_amt2 
as select from zmm_scp_rab_adv_amt1 as a
   left outer join I_PurchaseOrderAPI01 as b on a.Ebeln = b.PurchaseOrder
{
   key a.Ebeln,
   a.zmob_adv, 
   a.zmach_adv,
   a.zmat_adv,
   a.zwork_done,
   a.zroylt,
   cast( b.PurgReleaseTimeTotalAmount as abap.dec( 13, 2 )) as amt     
}
