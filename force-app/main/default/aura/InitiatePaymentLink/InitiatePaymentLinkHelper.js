({
    getOpportunityData: function (component, event) {
        debugger;
        var action = component.get("c.getOpportunityData");
        var recordId = component.get("v.recordId");

        action.setParams({
            opportunityID: recordId
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var result = a.getReturnValue();

                if (result.oppRecord.Due_Payment__c == null || result.oppRecord.Due_Payment__c == undefined || result.oppRecord.Due_Payment__c == "") {
                    alert('Add products first!!');
                } else {
                    console.log('result--', result);
                    component.set("v.totalAmount", result.oppRecord.Due_Payment__c);
                    component.set("{!v.PayOption}", result.payOption);
                    component.set("{!v.PayType}", result.payType);
                    component.set("{!v.PayChannel}", result.payChannel);
                    component.set("{!v.PayMode}", result.payMode);
                    component.set("v.upfrontPayment", result.oppRecord.Due_Payment__c);
                    console.log('result', result);

                }
            }
            else if (state === "ERROR") {
                var error = action.getError();
                if (error) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },


    Save: function (component, event) {
        debugger;
        let button = event.getSource();
        button.set('v.disabled', true);

        var action = component.get("c.fetchOppRec");
        var oppId = component.get("v.recordId");
        action.setParams({
            "recordId": component.get("v.recordId"),
            "PaymentOptions": component.get("v.Optvalue"),
            "PaymentType": component.get("v.Typvalue"),
            "PaymentChannel": component.get("v.Chnvalue"),
            "PaymentMode": component.get("v.Modvalue"),
            "UpfrontPay": component.get("v.upfrontPayment")
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                component.set("v.invoiceId",a.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: 'SUCCESS',
                    message: 'Details Saved Successfully !',
                    duration: ' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
            } else if (state === "ERROR") {
                var error = action.getError();
                if (error) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            $A.get('e.force:refreshView').fire();

        });
        $A.enqueueAction(action);
        $A.get("e.force:refreshView").fire();
    },


    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 

    uploadHelper: function (component, event) {
        debugger;
        var fileInput = component.find("fuploader").get("v.files");
        var file = fileInput[0];
        var self = this;
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }

        var objFileReader = new FileReader();
        objFileReader.onload = $A.getCallback(function () {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;

            fileContents = fileContents.substring(dataStart);
            self.uploadProcess(component, file, fileContents);
        });

        objFileReader.readAsDataURL(file);
    },

    uploadProcess: function (component, file, fileContents) {
        debugger;
        var startPosition = 0;
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
    uploadInChunk: function (component, file, fileContents, startPosition, endPosition, attachId) {
        debugger;
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.SaveFile");
        var filetype = 'application/pdf';
        action.setParams({
            "parentId": component.get("v.recordId"),
            "fileName": file.name,
            "base64Data": encodeURIComponent(getchunk),
            "contentType": filetype,
            "invoiceId":component.get("v.invoiceId")
        });
        action.setCallback(this, function (response) {
            var State = response.getState();
            if (State === "SUCCESS") {
                var data = response.getReturnValue();
                if (data != null) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: 'SUCCESS',
                        message: 'Details Saved Successfully !',
                        duration: ' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                } else if (state === "ERROR") {
                    var error = action.getError();
                    if (error) {
                        if (errors[0] && errors[0].message) {
                            alert(errors[0].message);
                        }
                    }
                }
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);

    },
})