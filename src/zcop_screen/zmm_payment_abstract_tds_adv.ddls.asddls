@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'tds posting in advance'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_PAYMENT_ABSTRACT_TDS_ADV
  as select from    zmmt_scp_rab_ad1 as a
    left outer join zmmt_scp_tnc1    as b on b.ebeln = a.ebeln
{
  key a.ra_bill_no,
      a.ebeln,
      sum(a.adv_paid) as Amount,
      b.zcurr,
      @Semantics.amount.currencyCode : 'zcurr'
      b.ztds
}
group by
    a.ra_bill_no,
    a.ebeln,
    b.zcurr,
    b.ztds

