@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'WO amount for ADV Rec items'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_RAB_ADV_REC_I_WO_AMT1 
    as select from  zmmt_scp_tnc1 as a1
    left outer join I_PurchaseOrderAPI01 as a2 on a1.ebeln = a2.PurchaseOrder 

{
  
  key a1.ebeln,
  
     cast( a1.zwork_done as abap.dec(13,2) ) as zwork_done,
     cast( a1.zmach_adv  as abap.dec(13,2) ) as zmach_adv,
     cast( a1.zmat_adv   as abap.dec(13,2) ) as zmat_adv,
     cast( a1.zmob_adv   as abap.dec(13,2) ) as zmob_adv,
     cast( a1.zroylt     as abap.dec(13,2) ) as zroylt,
     cast( a2.PurgReleaseTimeTotalAmount as abap.dec( 13, 2 ) ) as PurgReleaseTimeTotalAmount   
  
}
