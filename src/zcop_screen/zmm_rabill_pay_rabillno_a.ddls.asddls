@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Only RabillNo and Ebeln for Part A/C/D'
define root view entity ZMM_RABILL_PAY_RABILLNO_A
  //  as select from zmmt_scp_ra_payi as a
  as select from zmmt_scp_rabill1 as a
{
  key a.ra_bill_no                as RaBillNo,
  key a.ebeln                     as Ebeln,
      cast('' as abap.char( 14 )) as Blank //added on 25.09.2023
}
where
 //     a.ra_bill_no like '0%'
   a.ra_bill_no <>   ''
group by
  a.ra_bill_no,
  a.ebeln
