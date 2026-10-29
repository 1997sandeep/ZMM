@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fetch for Calculation Advance Part'
define root view entity ZMM_RABILL_PAY_ABSTRACT_FINAL2
  as select from    ZMM_MAS1_BASIC1              as a
    left outer join ZMM_RABILL_PAY_ABSTRACT_MAX  as b on  a.Ebeln    = b.Ebeln
                                                      and a.ItemCode = b.ItemCode
    left outer join ZMM_RABILL_PAY_ADVANCE_UNION as f on  a.Ebeln    = f.Ebeln
                                                      and a.ItemCode = f.ItemCode
                                                      and a.RaBillNo = f.RaBillNo
    left outer join ZMM_RABILL_PAY_MAS1_CV       as e on  a.Ebeln    = e.Ebeln
                                                      and a.ItemCode = e.ItemCode
                                                      and a.RaBillNo = e.RaBillNo



{
  key a.RaBillNo,
      a.Ebeln,
      a.SrNo,
      a.SrNumber,
      a.ItemCode,
      a.PaMasterDescription,
      @Semantics.amount.currencyCode : 'zcurr'
      //            a.Tax,
      case a.Umskz
      when 'D'
      then cast(max(e.Tax) as abap.dec(6,2))
      //      then cast(e.Tax as abap.dec(6,2))
      else a.Tax
      end as Tax,
      a.GlAcc,
      a.zcurr,
      @Semantics.amount.currencyCode : 'zcurr'
      //      sum(b.UpToDate)     as UpToDate,
      //      b.UpToDate     as UpToDate, //commented 17.10.2023
      case a.Umskz   //added 17.10.2023
      when 'D'
      then cast(max(b.UpToDate) as abap.dec( 15, 2 ))
      when 'B'
      then cast(max(b.UpToDate) as abap.dec( 15, 2 ))
      else
      cast(max(b.UpToDate) as abap.dec( 15, 2 ))
      end as UpToDate,
      @Semantics.amount.currencyCode : 'zcurr'
      case a.Umskz
      when 'B'
      //      then cast(0.00 as abap.curr(15,2))
       then cast(0.00 as abap.dec(15,2)) //added 17.10.2023
      //      then b.UpToDate //commented 17.10.2023
      when 'D' //added 17.10.2023
      then cast(max(b.UpToDate) as abap.dec( 15, 2 ))
      else
      //      sum(b.UpToDate) end as UpToPreviousBill,
      //      b.UpToDate end as UpToPreviousBill,
      cast(max(b.UpToDate) as abap.dec( 15, 2 ))
      end as UpToPreviousBill,
      case a.Umskz
      when 'B'
      then cast(max(f.ThisBill) as abap.dec( 15, 2))
      //      then cast(f.ThisBill as abap.dec( 15, 2))
       when 'D'
      then cast(cast(max(e.ThisBill) as abap.dec( 15, 2 )) * (cast(max(e.Tax) as abap.dec(6,2)) / 100 )
      //      then cast(cast(e.ThisBill as abap.dec( 15, 2 )) * (cast(e.Tax as abap.dec(6,2)) / 100 )
      as abap.dec(15,2))
      else cast(0.00 as abap.dec( 15, 2 ))
      end as ThisBill,
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
  a.Tax,
  a.GlAcc,
  a.zcurr,
//  b.UpToDate,
  //  f.ThisBill,
  a.Remarks,
  //  e.ThisBill,
  e.Tax
