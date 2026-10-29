@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TDS Deduction against RABill No'
define root view entity ZMM_RABILL_PAY_DEDUCTION_TOTAL
  as select from ZMM_RABILL_PAY_DEDUCTION       as a
    inner join   zmmt_scp_pa_mas1               as b on a.ItemCode = b.itm_code
{
  key a.Rabillno         as RaBillNo,
  key a.Ebeln            as Ebeln,
  key b.sr_no_n          as SrNo,
      b.sr_no_c          as SrNumber,
      a.ItemCode         as ItemCode,
      b.description      as PaMasterDescription,
      a.GLAcc            as GLAcc,
      a.Tax              as Tax,
      a.zcurr            as zcurr,
      a.UpToDate         as UpToDate,
      a.UpToPreviousBill as UpToPreviousBill,
      a.ThisBill         as ThisBill,
      a.Remarks
}
group by
  a.Rabillno,
  a.Ebeln,
  b.sr_no_n,
  b.sr_no_c,
  a.ItemCode,
  b.description,
  a.GLAcc,
  a.Tax,
  a.zcurr,
  a.UpToPreviousBill,
  a.ThisBill,
  a.Remarks,
  a.UpToDate
