using CatalogService as service from '../../srv/CatalogService';

annotate service.POs with @(
    Common.DefaultValuesFunction : 'getOrderDefaults', //Default status setting while creating new record
    UI.HeaderInfo :{
        TyepeName :'POs',
        TypeNamePlural :'Purchase Orders',
        Title : {Value : PO_ID},
        Description : {Value : PARTNER_GUID.COMPANY_NAME},
        ImageUrl :'https://images.seeklogo.com/logo-png/39/2/invenio-business-solutions-logo-png_seeklogo-390522.png?v=1957740523584758880'
    },
    
    UI.SelectionFields :[
       PO_ID,
       PARTNER_GUID.COMPANY_NAME,
       PARTNER_GUID.ADDRESS_GUID.COUNTRY,
       GROSS_AMOUNT,
       OVERALL_STATUS,
    ],
    
    UI.LineItem :[
        {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.COMPANY_NAME,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
      {
          $Type : 'UI.DataFieldForAction',
          Action : 'CatalogService.setOrderProcessing',
          Label : 'Set Order Status',
          Inline : false
      },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'CatalogService.boost',
            Label : 'Boost',
            Inline : true ,
        },
        {
           // $Type : 'UI.DataField',
            //Value : OVERALL_STATUS,

            $Type : 'UI.DataField',
            Value :  OVERALLSATUS,
            Criticality : ColorCode
        },
    ],
    UI.Facets :[
        {
            $Type : 'UI.CollectionFacet',
            Label : 'PO Information',
            Facets : [
                {
                    $Type : 'UI.ReferenceFacet',
                    Target : '@UI.Identification',
                    Label :  'More Info'

                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label :'Prices',
                    Target : '@UI.FieldGroup#SpiderMan',
                    

                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Status',
                    Target : '@UI.FieldGroup#Superman',
                  

                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target : 'Items/@UI.LineItem',
                    Label : 'PO Items'
                  

                },
                

            
            ]
        }
    ],
    UI.Identification :[
        {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID_NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : LIFECYCLE_STATUS,
        }

    

    ],
    UI.FieldGroup#SpiderMan :{
        Label :'Prices',
        Data :[
            {
                $Type : 'UI.DataField',
                Value : GROSS_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : NET_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : TAX_AMOUNT,
            }
        ]
    },
    UI.FieldGroup#Superman :
    {   Label : 'Status',
        Data :[
            {
                $Type :'UI.DataField',
                Value : CURRENCY_code,
            }, 
             {
                $Type : 'UI.DataField',
                Value : OVERALL_STATUS,
            }
                
            
        ]
    }


) ;

annotate service.POItems with @(
    UI.LineItem :[
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value :  PRODUCT_GUID.DESCRIPTION,
        },
        {
            $Type : 'UI.DataField',
            Value :  GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value :  CURRENCY_code,
        },
    ]
    ,UI.Facets :[
         {
             $Type : 'UI.CollectionFacet',
             Label :'More Details',
             Facets :[
                {
                    $Type : 'UI.ReferenceFacet',
                    Target : '@UI.Identification',
                },
             ]
         },
    ],
    UI.Identification :[
        {
            $Type : 'UI.DataField',
            Value : NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS
            ,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : NET_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : TAX_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        
    ]


);

annotate service.POs with {
    PARTNER_GUID @(
        Common.ValueList.entity : 'CatalogService.ProductSet',
        Common.Text : PARTNER_GUID.COMPANY_NAME
    )
} ;
@cds.odata.valuelist 
annotate CatalogService.BusinessPartnerSet with @(
    UI.Identification :[
     {
         $Type : 'UI.DataField',
         Value : COMPANY_NAME,
     },
     
    ]
) ;
annotate service.POItems with {
    PRODUCT_GUID @( 
        Common.ValueList.entity : 'CatalogService.ProductSet',
        Common.Text : PRODUCT_GUID.DESCRIPTION,
    )
} ;




@cds.odata.valuelist  
annotate CatalogService.ProductSet with @(
    UI.Identification :[
     {
         $Type : 'UI.DataField',
         Value :  DESCRIPTION,
     },
     
    ]
) ;


