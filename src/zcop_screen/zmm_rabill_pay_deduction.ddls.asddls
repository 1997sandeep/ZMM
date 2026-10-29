@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'D.STATUORY DEDUCTIONS :Rabill Pay'
define root view entity ZMM_RABILL_PAY_DEDUCTION
  //  as select from zmmt_scp_rabill1 as a1
  //    inner join   zmmt_scp_tnc1    as a2 on a1.ebeln = a2.ebeln
  as select from    zmmt_scp_tnc1    as a2
    left outer join zmmt_scp_rabill1 as a1 on a2.ebeln = a1.ebeln


{
  key  a1.ra_bill_no                      as Rabillno,
       //  key  a1.ebeln                           as Ebeln,
  key  a2.ebeln                           as Ebeln,
  key  cast('' as abap.numc( 3 ) )        as SrNo,
       cast('' as abap.char( 2 ) )        as SrNumber,
       //       cast('' as abap.char( 4 ) )  as ItemCode,
       'SDIT'                             as ItemCode,
       cast('' as abap.char( 50 ) )       as PaMasterDescription,
       cast('' as abap.char( 10 ) )       as GLAcc,
       @Semantics.amount.currencyCode : 'zcurr'
       cast(a2.ztds as abap.curr( 6, 2 )) as Tax,
       a1.zcurr,
       @Semantics.amount.currencyCode : 'zcurr'
       cast( 0 as abap.curr( 15, 2 ))     as UpToDate,
       @Semantics.amount.currencyCode : 'zcurr'
       cast( 0 as abap.curr( 15, 2 ))     as UpToPreviousBill,
       @Semantics.amount.currencyCode : 'zcurr'
       cast( 0 as abap.curr( 15, 2 ))     as ThisBill,
       ''                                 as Remarks
}
group by
  a1.ra_bill_no,
  //  a1.ebeln,
  a2.ebeln,
  a1.zcurr,
  a2.ztds
