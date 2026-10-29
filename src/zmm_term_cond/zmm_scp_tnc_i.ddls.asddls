@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'WO T&C Item cds'
define root view entity ZMM_SCP_TNC_I
  as select from I_PurchaseOrderAPI01           as a1
    left outer join   I_PurchaseOrderItemAPI01       as a2 on a1.PurchaseOrder = a2.PurchaseOrder
    left outer join   I_PurOrdItmPricingElementAPI01 as a3 on  a2.PurchaseOrder     = a3.PurchaseOrder
                                                      and a2.PurchaseOrderItem = a3.PurchaseOrderItem
                                                      and a2.TaxCode           = a3.TaxCode
//     left outer join I_PurchaseOrderItemAPI01       as a4 on a1.PurchaseOrder = a4.PurchaseOrder
     left outer join I_TaxCodeText        as f on  a2.TaxCode   = f.TaxCode 
                                               and f.Language   = 'E'   
     left outer join zmmt_scp_tnc1        as b on a1.PurchaseOrder = b.ebeln
{

  key  a1.PurchaseOrder,
  key  a2.PurchaseOrderItem,
      
       a1.PurchaseOrderType,
       a2.PurchaseOrderItemText,
       a2.DocumentCurrency,
       @Semantics.amount.currencyCode: 'DocumentCurrency'
       a2.NetAmount,
       a2.TaxCode,
       a2.Plant,
       a3.ConditionType,
       @Semantics.amount.currencyCode: 'DocumentCurrency'
       a3.ConditionAmount,
       f.TaxCodeName,
       b.base_chk,
       b.pay_chk
}
where //a1.PurchaseOrder = $parameters.p_wo and a2.PurchaseOrderItem = $parameters.p_item and
    (  a3.ConditionType     = 'ZJEX' or a3.ConditionType     = 'ZTAX' )
  and
    a1.PurchaseOrderType =  'ZP05'

  
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
    b.base_chk,
    b.pay_chk
