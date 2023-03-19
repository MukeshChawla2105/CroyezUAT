({
    handleFilesChange: function (component, event, helper) {
        debugger;
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);

        var tempObjecttoPassvalue = {};
        tempObjecttoPassvalue.Docfilename = fileName;
        tempObjecttoPassvalue.docAuraIdName = component.get("v.UploadAuraId");
        tempObjecttoPassvalue.DocChildcmpauraidname = component.get("v.childcmpauraId");


        var event = component.getEvent("cmpEvent");

        //set the response value inside eventResponse of componentEvent attribute   
        event.setParams({
            "eventResponse": tempObjecttoPassvalue
        });

        //fire the event    
        event.fire();
    },
    getMessage: function (component, event) {
        //get method paramaters
        var auraidtouploadDoc = component.get("v.UploadAuraId");
        if (component.find(auraidtouploadDoc).get("v.files") != null) {
            if (component.find("auraidtouploadDoc").get("v.files").length > 0) {
                //var s = component.get("v.FilesUploaded");
                var successString = helper.uploadHelper(component, event, auraidtouploadDoc);
                var params = event.getParam('arguments');
                if (params) {
                    var message = params.message;
                    console.log("message: " + message);
                    return message;
                }
            }

        }

    }
})