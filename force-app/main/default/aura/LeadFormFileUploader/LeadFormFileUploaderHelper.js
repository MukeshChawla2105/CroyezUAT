({
    MAX_FILE_SIZE: 4500000,  
    CHUNK_SIZE: 750000,      
     
    uploadHelper: function(component, event) {
     debugger;
        var fileInput = component.find("fuploader").get("v.files");
 
        var file = fileInput[0];
         var self = this;
       
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
        
 
        var objFileReader = new FileReader();
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
             
            fileContents = fileContents.substring(dataStart);
            
            self.uploadProcess(component, file, fileContents);
         });
         
        objFileReader.readAsDataURL(file);
     },
     upload: function(component, file, fileContents) {
        var action1 = component.get("c.SaveFile"); 

        action1.setParams({
            parentId: component.get("v.leadId"),
            fileName: file.name,
            base64Data: encodeURIComponent(fileContents), 
            contentType: file.type
        });

        action1.setCallback(this, function(a) {
            attachId = a.getReturnValue();
            console.log(attachId);
        });
            
       /* $A.run(function() {
            $A.enqueueAction(action); 
        });*/
    },
     
    uploadProcess: function(component, file, fileContents) {
      debugger;  
        var startPosition = 0;
        
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        debugger;
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.SaveFile");
        action.setParams({
            parentId: component.get("v.leadId"),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId : attachId
        });
 
        action.setCallback(this, function(response) {
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
                    'duration':' 5000',
                    'key': 'info_alt',
                    'type': 'success',
                    'mode': 'pester'
                });
                toastEvent.fire(); 
                $A.get('e.force:refreshView').fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                
                    
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
   /* helperMethod : function(component, event, helper) {
        var folderList = [
            {
             "Name" : "Resume" ,
            "Lead__c" : "leadId",
            
            },
            {
                "Name" : "Experience Letter" ,
                "Lead__c" : "leadId",
               
             },
             {
                "Name" :"Job Offer Letter" ,
                "Lead__c" : "leadId",
               
             },
             {
                "Name" : "Graduation Degree" ,
                "Lead__c" : "leadId",
               
             },
             {
                "Name" : "Others" ,
                "Lead__c" : "leadId",
               
             }

            ];
            cmp.set("v.folders", folderList);
        }  */  
    
})