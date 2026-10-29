@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fetch for Calculation'
define root view entity ZMM_RABILL_PAY_ABSTRACT_FINAL1
  as select from    ZMM_MAS1_BASIC               as a
    left outer join ZMM_RABILL_PAY_ABSTRACT_MAX  as b on  a.Ebeln    = b.Ebeln
                                                      and a.ItemCode = b.ItemCode

    left outer join ZMM_RABILL_PAY_WO_UNION      as c on  a.RaBillNo = c.RaBillNo
                                                      and a.Ebeln    = c.Ebeln
                                                      and a.ItemCode = c.ItemCode

    left outer join ZMM_RABILL_PAY_RECOVERY_CV   as d on  a.RaBillNo = d.RaBillNo
                                                      and a.Ebeln    = d.Ebeln
                                                      and a.ItemCode = d.ItemCode

    left outer join ZMM_RABILL_PAY_DEDUCTION_CV  as e on  a.RaBillNo = e.RaBillNo
                                                      and a.Ebeln    = e.Ebeln
                                                      and a.ItemCode = e.ItemCode
    left outer join ZMM_RABILL_PAY_ADVANCE_UNION as f on  a.Ebeln    = f.Ebeln
                                                      and a.ItemCode = f.ItemCode
//    left outer join ZRABILL_Retention2 as ff on           a.Ebeln    = ff.ebeln
//                                                      and a.ItemCode = ff.ItemCode


{
  key a.RaBillNo,
      a.Ebeln,
      a.SrNo,
      a.SrNumber,
      a.ItemCode,
      a.PaMasterDescription,
      @Semantics.amount.currencyCode : 'zcurr'
      case a.Umskz
      when 'A'
      then cast(c.Tax as abap.dec( 6 , 2 ))
      when 'D'
      then cast(e.Tax as abap.dec( 6 , 2 ))
      else cast(0.00 as abap.dec(  6 , 2 ))
      end        as Tax,
      a.GlAcc,
      a.zcurr,
      @Semantics.amount.currencyCode : 'zcurr'
      b.UpToDate,
      @Semantics.amount.currencyCode : 'zcurr'
      b.UpToDate as UpToPreviousBill,
      case a.Umskz
      when 'A'
      then cast(c.ThisBill as abap.dec( 15, 2 ))
//      when 'C'
//      then cast(ff.retper as abap.dec( 15, 2))
      when 'C'
      then cast(d.ThisBill as abap.dec( 15, 2 ))
//       when 'C'
//      then cast(ff.retper as abap.dec( 15, 2))
      when 'D'
      then cast(e.ThisBill as abap.dec( 15, 2 ))
      else cast(0.00 as abap.dec( 15, 2 ))
      end        as ThisBill,
      a.Remarks
}
group by
  a.RaBillNo,
  a.Ebeln,
  a.SrNo,
  a.SrNumber,
  a.ItemCode,
  a.PaMasterDescription,
  a.Umskz,
  c.Tax,
  e.Tax,
  a.GlAcc,
  a.zcurr,
  b.UpToDate,
  c.ThisBill,
//  f.ThisBill,
  d.ThisBill,
  e.ThisBill,
  a.Remarks
//    ff.retper
