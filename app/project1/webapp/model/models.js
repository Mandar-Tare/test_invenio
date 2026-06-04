sap.ui.define([
    "sap/ui/model/json/JSONModel",
    "sap/ui/Device"
], 
function (JSONModel, Device) {
    "use strict";

    return {
        /**
         * Provides runtime information for the device the UI5 app is running on as a JSONModel.
         * @returns {sap.ui.model.json.JSONModel} The device model.
         */
        createDeviceModel: function () {
            var oModel = new JSONModel(Device);
            oModel.setDefaultBindingMode("OneWay");
            return oModel;
        },
        getMasterCapacityData: async function () {

            const sUrl = "/odata/v4/CatalogService/MasterCapacity";

            try {
                const response = await fetch(sUrl);

                if (!response.ok) {
                    throw new Error("Failed to fetch data");
                }

                const data = await response.json();

                data.value.sort((a, b) => {
            return a.ERDAT.localeCompare(b.ERDAT);
        });


                return data.value;

            } catch (error) {
                console.error(error);
                return [];
            }
        }


    };

});