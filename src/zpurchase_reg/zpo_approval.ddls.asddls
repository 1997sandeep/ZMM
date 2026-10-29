@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO approvals'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPO_APPROVAL
  as select from I_WorkflowStatusOverview as a
    inner join   I_WorkflowStatusDetails  as b on b.WorkflowInternalID = a.WorkflowInternalID
{
  key cast( a.SAPBusinessObjectNodeKey1 as abap.char( 10 ) )  as SAPBusinessObjectNodeKey1 ,
      b.WorkflowTaskProcessor,
//      b.WrkflwTskCompletionUTCDateTime,
      tstmp_to_dats( b.WrkflwTskCompletionUTCDateTime, $session.user_timezone, $session.client, 'NULL' ) as date1,
      tstmp_to_tims( b.WrkflwTskCompletionUTCDateTime, $session.user_timezone, $session.client, 'NULL' ) as time1
} where b.WorkflowTaskExternalStatus = 'COMPLETED'
group by
  a.SAPBusinessObjectNodeKey1,
  b.WrkflwTskCompletionUTCDateTime,
  b.WorkflowTaskProcessor
