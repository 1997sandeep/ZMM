@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Recovery Itemlevel'
define root view entity ZMM_RABILL_PAY_WORKDONE_MTRE2 
as select from ZMM_RABILL_PAY_WORKDONE_MTRE1 as a 
    left outer join   zmmt_scp_pa_mas1            as b on a.ItemCode = b.itm_code
    left outer join   ZMM_RABILL_PAY_WO_LINK_MAS2 as c on a.Rabillno = c.RaBillNo 
    and a.ItemCode = c.ItemCode
{
  key a.Rabillno         as RaBillNo,
  key a.Ebeln            as Ebeln,
  key b.sr_no_n          as SrNo,
      b.sr_no_c          as SrNumber,
      a.ItemCode         as ItemCode,
      b.description      as PaMasterDescription,
      b.gl_code          as GLAcc,
      a.Tax              as Tax,
      a.zcurr            as zcurr,
      c.UpToDate         as UpToDate,
      c.UpToPreviousBill as UpToPreviousBill,
      c.ThisBill         as ThisBill,
      a.Remarks
}
group by
  a.Rabillno,
  a.Ebeln,
  b.sr_no_n,
  b.sr_no_c,
  a.ItemCode,
  b.description,
  b.gl_code,
  a.Tax,
  a.zcurr,
  c.UpToDate,
  c.UpToPreviousBill,
  c.ThisBill,
  a.Remarks
  
