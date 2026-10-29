@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MIGO Print CDS'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMIGO_PRINT 
    as select distinct from I_GoodsMovementCube as a
    
    
    
    left outer join I_MaterialDocumentHeader_2 as matdoc
        on matdoc.MaterialDocument = a.MaterialDocument
        and matdoc.MaterialDocumentYear = a.MaterialDocumentYear
        
    left outer join I_MaterialDocumentItem_2 as matitm
        on matitm.MaterialDocument = a.MaterialDocument
        and matitm.MaterialDocumentItem = a.MaterialDocumentItem
        and matitm.MaterialDocumentYear = a.MaterialDocumentYear
        
    left outer join I_PurchaseOrderAPI01 as po
        on po.PurchaseOrder = a.PurchaseOrder
        
    left outer join I_PurchaseOrderItemAPI01 as b
        on b.PurchaseOrder = a.PurchaseOrder
        and b.PurchaseOrderItem = a.PurchaseOrderItem
        
    left outer join I_ProductDescription        as c on c.Product       = matitm.Material
                                                 and c.Language         = $session.system_language
    left outer join I_Plant                     as d on d.Plant         = po.SupplyingPlant
    left outer join I_Plant                     as e on e.Plant         = a.Plant
    left outer join I_Plant                     as supp_303_plant on supp_303_plant.Plant         = matitm.Plant
    left outer join I_IN_BusinessPlaceTaxDetail as f on f.BusinessPlace = d.BusinessPlace
    left outer join I_IN_BusinessPlaceTaxDetail as g on g.BusinessPlace = e.BusinessPlace
    left outer join I_IN_BusinessPlaceTaxDetail as supp_303_bp on supp_303_bp.BusinessPlace = supp_303_plant.BusinessPlace
    left outer join ZADDRESS1            as h on h.AddressID         = d.Plant
//    left outer join ZR_MM_PLANT_ADDR            as i on i.Plant         = e.Plant
//    left outer join ZR_MM_PLANT_ADDR            as supp_303_add on supp_303_add.Plant         = supp_303_plant.Plant
    left outer join I_User as k on k.UserID = matdoc.CreatedByUser    
        
{
    // Material Document (GRN)
    key a.MaterialDocument,
    a.MaterialDocumentYear,
    a.MaterialDocumentItem,
    a.Supplier,
    
    matdoc.DeliveryDocument as DeliveryNote,
    matdoc.BillOfLading as BillOfLading,
    
    a.Plant as to_plant,
    e.PlantName,
    g.IN_GSTIdentificationNumber as PlantGSTIN,  
    a.GoodsMovementType,
//    a.HeaderText as DeliveryNote,
//    a.BillOfLading,    
    a.MaterialDocument as SAPDocumentNumber,
    a.PostingDate as SAPDocumentDate,
    b.PurchaseRequisition as PRNumber,
    a.PurchaseOrder,
    a.Material,
    c.ProductDescription as MaterialDescription,
    matitm.DebitCreditCode,
    matitm.MaterialBaseUnit,
    k.UserDescription as SiteStoreUser,
    matitm.EntryUnit,
    @Semantics.quantity.unitOfMeasure: 'EntryUnit'
    matitm.QuantityInEntryUnit as Quantity,
    matitm.CompanyCodeCurrency,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    matitm.TotalGoodsMvtAmtInCCCrcy as value,
    
    c.ProductDescription,
    po.SupplyingPlant,
    matitm.Plant as supp_303,
        d.PlantName        as supp_plantnm,
        e.PlantName        as to_plantnm,
        supp_303_plant.PlantName        as supp_303_plantnm,

        f.IN_GSTIdentificationNumber as suppltgst,
        g.IN_GSTIdentificationNumber as to_plt_gstin,
        supp_303_bp.IN_GSTIdentificationNumber as supp_303_supplt,

//        supp_303_add.Address01     as supp_303_Address01, 
//        supp_303_add.Address02   as supp_303_Address02, 
//        supp_303_add.Address03   as supp_303_Address03, 
//        supp_303_add.Address04   as supp_303_Address04, 
//        supp_303_add.Address05   as supp_303_Address05, 
//        supp_303_add.Address06   as supp_303_Address06, 
//        supp_303_add.Region   as supp_303_Region,    
//        supp_303_add.Pincode   as supp_303_Pincode,   
//        supp_303_add.StorePhone   as supp_303_StorePhone,
//        supp_303_add.StoreMail   as supp_303_StoreMail, 
//        
//        h.Address01,
//        h.Address02,
//        h.Address03,
//        h.Address04,
//        h.Address05,
//        h.Address06,
//        h.Region,
//        h.Pincode,
//        h.StorePhone,
//        h.StoreMail,
//
//        i.Address01        as to_Address01,
//        i.Address02        as to_Address02,
//        i.Address03        as to_Address03,
//        i.Address04        as to_Address04,
//        i.Address05        as to_Address05,
//        i.Address06        as to_Address06,
//        i.Region           as to_Region,
//        i.Pincode          as to_Pincode,
//        i.StorePhone          as to_StorePhone,
//        i.StoreMail          as to_StoreMail ,
        matitm.IssuingOrReceivingPlant
    
}
where

 matitm.IsAutomaticallyCreated <> 'X' and
    ( a.GoodsMovementType = '101' or
    a.GoodsMovementType = '501' or
    a.GoodsMovementType = '511' or  
    a.GoodsMovementType = 'Z61' or
    a.GoodsMovementType = '561' or
    a.GoodsMovementType = '305' or
    a.GoodsMovementType = '221' or
    a.GoodsMovementType = '261' or
    a.GoodsMovementType = '281' or
    a.GoodsMovementType = '601' or
    a.GoodsMovementType = '641' or
    a.GoodsMovementType = 'Z21' or
    a.GoodsMovementType = '303' )


