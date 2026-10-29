@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'C.DEDUCTIONS :Rabill Pay Abstract'
define root view entity ZMM_RABILL_PAY_RECOVERY
  as select from zmmt_scp_rab_rec as a
{
       @EndUserText.label: 'RaBillNo'
  key  a.ra_bill_no                 as RaBillNo,
       @EndUserText.label: 'Work OrderNo'
  key  a.ebeln                      as Ebeln,
  key  cast('' as abap.numc( 3 ) )  as SrNo,
       cast('' as abap.char( 2 ) )  as SrNumber,
       case a.adv_type
        when 'MOBI'
       then 'REMB'
       when 'MATR'
       then 'REMT'
       when 'MACH'
       then 'EWMC'
       when 'AGWD'
       then 'REWD'
       when 'ROYL'
       then 'RRYL'
       else ''
       end                          as ItemCode,
       cast('' as abap.char( 50 ) ) as PaMasterDescription,
       cast('' as abap.char( 10 ) ) as GLAcc,
       a.zcurr,
       @Semantics.amount.currencyCode : 'zcurr'
       sum(rec_up_date)             as UpToDate,
       @Semantics.amount.currencyCode : 'zcurr'
       sum(rec_till)                as UpToPreviousBill,
       @Semantics.amount.currencyCode : 'zcurr'
       sum(rec_this_bill)           as ThisBill,
       ''                           as Remarks

}
group by
  a.ra_bill_no,
  a.ebeln,
  a.adv_type,
  a.zcurr
