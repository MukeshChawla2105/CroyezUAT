({
	handleSave: function(component, event, helper) {
        debugger;
        if (component.find("fuploader").get("v.files").length > 0) {
            var s = component.get("v.FilesUploaded");
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
    },
     
    handleFilesChange: function(component, event, helper) {
        debugger;
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
     
    handleCancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})