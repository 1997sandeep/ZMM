@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '##GENERATED #'
@Metadata.allowExtensions: true
define root view entity ZMM_RABILL_EDIT
  as select from zmmt_scp_rabill1 as RABILL_EDIT
{
  key ra_bill_no            as RaBillNo,
  key ebeln                 as Ebeln,
  key ebelp                 as Ebelp,
      rcount                as Rcount,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      this_bill             as ThisBill,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      this_bill_d           as ThisBillD,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      hold_qty              as HoldQty,
      @Semantics.quantity.unitOfMeasure: 'Uom' 
      this_act              as ThisAct,
      uom                   as Uom,
      ra_bill_from          as RaBillFrom,
      ra_bill_to            as RaBillTo,  
      sheet_no              as SheetNo,
      final_proces          as FinalProces,
      post_date             as PostDate,
      without_dpr           as WithoutDpr,
      remarks               as Remarks,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      wo_qty_new            as WoQtyNew,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      qty_deduct            as QtyDeduct,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      qty_deduct_utd        as QtyDeductUtd,
      amt_deduct            as AmtDeduct,
      cutover               as Cutover,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      rel_hold_qty          as RelHoldQty,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      total_hold            as TotalHold,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      qty_reduced_reco      as QtyReducedReco,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      prev_hold             as PrevHold,
      final_bill            as FinalBill,
      reversal_no           as ReversalNo,
      reversal_date         as ReversalDate,
      erdat                 as Erdat,
      final_process         as FinalProcess,
      sesno                 as Sesno,
      rate                  as Rate,
      this_bill_amt         as ThisBillAmt,
      upto_prev_amt         as UptoPrevAmt,
      upto_date_amt         as UptoDateAmt,
      zcurr                 as Zcurr,
      mbs_qty               as MbsQty,
      inv_num               as InvNum,
      inv_date              as InvDate,
      deduction1 as Deduction1,
      deduction2 as Deduction2,
      remark1 as Remark1,
      remark2 as Remark2,
      checkbox as Checkbox,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt

}
