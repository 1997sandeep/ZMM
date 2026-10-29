@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header Data for Rabill Payment Abstract'
define root view entity ZMM_RABILL_PAY_ABSTRACT_HEADER
  //  as select from    zmmt_scp_rabill1           as a1 //commented
  as select distinct from ZMM_RABILL_PAY_ABSTRACT_RABIL2 as a //added for rabillno f4 for advance
  //      left outer join zmmt_scp_rabill1             as a1 on a.Ebeln = a1.ebeln //commented 21.09.2023
  //    left outer join I_PurchaseOrderAPI01           as a2 on a1.ebeln = a2.PurchaseOrder //commented 21.09.2023
    left outer join       I_PurchaseOrderAPI01           as a2  on a.Ebeln = a2.PurchaseOrder
  //    left outer join ZMM_WO_PAYABSTRACT         as a2 on a1.ebeln = a2.PurchaseOrder
  //    left outer join I_PurchaseOrderItemAPI01   as a3 on a2.PO = a3.PurchaseOrder
    left outer join       I_PurchaseOrderItemAPI01       as a3  on a2.PurchaseOrder = a3.PurchaseOrder
    left outer join       I_Supplier                     as a4  on a2.Supplier = a4.Supplier
    left outer join       I_Region                       as a5  on a4.Region = a5.Region
    left outer join       I_BusPartAddrDepdntTaxNmbr     as a6  on a2.Supplier = a6.BusinessPartner
    left outer join       I_Plant                        as a7  on a3.Plant = a7.Plant
    left outer join       I_RegionText                   as a8  on  a5.Region   = a8.Region
                                                                and a8.Language = 'E'
                                                                and a8.Country  = 'IN'
  //    left outer join zmmt_scp_rabill1               as a1 on a2.PurchaseOrder = a1.ebeln
    left outer join       ZMM_RABILL_PAY_ABSTRACT_RBILL2 as a1  on a2.PurchaseOrder = a1.Ebeln
    left outer join       I_Businesspartnertaxnumber     as a9  on  a4.Supplier  = a9.BusinessPartner
                                                                and a9.BPTaxType = '9IN2'
    left outer join       I_Businesspartnertaxnumber     as a10 on  a4.Supplier   = a10.BusinessPartner
                                                                and a10.BPTaxType = '9IN3'

{
      //  key a1.ra_bill_no                  as Rabillno,
      //  key a1.ebeln                       as Ebeln,
  key a.RabillNo                     as Rabillno,
  key a.Ebeln                        as Ebeln,
      //      a1.ra_bill_from                as Rabillfrom,
      //      a1.ra_bill_to                  as Rabillto,

      a1.RaBillFrom                  as Rabillfrom,
      a1.RaBillTo                    as Rabillto,
      a2.Supplier                    as Supplier,
      a4.SupplierName                as SupplierName,

      a4.BusinessPartnerPanNumber    as PAN,
      //      a9.BPTaxNumber                 as PAN,
      a3.Plant                       as Plant,
      a7.PlantName                   as PlantName,
      a5.Country                     as Country,
      a5._Country                    as _Country,
      a5.Region                      as Region,
      a5._RegionText                 as State,
      a8.RegionName                  as State1,
      a4.TaxNumber3                  as Gstin,
      //      a10.BPTaxNumber                as Gstin,
      a1.InvDate                     as InvDate,
      a1.InvNum                      as InvNum,
      cast('' as abap.char( 50 ))    as VendorInvoice,
      cast('' as abap.char( 10 ))    as GlAccNo,
      cast('' as abap.char( 5 ))     as HouseBankId,
      cast('' as abap.char( 5 ))     as AccountId,
      cast('' as abap.char( 10 ))    as BillDate,
      cast('' as abap.char( 10 ))    as PostingDate,
      cast('' as abap.char( 10 ))    as ProfitCenter,
      //For Item Level Data Need to Save in ZTable (zmmt_scp_pa1,zmmt_scp_ra_payi)
      cast('' as abap.char( 4 ))     as ItemCode,
      cast('' as abap.cuky( 5 ))     as zcurr,
      @Semantics.amount.currencyCode : 'zcurr'
      cast(0  as abap.curr( 15, 2 )) as thisbill,
      @Semantics.amount.currencyCode : 'zcurr'
      cast(0  as abap.curr( 15, 2))  as uptodate,
      @Semantics.amount.currencyCode : 'zcurr'
      cast(0  as abap.curr( 15, 2))  as uptolast,
      cast('' as abap.char( 100 ))   as remarks,
      cast('' as abap.numc( 3 ))     as SrNo,
      cast('' as abap.char( 2 ))     as SrNumber,
      cast('' as abap.char( 50 ))    as PaMasterDescription,
      cast('' as abap.char( 10 ))    as GlAcc,
      @Semantics.amount.currencyCode : 'zcurr'
      cast(0 as abap.curr( 6, 2 ))   as Tax,
      cast('' as abap.char( 4 ))     as BusinessPlace,
      cast('' as abap.char( 4 ))     as Sectioncode
}
where
      a5.Country =  'IN'
  and a3.Plant   <> ''
group by
//  a1.ra_bill_no,
//  a1.ebeln,
  a.RabillNo,
  a.Ebeln,
  //  a1.ra_bill_from,
  //  a1.ra_bill_to,
  a1.RaBillFrom,
  a1.RaBillTo,
  a2.Supplier,
  a4.SupplierName,
  a3.Plant,
  a7.PlantName,
  a5.Country,
  a5.Region,
  a6.BPTaxNumber,
  a8.RegionName,
  a4.TaxNumber3,
  a4.TaxNumber2,
  //a9.BPTaxNumber,
  //a10.BPTaxNumber,
  a1.InvDate,
  a1.InvNum,
  a4.BusinessPartnerPanNumber
