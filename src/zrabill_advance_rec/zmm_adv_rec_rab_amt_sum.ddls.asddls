@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Summation of RaBill Amount'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_ADV_REC_RAB_AMT_SUM 
as select from zmmt_scp_rabill1

{

  key ebeln              as Ebeln,
  key rcount             as Rcount,
      @Semantics.amount.currencyCode : 'zcurr'
      sum(this_bill_amt) as ThisBillAmt,
      @Semantics.amount.currencyCode : 'zcurr'
      sum(upto_date_amt) as UptoDateAmt,
      zcurr              as Zcurr,
      ra_bill_from       as RaBillFrom,
      ra_bill_to         as RaBillTo
}
group by
  ebeln,
  rcount,
  zcurr,
  ra_bill_from,
  ra_bill_to
