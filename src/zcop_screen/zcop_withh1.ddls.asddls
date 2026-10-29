@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Withholding Tax %'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCOP_WITHH1 as select from I_PurchaseOrderAPI01 as A
left outer join ZCOP_WITHH as B on B.WithholdingTaxCode = A.YY1_WTaxType_PDH
{
    key A.PurchaseOrder,
        A.YY1_Retention_PDH,
      B.WithholdingTaxType,
      cast( B.WithholdingTaxPercent as abap.dec( 5, 2 )) as WithholdingTaxPercent,     
      case 
      when A.YY1_Retention_PDH is not initial then 'Retention Money (HOLD)'
      else '' end as RetentionMoneyHOLD
//      case 
//      when B.WithholdingTaxType is not initial then 'Income Tax (TDS) for Work Done'
//      else '' end as RetentionMoneyHOLD
}
group by
A.PurchaseOrder,
      B.WithholdingTaxType,
      B.WithholdingTaxPercent,
    A.YY1_Retention_PDH
    
union all
 select from I_PurchaseOrderAPI01 as A
left outer join ZCOP_WITHH as B on B.WithholdingTaxCode = A.YY1_WTaxType_PDH
{
    key A.PurchaseOrder,
        A.YY1_Retention_PDH,
      B.WithholdingTaxType,
      cast( B.WithholdingTaxPercent as abap.dec( 5, 2 )) as WithholdingTaxPercent,     
      case 
      when A.YY1_Retention_PDH is not initial then 'Income Tax (TDS) for Work Done'
      else '' end as RetentionMoneyHOLD
}
group by
A.PurchaseOrder,
      B.WithholdingTaxType,
      B.WithholdingTaxPercent,
    A.YY1_Retention_PDH   
