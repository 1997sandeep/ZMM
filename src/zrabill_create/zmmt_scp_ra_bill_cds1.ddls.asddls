@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for RA Bill screen'
@Metadata.allowExtensions: true
define root view entity ZMMT_SCP_RA_BILL_CDS1
  as select from zmmt_scp_rabill1
{
  key ra_bill_no            as RaBillNo,
  key ebeln                 as Ebeln,
  key ebelp                 as Ebelp,
      hierarchy             as Hierarchy,
      rcount                as Rcount,
      this_bill             as ThisBill,
      this_bill_d           as ThisBillD,
      hold_qty              as HoldQty,
      this_act              as ThisAct,
      uom                   as Uom,
      ra_bill_from          as RaBillFrom,
      ra_bill_to            as RaBillTo,
      sheet_no              as SheetNo,
      final_proces          as FinalProces,
      post_date             as PostDate,
      without_dpr           as WithoutDpr,
      remarks               as Remarks,
      wo_qty_new            as WoQtyNew,
      qty_deduct            as QtyDeduct,
      qty_deduct_utd        as QtyDeductUtd,
      amt_deduct            as AmtDeduct,
      cutover               as Cutover,
      rel_hold_qty          as RelHoldQty,
      total_hold            as TotalHold,
      qty_reduced_reco      as QtyReducedReco,
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
      del_flag              as DelFlag,
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
      //_association_name // Make association public
}
