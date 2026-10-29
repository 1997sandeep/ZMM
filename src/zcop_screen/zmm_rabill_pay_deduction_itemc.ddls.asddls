@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Joining with Item Code View'
define root view entity ZMM_RABILL_PAY_DEDUCTION_ITEMC
  as select from    ZMM_RABILL_PAY_DEDUCTION_TOTAL as a
    left outer join ZMM_RABILL_PAY_WO_CALC         as b on a.RaBillNo = b.RaBillNo
//    left outer join ZRABILL_TDS_CAL_FINAL         as b on a.RaBillNo = b.ra_bill_no    ///add sandeep 30.06.25

{
  key a.RaBillNo,
  key a.Ebeln,
  key a.SrNo                                        as SrNo,
      a.SrNumber                                    as SrNumber,
      a.ItemCode                                    as ItemCode,
      a.PaMasterDescription                         as PaMasterDescription,
      a.Tax                                         as Tax,
      a.GLAcc                                       as GLAcc,
      a.zcurr                                       as zcurr,
//      @Semantics.amount.currencyCode: 'zcurr'
//      cast(cast((cast(b.ThisBill as abap.dec( 13, 2 ))
//      * (cast(a.Tax as abap.dec( 6, 2 )) / 100  ) ) as abap.char(20)) as abap.curr( 15, 2 )) as ThisBill,
//      (cast(b.THISBILL as abap.dec( 13, 2 ))
      (cast(b.ThisBill as abap.dec( 13, 2 ))
      * (cast(a.Tax as abap.dec( 6, 2 )) / 100  ) ) as ThisBill,
      a.UpToDate,
      a.UpToPreviousBill,
      a.Remarks
}
group by
  a.RaBillNo,
  a.Ebeln,
  a.SrNo,
  a.SrNumber,
  a.ItemCode,
  a.PaMasterDescription,
  a.GLAcc,
  a.zcurr,
  a.Tax,
  a.UpToDate,
  a.UpToPreviousBill,
  a.Remarks,
  b.ThisBill
