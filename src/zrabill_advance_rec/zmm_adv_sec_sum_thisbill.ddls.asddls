@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Summ of recovery till prev bill'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_ADV_SEC_SUM_THISBILL 
 as select from zmmt_scp_rab_rec

{
  key ebeln              as Ebeln,
  key adv_type           as AdvType,
      zcurr              as Zcurr,
      inv_no             as InvNo,
      inv_date           as InvDate,
      
      @Semantics.amount.currencyCode : 'zcurr'
      sum(per_work_done) as PerWorkDone,
      @Semantics.amount.currencyCode : 'zcurr'
      sum(rec_this_bill) as RecThisBill
      


}
//where
  //    $parameters.pwo   = ebeln
//  and $parameters.ptype = adv_type
group by
  ebeln,
  zcurr,
  adv_type,
  inv_no,
  inv_date
