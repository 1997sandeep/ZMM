@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Link Against MTRE and SRNO'
define root view entity ZMM_RABILL_PAY_WO_LINK_MAS2
  as select from ZMM_RABILL_PAY_WORKDONE_MTRE as a
    inner join   zmmt_scp_pa_mas1             as b on a.ItemCode = b.itm_code
{
  key a.RaBillNo         as RaBillNo,
  key a.Ebeln            as Ebeln,
  key b.sr_no_n          as SrNo,
      b.sr_no_c          as SrNumber,
      a.ItemCode         as ItemCode,
      b.description      as PaMasterDescription,
      //      a.GLAcc            as GLAcc, "commented on 11.08.2023
      b.gl_code          as GLAcc,
      a.Tax              as Tax,
      a.zcurr            as zcurr,
      a.UpToDate         as UpToDate,
      a.UpToPreviousBill as UpToPreviousBill,
      a.ThisBill         as ThisBill,
      a.Remarks
}
group by
  a.RaBillNo,
  a.Ebeln,
  b.sr_no_n,
  b.sr_no_c,
  a.ItemCode,
  b.description,
  //  a.GLAcc,
  b.gl_code,
  a.Tax,
  a.zcurr,
  a.UpToPreviousBill,
  a.ThisBill,
  a.Remarks,
  a.UpToDate
