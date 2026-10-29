@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tax Calculation WO Rabill'
define root view entity ZMM_RABILL_PAY_WO_TAXC
    as select from    ZMM_RABILL_PAY_WO_TAX2 as a
{
  key a.RaBillNo,
  key a.Ebeln,
      a.SrNo,
      a.SrNumber,
      a.ItemCode,
      a.PaMasterDescription,
      a.TaxCode,
      a.GLAcc,
      a.zcurr,
      cast(a.Rate as abap.dec( 13, 2 ))                                     as Tax,
      cast(a.ThisBill as abap.dec( 13, 2 ))                                 as ThisBill,
      cast(a.UpToDate as abap.dec( 13, 2 ))                                 as UpToDate,
      cast(a.UpToPreviousBill as abap.dec( 13, 2 ))                         as UpToPreviousBill,
      a.Remarks
}
group by
  a.RaBillNo,
  a.Ebeln,
  a.SrNo,
  a.SrNumber,
  a.ItemCode,
  a.PaMasterDescription,
  a.TaxCode,
  a.GLAcc,
  a.zcurr,
  a.Rate,
  a.UpToDate,
  a.UpToPreviousBill,
  a.Remarks,
  a.ThisBill

