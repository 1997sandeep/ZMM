@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Milestone Item'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_PAY_MLSTN_I 
  as select distinct from I_PurchaseOrderAPI01           as a1
    left outer join   I_PurchaseOrderItemAPI01       as a2 on a1.PurchaseOrder = a2.PurchaseOrder
    left outer join   I_PurOrdItmPricingElementAPI01 as a3 on a2.PurchaseOrder = a3.PurchaseOrder
                                                      and a2.PurchaseOrderItem = a3.PurchaseOrderItem
                                                      and a2.TaxCode           = a3.TaxCode
     left outer join I_TaxCodeText        as f on  a2.TaxCode   = f.TaxCode 
                                               and f.Language   = 'E'   
     left outer join zmmt_scp_tnc_i       as b on  a1.PurchaseOrder     = b.purchaseorder
                                               and a2.PurchaseOrderItem = b.purchaseorderitem   
     left outer join zmm_pay_mlstn        as c on a1.PurchaseOrder = c.ebeln
                                               and a2.PurchaseOrderItem = c.ebelp

{

  key  a1.PurchaseOrder,
  key  a2.PurchaseOrderItem,
  key   c.split_item_no,
       a1.PurchaseOrderType,
       a2.PurchaseOrderItemText,
       a2.DocumentCurrency,
       @Semantics.amount.currencyCode: 'DocumentCurrency'
       a2.NetAmount,
       @Semantics.amount.currencyCode: 'DocumentCurrency'
       a2.NetPriceAmount as rate,
       @Semantics.quantity.unitOfMeasure : 'uom'
       a2.OrderQuantity as qty,
       a2.TaxCode,
       a2.Plant,
       a3.ConditionType,
       @Semantics.amount.currencyCode: 'DocumentCurrency'
       a3.ConditionAmount,
       f.TaxCodeName,
       b.baserate,
       b.paymilestone,
       c.uom,
       @Semantics.quantity.unitOfMeasure : 'uom'
////       c.qty,
////       c.rate,
       c.amount,
       c.split_item,
       c.percentage
}
where //a1.PurchaseOrder = $parameters.p_wo and a2.PurchaseOrderItem = $parameters.p_item and
    (  a3.ConditionType     = 'ZJEX' or a3.ConditionType     = 'ZTAX' )
  and
    a1.PurchaseOrderType =  'ZP05'
  and b.paymilestone is not initial
  
group by
  a1.PurchaseOrder,
  a2.PurchaseOrderItem,
  a1.PurchaseOrderType,
  a2.PurchaseOrderItemText,
  a2.DocumentCurrency,
  a2.NetAmount,
  a2.TaxCode,
  a2.Plant,
  a3.ConditionType,
  a3.ConditionAmount,
    f.TaxCodeName,
    b.baserate,
    b.paymilestone,
    c.split_item_no,
    c.split_item,
    c.percentage,
    c.qty,
    c.rate,
    c.amount,
    c.uom,
    a2.NetPriceAmount,
    a2.OrderQuantity
