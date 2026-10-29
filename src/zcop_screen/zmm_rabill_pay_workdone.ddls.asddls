@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'A. Work Done Cds View For PayAbstract'
define root view entity ZMM_RABILL_PAY_WORKDONE
  as select from zmmt_scp_rabill1 as a

{
       @EndUserText.label: 'RaBillNo'
  key  a.ra_bill_no                 as RaBillNo,
       @EndUserText.label: 'Work OrderNo'
  key  a.ebeln                      as Ebeln,
  key  cast('' as abap.numc( 3 ) )  as SrNo,
       cast('' as abap.char( 2 ) )  as SrNumber,
       'GTBQ'  as ItemCode,
//       cast('' as abap.char( 4 ) )  as ItemCode,
       cast('' as abap.char( 50 ) ) as PaMasterDescription,
       cast('' as abap.char( 10 ) ) as GLAcc,
       @Semantics.amount.currencyCode : 'zcurr'
       cast(0.00 as abap.curr( 13, 2 )) as Tax,
       a.zcurr,
       @Semantics.amount.currencyCode : 'zcurr'
       sum(a.upto_date_amt)         as UpToDate,
       @Semantics.amount.currencyCode : 'zcurr'
       sum(a.upto_prev_amt)         as UpToPreviousBill,
       @Semantics.amount.currencyCode : 'zcurr'
       sum(a.this_bill_amt)         as ThisBill,
       ''                           as Remarks

}
group by
  a.ra_bill_no,
  a.zcurr,
  a.ebeln
