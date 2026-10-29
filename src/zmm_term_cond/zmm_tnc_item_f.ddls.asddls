@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'WO T&C Item set detials'
define root view entity ZMM_TNC_ITEM_F    with parameters
    p_wo : ebeln,
    p_item : ebelp
as select from ZMM_SCP_TNC_I

{
  key PurchaseOrder,
  key PurchaseOrderItem,
  PurchaseOrderType,
  PurchaseOrderItemText,
  DocumentCurrency,
  NetAmount,
  TaxCode,
  Plant,
  ConditionType,
  ConditionAmount   
} where PurchaseOrder = $parameters.p_wo and PurchaseOrderItem = $parameters.p_item
