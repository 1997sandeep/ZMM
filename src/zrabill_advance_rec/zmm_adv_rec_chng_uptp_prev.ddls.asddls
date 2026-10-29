@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Advance recovery item table'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_ADV_REC_CHNG_UPTP_PREV 
  as select from zmmt_scp_rab_rec as a1
{
//  key a1.ra_bill_no as RaBillNo,
  key a1.adv_type as AdvType,
  a1.ebeln as Ebeln,
    a1.zcurr,
  @Semantics.amount.currencyCode: 'zcurr'
  sum( a1.rec_this_bill ) as rec_this_bill
    
}
group by
    a1.zcurr,
    a1.adv_type,
    a1.ebeln
