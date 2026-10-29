@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rabill no'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPO_RABILL_N as select from ZMM_RABILL_PAY_ABSTRACT_HEAD1
{
    key Ebeln,
    key Rabillno,
    ServiceEntrySheet
}
where ServiceEntrySheet is not initial
group by Ebeln,
   Rabillno,
    ServiceEntrySheet
