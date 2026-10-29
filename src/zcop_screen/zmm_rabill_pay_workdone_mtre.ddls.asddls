@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Recovery for Item'
define root view entity ZMM_RABILL_PAY_WORKDONE_MTRE
  as select from zmmt_scp_mat_ca1 as a
{
  key  a.ra_bill_no                           as RaBillNo,
  key  a.ebeln                                as Ebeln,
  key  cast('' as abap.numc( 3 ) )            as SrNo,
       cast('' as abap.char( 2 ) )            as SrNumber,
       'MTRE'                                 as ItemCode,
       cast('' as abap.char( 50 ) )           as PaMasterDescription,
       cast('' as abap.char( 10 ) )           as GLAcc,
       @Semantics.amount.currencyCode : 'zcurr'
       cast(0.00 as abap.curr( 6, 2 ))        as Tax,
       a.zcurr,
       @Semantics.amount.currencyCode : 'zcurr'
       sum(cast(a.tot_rec_value as abap.curr( 15, 2 )))         as UpToDate,
       @Semantics.amount.currencyCode : 'zcurr'
       sum(cast(a.tot_rec_value as abap.curr( 15, 2 ))) as UpToPreviousBill,
       @Semantics.amount.currencyCode : 'zcurr'
      sum(cast(a.tot_rec_value as abap.curr( 15, 2 )))  as ThisBill,
       ''                                     as Remarks
}
group by
    a.ra_bill_no,
    a.ebeln,
    a.zcurr


