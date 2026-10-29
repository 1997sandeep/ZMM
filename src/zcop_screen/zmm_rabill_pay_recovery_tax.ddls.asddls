@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Total Value Aginst WO in Recovery'
define root view entity ZMM_RABILL_PAY_RECOVERY_TAX
  as select from ZMM_RABILL_PAY_RECOVERY        as a
   inner join   zmmt_scp_pa_mas1       as b on a.ItemCode = b.itm_code
{

  key a.RaBillNo                   as RaBillNo,
  key a.Ebeln                      as Ebeln,
  key b.sr_no_n                    as SrNo,
      b.sr_no_c                    as SrNumber,
      a.ItemCode                   as ItemCode,
      b.description                as PaMasterDescription,
      cast( 0 as abap.dec( 6, 2 )) as Tax,
      b.gl_code                    as GLAcc,
      a.zcurr,
      @Semantics.amount.currencyCode : 'zcurr'
      a.UpToDate,
      @Semantics.amount.currencyCode : 'zcurr'
      a.UpToPreviousBill,
      @Semantics.amount.currencyCode : 'zcurr'
      a.ThisBill,
      a.Remarks
}
group by
  a.RaBillNo,
  a.Ebeln,
  b.sr_no_n,
  b.sr_no_c,
  b.description,
  b.gl_code,
  a.zcurr,
  a.UpToDate,
  a.ThisBill,
  a.Remarks,
  a.UpToPreviousBill,
  a.ItemCode
