@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ra Bill F4 view'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_RABILL_REC_F4 
  as select from zmmt_scp_rab_ad1 as a1
  inner join zmmt_scp_rabill1 as a2 on a1.ebeln = a2.ebeln
  left outer join ZMM_ADV_REC_MAX as a3 on a2.ebeln = a3.ebeln 
  left outer join ZMM_ADV_REC_Single as a4 on a2.ra_bill_no = a4.RaBillNo 
{
  key a2.ra_bill_no,
      a2.rcount,
      a2.ebeln,
      a2.ra_bill_from,
      a2.ra_bill_to,
      a3.AdvRec,
      a4.RaBillNo as RA2
}
where a4.RaBillNo is null  
group by
  a2.ra_bill_no,
  a2.rcount,
  a2.ebeln,
  a2.ra_bill_from,
  a2.ra_bill_to,
  a3.AdvRec,
  a4.RaBillNo
