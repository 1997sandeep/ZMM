@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Approver Details'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMB_APPROVER_DETAILS as select from zmm_main_ra_t
{
    key werks as Werks,
    key app_level as AppLevel,
    userid as Username
   
}
