@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Calculation for Advance TDS'
define root view entity ZMM_RABILL_PAY_MAS1_CV
  as select from    ZMM_RABILL_PAY_ADVANCE_UNION as a
//    left outer join ZMM_RABILL_PAY_DEDUCTION_CV  as b on a.Ebeln = b.Ebeln  //""""sandeep 08.05.25
    left outer join zmmt_scp_tnc1  as b on a.Ebeln = b.ebeln  //""""sandeep 08.05.25
//    left outer join ZRABILL_ADVICE_TAX2  as b on a.Ebeln = b.Ebeln and a.RaBillNo = b.advrabill

{
 key a.RaBillNo as RaBillNo,
  key a.Ebeln,
      @Semantics.amount.currencyCode: 'zcurr'
//      max(a.ThisBill) as ThisBill,    
     sum(a.ThisBill) as ThisBill,   ////sandeep 
      cast( b.ztds as abap.dec( 10, 2 ))           as Tax,
      a.zcurr,
      'SDIT'          as ItemCode
}
group by
  a.RaBillNo,
  a.Ebeln,
  b.ztds,
  a.zcurr


