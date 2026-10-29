@EndUserText.label: 'Custom entity for po aging'
@Metadata.allowExtensions: true
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZPO_AGING_CL'
    }
}

@UI.headerInfo: {
    typeName: 'Payment Ageing Report',
    typeNamePlural: 'Payment Ageing Report',
    title:{
          type : #STANDARD,
          label: 'Payment Ageing Report'
    }
}
define custom entity ZPO_AGING_ENTITY
{


      @UI.lineItem      : [{ position: 10 }]
      @UI.selectionField: [{ position: 20 }]
      @EndUserText.label: 'Company Code'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: {
                                                        name: 'ZCOMPANY_CODE_F4',
                                                        element: 'CompanyCode'
                                                     } }]
                                                     @UI.identification: [{ position: 10 }]
  key companycode       : abap.numc(4);
  
  @UI.lineItem: [{ position: 30 , label: 'Purchase Order' }]
  @UI.selectionField: [{ position: 10 }]
  @EndUserText.label: 'Purchase Order'
  @Consumption.valueHelpDefinition: [{ entity: {
      name: 'ZPO_F4',
      element: 'PurchaseOrder'
  } }]
  @UI.identification: [{ position: 20 }]
  key pono                : abap.numc( 10 );
  
      @UI.lineItem: [{ position: 20 ,label: 'Project Name'}]
      @UI.identification: [{ position: 10 }]
   key   companyname       : abap.char(150);
      
      @UI.lineItem: [{ position: 40 ,label: 'PO Creation Date'}]
      @UI.identification: [{ position: 30 }]
   key   podate            : abap.char(11);
      
      @UI.lineItem: [{ position: 50 ,label: 'Vendor Name'}]
      @UI.identification: [{ position: 40 }]
      suppliername      : abap.char(150); 
           
      @UI.lineItem: [{ position: 52 ,label: 'GSTIN'}]
      @UI.identification: [{ position: 52 }]
      gstin : abap.char(20);
      
        @UI.lineItem: [{ position: 55 ,label: 'Vendor Type'}]
      @UI.identification: [{ position: 55 }]
      vendortype : abap.char(40);
      
      @UI.lineItem: [{ position: 60 ,label: 'Basic Value'}] 
      @UI.identification: [{ position: 50 }]
//      @Aggregation.default: #SUM
      basicvalue        : abap.dec( 13, 2 );
      
      @UI.lineItem: [{ position: 70 ,label: 'GST'}]
      @UI.identification: [{ position: 60 }]
      
      gst               : abap.dec( 13, 2 );
      
      @UI.lineItem: [{ position: 80 ,label: 'Total Value'}]
      @UI.identification: [{ position: 70 }]
       @EndUserText.label: 'Total Value'
      totvalue          : abap.dec( 13, 2 );
      
      @UI.lineItem: [{ position: 90 ,label: 'PO 1st Approval'}]
      @UI.identification: [{ position: 10 }]
      poapp_1_name      : abap.char(50);
      
      @UI.lineItem: [{ position: 100 ,label: 'Date'}]
      poapp_1_date      : abap.char(11);
      
      @UI.lineItem: [{ position: 110 ,label: 'PO 2nd Approval'}]
      poapp_2_name      : abap.char(50);
      
      @UI.lineItem: [{ position: 120 ,label: 'Date'}]
      poapp_2_date      : abap.char(11);
      
      @UI.lineItem: [{ position: 130 ,label: 'PO 3rd Approval'}]
      poapp_3_name      : abap.char(50);
         
      @UI.lineItem: [{ position: 140 ,label: ' Date'}]
      poapp_3_date      : abap.char(11);
      
      @UI.lineItem: [{ position: 150 ,label: 'SES/GRN No'}]
      ses_grnno         : abap.char( 10 );
      
      @UI.lineItem: [{ position: 160 ,label: 'SES/GRN Creation Date '}]
      ses_grndate       : abap.char(11);
      
      @UI.lineItem: [{ position: 170 ,label: 'SES 1st Approval'}]
      sesgrn_1_name     : abap.char(50);
      
      @UI.lineItem: [{ position: 180 ,label: 'Date'}]
      sesgrn_1_date     : abap.char(11);
      
      @UI.lineItem: [{ position: 200 ,label: 'SES 2nd Approval'}]
      sesgrn_2_name     : abap.char(50);
      
