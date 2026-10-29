@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'B.ADD:Advances Payment Abstarct'
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define root view entity ZMM_RABILL_PAY_ADVANCE
  as select from zmmt_scp_rab_ad1 as a
{
       @EndUserText.label: 'RaBillNo'
  key  a.ra_bill_no                             as RaBillNo,
       @EndUserText.label: 'Work OrderNo'
  key  a.ebeln                                  as Ebeln,
  key  cast('' as abap.numc( 3 ) )              as SrNo,
       cast('' as abap.char( 2 ) )              as SrNumber,
       case a.adv_type
       when 'MOBI'
       then 'ADMO'
       when 'MATR'
       then 'ADMT'
       when 'MACH'
       then 'ADMC'
       when 'AGWD'
       then 'ADWD'
       when 'ROYL'
       then 'ROYL'
       else ''
       end                                      as ItemCode,
       cast('' as abap.char( 50 ) )             as PaMasterDescription,
       cast('' as abap.char( 10 ) )             as GLAcc,
       a.zcurr,
       @Semantics.amount.currencyCode : 'zcurr'
       cast(sum(tot_adv) as abap.curr( 15,2 )) as UpToDate,
       @Semantics.amount.currencyCode : 'zcurr'
       cast(sum(tot_adv) as abap.curr( 15,2 )) as UpToPreviousBill,
       @Semantics.amount.currencyCode : 'zcurr'
       cast(sum(tot_adv) as abap.curr( 15,2 )) as ThisBill,
       ''                                       as Remarks
}
group by
  a.ra_bill_no,
  a.ebeln,
  a.adv_type,
  a.zcurr
