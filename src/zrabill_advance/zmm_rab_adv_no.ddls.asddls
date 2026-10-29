@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Latest Rabill number'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_RAB_ADV_NO 
 as select from zmmt_scp_rab_ad1
{
  key   ebeln       as Ebeln,
        max(rcount) as Rcount
    //    ra_bill_no  as RaBillNo
}
group by
  ebeln
