namespace mandar.db;

using { cuid, managed, temporal, Currency } from '@sap/cds/common';
using { mandar.common } from './commons';

context master {
    
    entity businesspartner {
        key NODE_KEY: common.Guid @(title : '{i18n>PARTNER_GUID}');
        BP_ROLE: String(2);
        EMAIL_ADDRESS: String(105);
        PHONE_NUMBER: String(32);
        FAX_NUMBER: String(32);
        WEB_ADDRESS: String(44);
        ADDRESS_GUID: Association to address   @(title : '{i18n>ADDRESS_GUID}');
        BP_ID: String(32);
        COMPANY_NAME: String(250)  @(title : '{i18n>COMPANY_NAME}');
    }

    entity address {
        key NODE_KEY: common.Guid;
        CITY: String(44);
        POSTAL_CODE: String(8);
        STREET: String(44);
        BUILDING: String(128);
        COUNTRY: String(44) @(title : '{i18n>COUNTRY}');
        ADDRESS_TYPE: String(44);
        VAL_START_DATE: Date;
        VAL_END_DATE: Date;
        LATITUDE: Decimal;
        LONGITUDE: Decimal;
        businesspartner: Association to one businesspartner on
        businesspartner.ADDRESS_GUID = $self;
    }

    entity product{
        key NODE_KEY: common.Guid @(title : '{i18n>PRODUCT_GUID}');
        PRODUCT_ID: String(28) @(title : '{i18n>PRODUCT_ID}');
        TYPE_CODE: String(2);
        CATEGORY: String(32);
        DESCRIPTION: localized String(255);
        SUPPLIER_GUID: Association to master.businesspartner;
        TAX_TARIF_CODE: Integer;
        MEASURE_UNIT: String(2);
        WEIGHT_MEASURE: Decimal(5,2);
        WEIGHT_UNIT: String(2);
        CURRENCY_CODE: String(4);
        PRICE:Decimal(15,2);
        WIDTH:Decimal(5,2);
        DEPTH:Decimal(5,2);
        HEIGHT:Decimal(5,2);
        DIM_UNIT:String(2);
    }

    entity employees: cuid {
        nameFirst: String(40);
        nameMiddle: String(40);
        nameLast: String(40);
        nameInitials: String(40);
        sex: common.Gender;
        language: String(1);
        phoneNumber: common.PhoneNumber;
        email: common.Email;
        loginName: String(12);
        Currency: Currency;
        salaryAmount: common.AmountT;
        accountNumber: String(16);
        bankId: String(40);
        bankName: String(64);
    }

   /* entity MasterCapacity {

    key VBELN : Integer;
    AUFNR : String(20);
    MATNR : String(40);
    WERKS : String(10);
    ERDAT : String(10);
    ERZET : String(8);
    ERZAT : String(8);
    STATUS : String(20);
    QUANTITY: Decimal(15,3);
    DESCRIPTION : String(255);

}*/

entity MasterCapacity {
    key MANDT     : String(3); // Client
    key VBELN     : String(10); // Sales Document Number
    key POSNR     : String(6); // Item Number
        ARKTX     : String(40); // Item Text / Short Description
        NETWR     : Decimal(15, 2); // Net Value
        WAERK     : String(5); // Currency Key
        ERDAT     : Date; // Creation Date
        ERZET     : Time; // Creation Time
        ERZAT     : Time;
        KUNNR_ANA : String(10); // Account Assignment Customer
}

}

context transaction {
    entity purchaseorder: common.Amount,cuid{
        //key NODE_KEY: common.Guid @(title : '{i18n>PO_KEY}');  For Draft Application Scenario Commenting Out for auto generation
        PO_ID: String(40) @(title : '{i18n>PO_ID}');
        PARTNER_GUID: Association to master.businesspartner @(title : '{i18n>PARTNER_GUID}');
        LIFECYCLE_STATUS: String(1) @(title : '{i18n>OVERALL_SATUS}');
        OVERALL_STATUS: String(1) @(title : '{i18n>OVERALL_SATUS}');
        Items: Composition of  many poitems on Items.PARENT_KEY = $self;
    }

    entity poitems: common.Amount,cuid{
        //key NODE_KEY: common.Guid @(title : '{i18n>PO_ITEM_KEY}'); for draft Scenario Commenting Out
        PARENT_KEY: Association to purchaseorder @(title : '{i18n>PARTNER_GUID}');
        PO_ITEM_POS: Integer @(title : '{i18n>PO_ITEM_POS}');
        PRODUCT_GUID: Association to master.product @(title : '{i18n>PRODUCT_GUID}');
    }
}


