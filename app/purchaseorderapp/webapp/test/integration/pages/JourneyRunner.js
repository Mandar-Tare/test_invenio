sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"inv/purchaseorderapp/test/integration/pages/POsList",
	"inv/purchaseorderapp/test/integration/pages/POsObjectPage",
	"inv/purchaseorderapp/test/integration/pages/POItemsObjectPage"
], function (JourneyRunner, POsList, POsObjectPage, POItemsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('inv/purchaseorderapp') + '/test/flpSandbox.html#invpurchaseorderapp-tile',
        pages: {
			onThePOsList: POsList,
			onThePOsObjectPage: POsObjectPage,
			onThePOItemsObjectPage: POItemsObjectPage
        },
        async: true
    });

    return runner;
});

