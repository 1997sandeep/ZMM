@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'WO amount for ADV Rec items'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_RAB_ADV_REC_I_WO_AMT 
as select from ZMM_RAB_ADV_REC_I_WO_AMT1     as a1 
    left outer join ZMM_RAB_ADV_REC_I_WO_AMT1  as a4 on  a1.ebeln    = a4.ebeln

{
  
  key a1.ebeln,
  
     ( a1.PurgReleaseTimeTotalAmount * a4.zwork_done ) / 100 as zwork_amt,
     ( a1.PurgReleaseTimeTotalAmount * a4.zmach_adv ) / 100  as zmach_amt,
     ( a1.PurgReleaseTimeTotalAmount * a4.zmat_adv ) / 100 as zmat_amt,
     ( a1.PurgReleaseTimeTotalAmount * a4.zmob_adv ) / 100  as zmob_amt,
     ( a1.PurgReleaseTimeTotalAmount * a4.zroylt ) / 100   as zroylt_amt
   
  
}
