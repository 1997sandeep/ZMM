@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Recovery number max'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_ADV_REC_MAX
  as select from zmmt_scp_rab_rec

{

  key ebeln,
      max(adv_rec) as AdvRec

}
group by
  ebeln

