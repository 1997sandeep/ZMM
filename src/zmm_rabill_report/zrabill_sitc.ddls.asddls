@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rabill for Supp. Install Test and Comm.'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZRABILL_SITC
  as select distinct from ZMM_RABILL_PAYABST_DISPLAY as c 
    left outer join       ZMM_RABILL_EDIT            as a  on c.Ebeln = a.Ebeln 
    left outer join       I_PurchaseOrderItemAPI01   as F  on  a.Ebeln = F.PurchaseOrder
                                                           and a.Ebelp = F.PurchaseOrderItem
    left outer join       ZRABILL_SITC1              as G  on a.RaBillNo = G.RaBillNo
    left outer join       zmmt_rab_mbsheet           as h  on  a.Ebeln    = h.ebeln
                                                           and a.Ebelp    = h.ebelp
                                                           and a.RaBillNo = h.ra_bill_no
    left outer join       ZRABILL_SITC_PREWORK_QTY2  as i  on  a.Ebeln    = i.ebeln
                                                           and a.Ebelp    = i.ebelp
                                                           and a.RaBillNo = i.ra_bill_no
    left outer join       I_PurchaseOrderItemAPI01   as cc on  cc.PurchaseOrder     = c.Ebeln
                                                           and cc.PurchaseOrderItem = a.Ebelp


