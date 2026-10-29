@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCOP_GST as select from I_PurchaseOrderItemAPI01 as a
left outer join I_TaxCodeRate as b on b.TaxCode = a.TaxCode
left outer join I_TaxCodeText as c on c.TaxCode = a.TaxCode
{
    key a.PurchaseOrder,
//    key a.PurchaseOrderItem,
    a.TaxCode,
    b.VATConditionType,
    cast( b.ConditionRateRatio as abap.dec( 10, 2 ) ) as ConditionRateRatio,
    c.TaxCodeName,
    case b.VATConditionType
    when 'JICG' then 'CGST @ %'
    when 'JISG' then 'SGST @ %'
    when 'JIIG' then 'IGST @ %'
    else '' end as gstname
} where b.VATConditionType is not initial
group by
a.PurchaseOrder,
// a.PurchaseOrderItem,
    a.TaxCode,
    b.ConditionRateRatio,
    c.TaxCodeName,
    b.VATConditionType
