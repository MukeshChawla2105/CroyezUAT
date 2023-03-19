({
    uploadHelper: function (component, event, auraidtouploadDoc) {
        debugger;
        var fileInput = component.find(auraidtouploadDoc).get("v.files");

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

            var successString = self.uploadProcess(component, file, fileContents);
            return successString;
        });

        objFileReader.readAsDataURL(file);
    },

    uploadProcess: function (component, file, fileContents) {
        debugger;
        var startPosition = 0;

        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);

        var successString = this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
        return successString;
    },
    uploadInChunk: function (component, file, fileContents, startPosition, endPosition, attachId) {
        debugger;
        var FolderName = component.set("v.UploadLabel").replace('Upload ', '');
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.SaveFile");
        action.setParams({
            parentId: component.get("v.leadId"),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId,
            foldname:FolderName
        });

        action.setCallback(this, function (response) {
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);

                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "File has been saved successfully.",
                    'duration': ' 5000',
                    'key': 'info_alt',
                    'type': 'success',
                    'mode': 'pester'
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
                return 'SUCCESS ' + FolderName;
                //var dismissActionPanel = $A.get("e.force:closeQuickAction");
                //dismissActionPanel.fire();


            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    }
})