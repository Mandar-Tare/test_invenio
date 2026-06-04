sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel",
    "sap/gantt/misc/Format",
    "sap/gantt/misc/Utility",
    "sap/ui/export/Spreadsheet",
    "../model/models"
], (Controller, JSONModel, Format, Utility, Spreadsheet, Model) => {
    "use strict";

    return Controller.extend("demo.project1.controller.MainView", {
        onInit: async function () {
            const aData = await Model.getMasterCapacityData();



            var aTreeData = this._buildMonthHierarchy(aData);

            var oJsonModel = new JSONModel({
                root: aTreeData
            });

            this.getView().setModel(oJsonModel);

            // var oModel = new JSONModel(sap.ui.require.toUrl("demo/project1/model/data.json"));
            // this.getView().setModel(oModel);
            var Items = ['enableNowLine', 'enableAdhocLine', 'enableStatusBar'];
            this.getView().byId("gantt").getParent().setProperty('hideSettingsItem', Items);

            var oModel1 = new sap.ui.model.json.JSONModel({
                start: new Date(2026, 5, 1),
                end: new Date(2026, 5, 30)
            });

            this.getView().setModel(oModel1, "datemodel");





        },

        _buildMonthHierarchy: function (aOrders) {

            var oMonths = {};

            aOrders.forEach(function (oOrder) {

                //----------------------------------
                // ERDAT => YYYYMMDD
                //----------------------------------

                var sDate = oOrder.ERDAT.replace(/-/g, "");

                var oDate = new Date(
                    sDate.substring(0, 4),
                    sDate.substring(4, 6) - 1,
                    sDate.substring(6, 8)
                );

                var sMonth = oDate.toLocaleString("en", {
                    month: "long"
                });

                var sYear = oDate.getFullYear();

                var sMonthKey = sMonth + " " + sYear;

                //----------------------------------
                // Create Month Node
                //----------------------------------

                if (!oMonths[sMonthKey]) {

                    oMonths[sMonthKey] = {
                        id: sMonthKey.replace(/\s/g, "_"),
                        text: sMonthKey,
                        children: []
                    };
                }

                //----------------------------------
                // Create Sales Order Node
                //----------------------------------


                var dStart = oOrder.ERZET;
                var dEnd = oOrder.ERZAT;

                //dEnd.setDate(dEnd.getDate() + 15);

                oMonths[sMonthKey].children.push({

                    id: oOrder.VBELN,

                    text:
                        oOrder.VBELN +
                        " - " +
                        oOrder.ARKTX,

                    VBELN: oOrder.VBELN,

                    POSNR: oOrder.POSNR,

                    ARKTX: oOrder.ARKTX,

                    NETWR: oOrder.NETWR,

                    WAERK: oOrder.WAERK,

                    ERDAT: oOrder.ERDAT,

                    ERZET: oOrder.ERZET,

                    ERZAT: oOrder.ERZAT,

                    task: [{
                        startTime: this._formatDateForGantt(sDate, dStart),
                        endTime: this._formatDateForGantt(sDate, dEnd)
                    }]
                });

            }.bind(this));

            return Object.values(oMonths);
        },


        onDownloadPress: function () {

            var oTreeTable = this.byId("gantt").getTable();

            var aSelectedIndices = oTreeTable.getSelectedIndices();

            if (aSelectedIndices.length === 0) {
                sap.m.MessageToast.show(
                    "Please select at least one Sales Order"
                );
                return;
            }

            var aExportData = [];

            aSelectedIndices.forEach(function (iIndex) {

                var oContext =
                    oTreeTable.getContextByIndex(iIndex);

                if (!oContext) {
                    return;
                }

                var oRowData = oContext.getObject();

                
                if (oRowData.children) {
                    return;

                    
                }

                aExportData.push({

                    SalesOrder: oRowData.VBELN,

                    Item: oRowData.POSNR,

                    Description: oRowData.ARKTX,

                    NetValue: oRowData.NETWR,

                    Currency: oRowData.WAERK,

                    CreationDate: oRowData.ERDAT,

                    StartDate: oRowData.ERZET,

                    EndDate: oRowData.ERZAT
                });

            });

            if (aExportData.length === 0) {

                sap.m.MessageToast.show(
                    "Please select Sales Order rows only"
                );

                return;
            }

            var oSettings = {

                workbook: {

                    columns: [

                        {
                            label: "Sales Order",
                            property: "SalesOrder",
                            type: "string"
                        },

                        {
                            label: "Item",
                            property: "Item",
                            type: "string"
                        },

                        {
                            label: "Description",
                            property: "Description",
                            type: "string"
                        },

                        {
                            label: "Net Value",
                            property: "NetValue",
                            type: "number"
                        },

                        {
                            label: "Currency",
                            property: "Currency",
                            type: "string"
                        },

                        {
                            label: "Creation Date",
                            property: "CreationDate",
                            type: "string"
                        },

                        {
                            label: "Start Date",
                            property: "StartDate",
                            type: "string"
                        },

                        {
                            label: "End Date",
                            property: "EndDate",
                            type: "string"
                        }
                    ]
                },

                dataSource: aExportData,

                fileName:
                    "Selected_Sales_Orders_" +
                    new Date().getTime() +
                    ".xlsx"
            };

            var oSpreadsheet =
                new Spreadsheet(oSettings);

            oSpreadsheet.build()
                .finally(function () {
                    oSpreadsheet.destroy();
                });
        },



        _formatDateForGantt: function (oDate, Time) {

            
            var tame = Time.replace(/:/g, "");

            return oDate + tame;
        },

        fnTimeConverter: function (sTime) {

            if (!sTime) {
                return null;
            }

            return new Date(
                sTime.substring(0, 4),
                sTime.substring(4, 6) - 1,
                sTime.substring(6, 8),
                sTime.substring(8, 10),
                sTime.substring(10, 12),
                sTime.substring(12, 14)
            );
        },


        fnTimeConverter: function (sTimestamp) {
            return Format.abapTimestampToDate(sTimestamp);
        },

        onRowSelectionChange: function (oEvent) {

            var oContext = oEvent.getParameter("rowContext");

            if (!oContext) {
                return;
            }

            var oData = oContext.getObject();

            if (!oData.task || !oData.task.length) {
                return;
            }

            var sStartTime = oData.task[0].startTime;

            var oGantt = this.byId("gantt");

            oGantt.jumpToPosition(new Date(
                sStartTime.substring(0, 4),
                sStartTime.substring(4, 6) - 1,
                sStartTime.substring(6, 8),
                sStartTime.substring(8, 10),
                sStartTime.substring(10, 12),
                sStartTime.substring(12, 14)
            ));
        }


    });
});