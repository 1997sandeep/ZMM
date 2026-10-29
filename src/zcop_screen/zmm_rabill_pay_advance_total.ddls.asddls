@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Total Value Aginst WO in Advance'
define root view entity ZMM_RABILL_PAY_ADVANCE_TOTAL
  as select from ZMM_RABILL_PAY_ADVANCE  as a
    inner join   ZMM_RABILL_RABILLNO_WO1 as c on  a.Ebeln    = c.Ebeln
                                              and a.ItemCode = c.ItemCode
    inner join   zmmt_scp_pa_mas1        as b on a.ItemCode = b.itm_code //commented by WK:12.09.2023
{

  key c.RabillNo                   as RaBillNo,
  key c.Ebeln                      as Ebeln,
  key b.sr_no_n                    as SrNo,
      b.sr_no_c                    as SrNumber,
      a.ItemCode                   as ItemCode,
      b.description                as PaMasterDescription,
      cast( 0 as abap.dec( 6, 2 )) as Tax,
      b.gl_code                    as GLAcc,
      a.zcurr,
      @Semantics.amount.currencyCode : 'zcurr'
      c.UpToDate,
      @Semantics.amount.currencyCode : 'zcurr'
      c.UpToPreviousBill,
      @Semantics.amount.currencyCode : 'zcurr'
      c.ThisBill,
      a.Remarks
}
group by
  c.RabillNo,
  c.Ebeln,
  b.sr_no_n,
  b.sr_no_c,
  b.description,
  b.gl_code,
  a.zcurr,
  c.UpToDate,
  c.ThisBill,
  a.Remarks,
  c.UpToPreviousBill,
  a.ItemCode
