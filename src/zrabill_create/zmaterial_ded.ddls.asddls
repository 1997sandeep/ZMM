@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Materal Deduction'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMATERIAL_DED
//with parameters
//    p_from_date : abap.dats,
//    p_to_date   : abap.dats

 as select from I_MaterialDocumentItem_2
{

 key Plant,
 key Supplier,
 PostingDate,
 sum( YY1_MaterialValue_MMI ) as mat_amount
    
} where GoodsMovementType = '541' and DebitCreditCode = 'H' 
group by Plant,
Supplier,
    PostingDate
