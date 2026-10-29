@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Rec For NotMaintained in Rabill'
define root view entity ZMM_RABILL_PAY_WORKDONE_MTRE1 
 as select from zmmt_scp_rabill1 as a1
{
  key  a1.ra_bill_no                      as Rabillno,
  key  a1.ebeln                           as Ebeln,
  key  cast('' as abap.numc( 3 ) )        as SrNo,
       cast('' as abap.char( 2 ) )        as SrNumber,
       'MTRE'                             as ItemCode,
       cast('' as abap.char( 50 ) )       as PaMasterDescription,
       cast('' as abap.char( 10 ) )       as GLAcc,
       @Semantics.amount.currencyCode : 'zcurr'
       cast(0 as abap.curr( 6, 2 )) as Tax,
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
  a1.ebeln,
  a1.zcurr