//      @UI.lineItem: [{ position: 210 ,label: 'Date'}]

      sesgrn_2_date     : abap.char(11);
      
      @UI.lineItem: [{ position: 220 ,label: 'SES 3nd Approval'}]
      sesgrn_3_name     : abap.char(50);
      
      @UI.lineItem: [{ position: 230 ,label: 'Date'}]
      sesgrn_3_date     : abap.char(11);
      
      @UI.lineItem: [{ position: 240 ,label: 'RA Bill No'}]
      rabillno          : abap.char(15);
      
      @UI.lineItem: [{ position: 250 ,label: 'Invoice No (SAP)'}]
      invno             : abap.numc(10);
      
      @UI.lineItem: [{ position: 252 ,label: 'Inv Date (Vendor)'}]
      invdoc_date             :abap.char(11);
      
      @UI.lineItem: [{ position: 260 ,label: 'Invoice No (Vendor)'}]
      invref            : abap.char(30);
      
      @UI.lineItem: [{ position: 270 ,label: 'Invoice Creation Date'}]
      invdate           : abap.char(11);
      
           @UI.lineItem: [{ position: 272 ,label: 'Taxable Value'}]
               taxablevalue : abap.dec( 13, 2 );
     
      
      @UI.lineItem: [{ position: 280 ,label: 'Invoice Amt'}]
//      @Aggregation.default: #SUM
      invamt            : abap.dec( 13, 2 );
      
      @UI.lineItem: [{ position: 282 ,label: 'PO Status'}]
           postatus : abap.char(40);
      
      @UI.lineItem: [{ position: 290 ,label: 'Invoice 1st Approval'}]
      inv_1_name        : abap.char(50);
      
      @UI.lineItem: [{ position: 300 ,label: 'Date'}]
      inv_1_date        : abap.char(11);
      
      @UI.lineItem: [{ position: 310 ,label: 'Invoice 2nd Approval'}]
      inv_2_name        : abap.char(50);
      
      @UI.lineItem: [{ position: 320 ,label: 'Date'}]
      inv_2_date        : abap.char(11);
      
      @UI.lineItem: [{ position: 330 ,label: 'Invoice 3rd Approval'}]
      inv_3_name        : abap.char(50);
      
      @UI.lineItem: [{ position: 340 ,label: 'Date'}]
      inv_3_date        : abap.char(11);
      
      @UI.lineItem: [{ position: 350 ,label: 'Payment Abs Creation Date'}]
      paymentabs_date   : abap.char(11);
      
      @UI.lineItem: [{ position: 360 ,label: 'Payment Abs 1st Approval'}]
      paymentabs_1_name : abap.char(50);
      
      @UI.lineItem: [{ position: 370 ,label: 'Date'}]
      paymentabs_1_date : abap.char(11);
      
      @UI.lineItem: [{ position: 380 ,label: 'Payment Abs 2nd Approval'}]
      paymentabs_2_name : abap.char(50);
      
      @UI.lineItem: [{ position: 390 ,label: 'Date'}]
      paymentabs_2_date : abap.char(11);
      
      @UI.lineItem: [{ position: 400 ,label: 'Payment Abs 3rd Approval'}]
      paymentabs_3_name : abap.char(50);
      
      @UI.lineItem: [{ position: 410 ,label: 'Date'}]
      paymentabs_3_date : abap.char(11);
      
      @UI.lineItem: [{ position: 420 ,label: 'Payment Amt'}]
      paymentamt        : abap.dec( 13, 2 );
      
       @UI.lineItem: [{ position: 422 ,label: 'Payment Due Date'}]
      paymentduedate  : abap.char(11);
      
    
      
      @UI.lineItem: [{ position: 430 ,label: 'Proposed Pay Date'}]
      proposed_date     : abap.char(11);
      
      @UI.lineItem: [{ position: 440 ,label: 'Payment Date'}]
      payment_date      : abap.char(11);
      
         @UI.lineItem: [{ position: 442 ,label: 'bank Name'}]
              bankname : abap.char(40);
              
       @UI.lineItem: [{ position: 445 ,label: 'Bank Account'}]
              bankacc : abap.char(20);
      
      @UI.lineItem: [{ position: 450 ,label: 'UTR Details'}]
      utr               : abap.char(150);
      
      @UI.lineItem: [{ position: 460 ,label: 'Payment Delay'}]
      Payment_Delay               : abap.int2;
      
      @UI.lineItem: [{ position: 470 ,label: 'Final App to Pay'}]
      Final_App_Pay_day               : abap.int2;
      
      @UI.lineItem: [{ position: 480 ,label: 'Days from Inv Date'}]
      Days_from_InvDate               : abap.int2;
      @UI.lineItem: [{ position: 490 ,label: 'Payment Reco. Day'}]
      rec_date               : abap.char(11);
      @UI.lineItem: [{ position: 490 ,label: 'Payment Reco. Date'}]
      rec_day               : abap.int2;
      @UI.lineItem: [{ position: 490 ,label: 'Payment Ind.'}]
      payment_ind               : abap.char( 20 );

}
