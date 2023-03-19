({
    MAX_FILE_SIZE: 4500000,
    CHUNK_SIZE: 750000,

    uploadHelper: function (component, event, FileuploadCompAuraid, folderName) {
        debugger;
        var fileInput = component.find(FileuploadCompAuraid).get("v.files");

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

            self.uploadProcess(component, file, fileContents, folderName);
        });

        objFileReader.readAsDataURL(file);
    },
    upload: function (component, file, fileContents) {
        debugger;
        var action1 = component.get("c.SaveFile");

        action1.setParams({
            parentId: component.get("v.LeadrecordId"),
            fileName: file.name,
            base64Data: encodeURIComponent(fileContents),
            contentType: file.type
        });

        action1.setCallback(this, function (a) {
            attachId = a.getReturnValue();
            console.log(attachId);
        });
    },

    uploadProcess: function (component, file, fileContents, folderName) {
        debugger;
        var startPosition = 0;

        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);

        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '', folderName);
    },
    uploadInChunk: function (component, file, fileContents, startPosition, endPosition, attachId, folderName) {
        debugger;
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.SaveFile");
        action.setParams({
            parentId: component.get("v.LeadrecordId"),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId,
            foldname:folderName
        });

        action.setCallback(this, function (response) {
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);

                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId, folderName);
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
    },
    setcookiesinjs: function (cname, cvalue, exdays) {
        debugger;
        const d = new Date();
        d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
        let tempexpires = "expires=" + d.toUTCString();
        document.cookie = cname + "=" + cvalue + ";" + tempexpires + ";path=/";
    },

    getcookiesinjs: function (cname) {
        debugger;
        let name = cname + "=";
        let decodedCookie = decodeURIComponent(document.cookie);
        let ca = decodedCookie.split(';');
        for (let i = 0; i < ca.length; i++) {
            let c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) == 0) {
                return c.substring(name.length, c.length);
            }
        }
        return "";
    },

    checkcookiesinJs: function (cname) {
        debugger;
        let username = getCookie(cname);
        if (username != "") {
            alert("Welcome again " + username);
        } else {
            username = prompt("Please enter your name:", "");
            if (username != "" && username != null) {
                setCookie("username", username, 365);
            }
        }
    }

})