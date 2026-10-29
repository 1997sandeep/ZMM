@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Joining with Wo and RabillNo'
define root view entity ZMM_RABILL_RABILLNO_WO1
  as select from ZMM_RABILL_RABILLNO_WO as a
  //    inner join   zmmt_scp_rabill1       as b on a.Ebeln = b.ebeln // commented by WK:12.09.2023

{
      //  key b.ra_bill_no as RabillNo, //commented by WK:12.09.2023
      //  key b.ebeln      as Ebeln,

  key a.RaBillNo as RabillNo, //added by WK:12.09.2023
  key a.Ebeln    as Ebeln,
  key a.ItemCode as ItemCode,
      a.zcurr,
      a.UpToDate,
      a.UpToPreviousBill,
      a.ThisBill
}
group by
//  b.ra_bill_no,
//  b.ebeln,
  a.RaBillNo,
  a.Ebeln,
  a.zcurr,
  a.UpToDate,
  a.UpToPreviousBill,
  a.ThisBill,
  a.ItemCode
