@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Joining with Item Code View'
define root view entity ZMM_RABILL_PAY_RECOVERY_ITEMC
  as select from ZMM_RABILL_PAY_RECOVERY_TAX as a
    inner join   zmmt_scp_pa_mas1            as b on a.ItemCode = b.itm_code
{
  key a.RaBillNo    as RaBillNo,
  key a.Ebeln       as Ebeln,
  key b.sr_no_n     as SrNo,
      b.sr_no_c     as SrNumber,
      b.itm_code    as ItemCode,
      b.description as PaMasterDescription,
      a.Tax,
      b.gl_code     as GLAcc,
      a.zcurr,
      a.UpToDate,
      a.UpToPreviousBill,
      a.ThisBill,
      a.Remarks
}
