@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Withholding Tax %'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCOP_WITHH as select from I_WithholdingTaxCodeVH
{
   
       key Country,
       key WithholdingTaxType,
       key WithholdingTaxCode,
       WithholdingTaxPercent
    
}
