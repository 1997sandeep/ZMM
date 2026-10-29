@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Link Against GTBQ and MTRE'
define root view entity ZMM_RABILL_PAY_WO_LINK_MTRE
  as select from    ZMM_RABILL_PAY_WORKDONE      as a
    left outer join ZMM_RABILL_PAY_WORKDONE_MTRE as b on a.RaBillNo = b.RaBillNo
{
  key a.RaBillNo,
  key a.Ebeln,
  key a.SrNo,
      a.SrNumber,
      a.zcurr,
      @Semantics.amount.currencyCode: 'zcurr'
      a.ThisBill as GTBQ,
       @Semantics.amount.currencyCode: 'zcurr'
      b.ThisBill as MTRE
}
