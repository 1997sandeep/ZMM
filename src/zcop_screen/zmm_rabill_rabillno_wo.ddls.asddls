@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Max Rabill No againt WO'
define root view entity ZMM_RABILL_RABILLNO_WO
  //  as select from zmmt_scp_rabill1 as a
  //    inner join   zmmt_scp_rab_ad1 as b on a.ebeln = b.ebeln     //commented by WK:12.09.2023
  as select from zmmt_scp_rab_ad1 as b
{
  key b.ra_bill_no                               as RaBillNo, //added by WK:12.09.2023
  key b.ebeln                                    as Ebeln,
  key case b.adv_type
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
       end                                       as ItemCode,
      b.zcurr,
      @Semantics.amount.currencyCode : 'zcurr'
      cast(max(b.tot_adv) as abap.curr( 15,2 )) as UpToDate,
      @Semantics.amount.currencyCode : 'zcurr'
      cast(max(b.tot_adv) as abap.curr( 15,2 )) as UpToPreviousBill,
      @Semantics.amount.currencyCode : 'zcurr'
      cast(max(b.tot_adv) as abap.curr( 15,2 )) as ThisBill
}
group by
  b.ebeln,
  b.zcurr,
  b.adv_type,
  b.ra_bill_no