{
       @UI.lineItem: [{ position: 60 }]
       @UI.identification: [{ position: 60 }]
       @UI.selectionField: [{ position: 10 }]
       @EndUserText.label: 'RA Bill Number'
  key  a.RaBillNo,

       @UI.lineItem: [{ position: 50 }]
       @UI.identification: [{ position: 50 }]
       @UI.selectionField: [{ position: 10 }]
       @EndUserText.label: 'WO Number'
  key  a.Ebeln                                   as WoNumber,

       @UI.lineItem: [{ position: 20 }]
       @UI.identification: [{ position: 20 }]
       @EndUserText.label: 'Project Name'
  key  c.PlantName,
       //
       //    @UI.lineItem: [{ position: 70 }]
       //    @UI.identification: [{ position: 70 }]
       //    @EndUserText.label: 'Latest RA Bill'
       //    key G.maxbill,
       //
       @UI.lineItem: [{ position: 10 }]
       @UI.identification: [{ position: 10 }]
       @UI.selectionField: [{ position: 10 }]
       @EndUserText.label: 'Plant'
  key  c.Plant,
       //
       @UI.lineItem: [{ position: 30 }]
       @UI.identification: [{ position: 30 }]
       @UI.selectionField: [{ position: 10 }]
       @EndUserText.label: 'Vendor'
  key  c.Supplier                                as Vendor,
       //
       @UI.lineItem: [{ position: 40 }]
       @UI.identification: [{ position: 40 }]
       @EndUserText.label: 'Vendor Name'
  key  c.SupplierName                            as vendorname,
       //
       @UI.lineItem: [{ position: 80 }]
       @UI.identification: [{ position: 80 }]
       @EndUserText.label: 'Vendor PAN'
  key  c.PAN                                     as VendorPan,
       //
       @UI.lineItem: [{ position: 90 }]
       @UI.identification: [{ position: 90 }]
       @EndUserText.label: 'Vendor GSTIN'
  key  c.Gstin                                   as VendorGstin,

       //    @UI.lineItem: [{ position: 110 }]
       //    @UI.identification: [{ position: 110 }]
       //    @EndUserText.label: 'SITC Split Item(Split Item No.)'
       //    key  c.split_item,
       //
       //    @UI.lineItem: [{ position: 120 }]
       //    @UI.identification: [{ position: 120 }]
       //    @EndUserText.label: 'Split Item No.(SITC Split Item)'
       //    key  c.split_item_no,

       //    @UI.lineItem: [{ position: 130 }]
       //    @UI.identification: [{ position: 130 }]
       //    @EndUserText.label: '% SITC Split Item'
       //    key  c.percentage,

       @UI.lineItem: [{ position: 140 }]
       @UI.identification: [{ position: 140 }]
       @EndUserText.label: 'Service Number'
  key  F.Material,

       @UI.lineItem: [{ position: 150 }]
       @UI.identification: [{ position: 150 }]
       @EndUserText.label: 'Service Text'
  key  F.PurchaseOrderItemText,

       @UI.lineItem: [{ position: 160 }]
       @UI.identification: [{ position: 160 }]
       @EndUserText.label: 'UOM'
  key  a.Uom,

       @UI.lineItem: [{ position: 170 }]
       @UI.identification: [{ position: 170 }]
       @EndUserText.label: 'WO Qty'
  key  cast(c.woamt as abap.dec( 12, 2 ))        as qty,
       //
       @UI.lineItem: [{ position: 180 }]
       @UI.identification: [{ position: 180 }]
       @EndUserText.label: 'WO Rate'
  key  cast(cc.NetPriceAmount as abap.dec( 12, 2 ))        as rate,

       @UI.lineItem: [{ position: 190 }]
       @UI.identification: [{ position: 190 }]
       @EndUserText.label: 'WO Amount'
  key  cast(cc.NetAmount as abap.dec( 12, 2 ))   as amount,

       @UI.lineItem: [{ position: 200 }]
       @UI.identification: [{ position: 200 }]
       @EndUserText.label: 'This Bill Qty'
       //    @Semantics.quantity.unitOfMeasure: 'Uom'
  key  cast(a.MbsQty as abap.dec( 12, 2 ))       as MbsQty,

       @UI.lineItem: [{ position: 210 }]
       @UI.identification: [{ position: 210 }]
       @EndUserText.label: 'Upto Date Qty'
       //    @Semantics.quantity.unitOfMeasure: 'Uom'
  key  cast(a.QtyDeductUtd as abap.dec( 12, 2 )) as UptoDateQty,

       @UI.lineItem: [{ position: 220 }]
       @UI.identification: [{ position: 220 }]
       @EndUserText.label: 'Upto Previous Qty'
       //    @Semantics.quantity.unitOfMeasure: 'Uom'
  key  cast(a.QtyDeduct as abap.dec( 12, 2 ))    as UptoPrevQty,

       @UI.lineItem: [{ position: 230 }]
       @UI.identification: [{ position: 230 }]
       @EndUserText.label: 'Upto Date Amount'
  key  cast(a.UptoDateAmt as abap.dec( 12, 2 ))  as UptoDateAmt,

       @UI.lineItem: [{ position: 240 }]
       @UI.identification: [{ position: 240 }]
       @EndUserText.label: 'Upto Previous Amount'
  key  cast(a.UptoPrevAmt as abap.dec( 12, 2 ))  as UptoPrevAmt,

       @UI.lineItem: [{ position: 250 }]
       @UI.identification: [{ position: 250 }]
       @EndUserText.label: 'This Bill Amount'
  key  cast(a.ThisBillAmt as abap.dec( 12, 2 ))  as ThisBillAmt,

       @UI.lineItem: [{ position: 260 }]
       @UI.identification: [{ position: 260 }]
       @EndUserText.label: 'Previous SES QTY'
  key  cast(h.prev_qty as abap.dec( 12, 2 ))     as PrevQty

       //    @UI.lineItem: [{ position: 270 }]
       //    @UI.identification: [{ position: 270 }]
       //    @EndUserText.label: 'Previous Work Done QTY(SITC)'
       ////    key cast(i.pre_wd_qty as abap.dec( 12, 2 )) as PreWdQty,
       //    key cast(i.Work_done_Qty as abap.dec( 12, 2 )) as PreWdQty,
       //
       //    @UI.lineItem: [{ position: 280 }]
       //    @UI.identification: [{ position: 280 }]
       //    @EndUserText.label: 'Work done Qty(SITC)'
       //    key cast(h.work_done_qty as abap.dec( 12, 2 )) as WorkDoneQty,
       //
       //    @UI.lineItem: [{ position: 290 }]
       //    @UI.identification: [{ position: 290 }]
       //    @EndUserText.label: 'This Bill SES Qty'
       //    @Aggregation.default: #SUM
       //    key cast(h.total_qty as abap.dec( 12, 2 )) as TotalQty,
       //
       //    @UI.lineItem: [{ position: 300 }]
       //    @UI.identification: [{ position: 300 }]
       //    @EndUserText.label: 'Upto QTY(SITC)'
       //    @Aggregation.default: #SUM
       //    key cast(h.upto_qty as abap.dec( 12, 2 )) as UptoQty

}
