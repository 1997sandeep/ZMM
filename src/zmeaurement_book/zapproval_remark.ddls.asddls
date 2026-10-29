@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Approval Remark'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZAPPROVAL_REMARK as select from zmb_approval_t
{
   key mbno,
   app_level,
   remark 
} // where appr_status = 'INPROCESS'
