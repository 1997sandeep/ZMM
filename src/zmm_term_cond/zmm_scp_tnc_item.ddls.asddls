@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'work order tnc item cds'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_SCP_TNC_ITEM
  as select from    I_PurchaseOrderAPI01           as a1
    left outer join I_PurchaseOrderItemAPI01       as a2 on a1.PurchaseOrder = a2.PurchaseOrder
    left outer join I_PurOrdItmPricingElementAPI01 as a3 on  a3.PurchaseOrder     = a2.PurchaseOrder
                                                         and a3.PurchaseOrderItem = a2.PurchaseOrderItem
                                                         and a3.TaxCode           = a2.TaxCode
                                                         and ( a3.ConditionType = 'ZJEX' or a3.ConditionType = 'ZTAX' )
    left outer join I_TaxCodeText                  as f  on  a2.TaxCode = f.TaxCode
                                                         and f.Language = 'E'
    left outer join zmmt_scp_tnc_i                 as e  on  a2.PurchaseOrder     = e.purchaseorder
                                                         and a2.PurchaseOrderItem = e.purchaseorderitem


{
  key a1.PurchaseOrder         as Purchaseorder,
  key a2.PurchaseOrderItem     as Purchaseorderitem,
      case a2.IsStatisticalItem when 'X'
      then ' '
      else ltrim(cast(a2.PurchasingParentItem as abap.char(5)),'0') end as Hierarchy_item,
//      a2.PurchasingParentItem  as Hierarchy_item,
      a2.PurchaseOrderItemText as Description,
      a2.DocumentCurrency      as Curr,
      @Semantics.amount.currencyCode: 'Curr'
      a2.NetAmount             as WoValue,
      a2.TaxCode               as Taxcode,
      f.TaxCodeName            as Taxcodedescp,
      @Semantics.amount.currencyCode: 'Curr'
      a3.ConditionAmount       as Taxvalue,
      e.baserate               as Baserate,
      e.paymilestone           as Paymilestone,
//      case a2.PurchasingParentItem when '00000'
//      then 'X'
//      else ' ' end as Hierarchy_flag
      a2.IsStatisticalItem     as Hierarchy_flag
}
where //a1.PurchaseOrder = $parameters.p_wo and a2.PurchaseOrderItem = $parameters.p_item and
//  (
//       a3.ConditionType     = 'ZJEX'
//    or a3.ConditionType     = 'ZTAX'
//  )
//  and
    a1.PurchaseOrderType = 'ZP05'

group by
  a1.PurchaseOrder,
  a2.PurchaseOrderItem,
  a2.PurchasingParentItem,
  a1.PurchaseOrderType,
  a2.PurchaseOrderItemText,
  a2.DocumentCurrency,
  a2.NetAmount,
  a2.TaxCode,
  a2.Plant,
  a3.ConditionType,
  a3.ConditionAmount,
  f.TaxCodeName,
  e.baserate,
  e.paymilestone,
  a2.IsStatisticalItem
