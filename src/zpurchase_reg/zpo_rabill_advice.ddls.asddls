@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rabill no advance'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPO_RABILL_ADVICE as select from ZMM_RABILL_PAY_ABSTRACT_HEAD1
{
    key Ebeln,
    key Rabillno
//    ServiceEntrySheet
}
where ServiceEntrySheet is  null
group by Ebeln,
   Rabillno
//    ServiceEntrySheet
