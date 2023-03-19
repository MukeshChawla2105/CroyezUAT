({

    doInit: function (component, event, helper) {
        component.set("v.showSpinner",true);

        var DocumentUploadTypes = [];
        component.set("v.DocumentUploadTypelist", DocumentUploadTypes);
        var LeadId;
        const queryString = window.location.search;
        console.log(queryString);
        const urlParams = new URLSearchParams(queryString);
        if (urlParams.get('id') != null && urlParams.get('id') != undefined ) {
            LeadId = urlParams.get('id');
            console.log('LeadId =====> ', LeadId);
            var recid = component.get("v.LeadrecordId");
        }
        else{
            var recid = component.get("v.recordId");
        }
        
        debugger;
        localStorage.setItem("LeadRecIdfromurl", LeadId);
        localStorage.setItem("LeadRecIdfromVftoaura", recid);
        helper.getcookiesinjs("LeadRecIdfromurl");

        var action = component.get("c.LeadCreationCl");
        action.setParams({
            'LeadrecId': recid
        });
        action.setCallback(this, function (result) {
            var state = result.getState();
            if (state === "SUCCESS") {
                var resultValue = result.getReturnValue();
                component.set("v.leadRec", resultValue.LeadRecord);
                var recid = component.get("v.LeadrecordId");
                var LeadRecordIdFromPage = component.get("v.recordId");

                //component.set("v.truthy", false);
                //component.set("v.ShowUploadDocComp", true);
                component.set("v.GenderList", resultValue.MapofPickListbyValue.Gender);
                component.set("v.ProficiencyList", resultValue.MapofPickListbyValue.AllProficiencyList);
                component.set("v.ChildrenList", resultValue.MapofPickListbyValue.NumberofChildren);
                component.set("v.maritialStatusList", resultValue.MapofPickListbyValue.MaritialStatus);
                component.set("v.BooleanList", resultValue.MapofPickListbyValue.BooleanListForcmp);
                component.set("v.ExperienceList", resultValue.MapofPickListbyValue.WorkExperiences);
                
                if (resultValue.LeadSelfEducationDetails != null && resultValue.LeadSelfEducationDetails != undefined && resultValue.LeadSelfEducationDetails.length >0) {
                    component.set("v.SelfEducationDetails", resultValue.LeadSelfEducationDetails);
                }
                if (resultValue.LeadSelfWorkExperienceDetails != null && resultValue.LeadSelfWorkExperienceDetails != undefined &&  resultValue.LeadSelfWorkExperienceDetails.length > 0) {
                    component.set("v.SelfWorkExperienceRecords", resultValue.LeadSelfWorkExperienceDetails);
                }
                if (resultValue.LeadSpouseEducationDetails != null && resultValue.LeadSpouseEducationDetails != undefined && resultValue.LeadSpouseEducationDetails.length >0) {
                    component.set("v.SpouseEducationDetails", resultValue.LeadSpouseEducationDetails);
                }
                if (resultValue.LeadSpouseWorkExperienceDetails != null && resultValue.LeadSpouseWorkExperienceDetails != undefined  && resultValue.LeadSpouseWorkExperienceDetails.len) {
                    component.set("v.SpouseWorkExperienceRecords", resultValue.LeadSpouseWorkExperienceDetails);
                }
                //component.set("v.ExperienceList", resultValue);
                console.log(resultValue);

                /*for (let i = 0; i < resultValue.FolderConfigList.length; i++) {
                    let tempDocumentTypeupload = {};
                    tempDocumentTypeupload.DocumentLabel = 'Upload ' + resultValue.FolderConfigList[i];
                    tempDocumentTypeupload.DocumentAuraId = (resultValue.FolderConfigList[i]).replace(" ", "") + 'Uploader';
                    tempDocumentTypeupload.ChildDocAuraId = 'ChildCmp' + (resultValue.FolderConfigList[i]).replace(/ /g, "");
                    DocumentUploadTypes.push(tempDocumentTypeupload);

                }
                component.set("v.DocumentUploadTypelist", DocumentUploadTypes);*/



                if (resultValue.LeadRecord.IsLeadFormUpdated__c == true && recid != undefined) {
                   component.set("v.truthy", false);

                    if (resultValue.IsResumeUploaded == false || resultValue.IsExpLetterUploaded == false || resultValue.IsJobOfferLetterUploaded == false || resultValue.IsGraduationDegreeUploaded == false || resultValue.IsOtherUploaded == false) {
                       component.set("v.ShowUploadDocComp", true);

                        if (resultValue.IsResumeUploaded == true) {
                            component.set("v.ShowuploadResume", false);
                        } else if (resultValue.IsResumeUploaded == false) {
                            component.set("v.ShowuploadResume", true);
                        }
                        if (resultValue.IsExpLetterUploaded == true) {
                            component.set("v.ShowUploadExperienceLetter", false);
                        }
                        else if (resultValue.IsExpLetterUploaded == false) {
                            component.set("v.ShowUploadExperienceLetter", true);

                        }
                        if (resultValue.IsJobOfferLetterUploaded == true) {
                            component.set("v.ShowUploadJobOfferLetter", false);
                        } else if (resultValue.IsJobOfferLetterUploaded == false) {
                            component.set("v.ShowUploadJobOfferLetter", true);
                        }
                        if (resultValue.IsGraduationDegreeUploaded == true) {
                            component.set("v.ShowUploadGraduationDegree", false);
                        } else if (resultValue.IsGraduationDegreeUploaded == false) {
                            component.set("v.ShowUploadGraduationDegree", true);
                        }
                        if (resultValue.IsOtherUploaded == true) {
                            component.set("v.ShowUploadOthers", false);
                        } else if (resultValue.IsOtherUploaded == false) {
                            component.set("v.ShowUploadOthers", true);
                        }
                    }
                    else if (resultValue.IsResumeUploaded == true && resultValue.IsExpLetterUploaded == true && resultValue.IsJobOfferLetterUploaded == true && resultValue.IsGraduationDegreeUploaded == true && resultValue.IsOtherUploaded == true) {
                        component.set("v.ShowUploadDocComp", false);
                        alert('You have Already Updated Your Profile and Submitted all Documents!!')
                        helper.setcookiesinjs("LeadRecIdfromurl", LeadId, 1);
                        var CroyezWebsiteUrl = 'https://croyezimmigration.com/';
                        window.open(CroyezWebsiteUrl, "_self");
                    }


                }
                else if (resultValue.LeadRecord.IsLeadFormUpdated__c == false) {
                    component.set("v.truthy", true);
                }
                else if ((resultValue.LeadRecord.IsLeadFormUpdated__c == false || resultValue.LeadRecord.IsLeadFormUpdated__c == true) && recid == undefined  && LeadRecordIdFromPage != undefined && LeadRecordIdFromPage != null) {
                    component.set("v.truthy", true);
                }
                component.set("v.showSpinner",false);
            }
        });
        $A.enqueueAction(action);
    },
    changehandler: function (component, event, helper) {
        debugger;
        var selectpicklist = component.find('visa').get('v.value');
        component.set("v.pickvalue", selectpicklist);
    },

    MaritialStatusOnchange : function (component, event, helper) {
        debugger;
        var leadRecForJs = component.get("v.leadRec");
        if (leadRecForJs.Maritial_Status__c == 'Married') {
            component.set("v.ShowFillFamilyComposition", true);
            component.set("v.ShowFillOtherDetails", true);
            component.set("v.rownumber", '10');
            
        }
        else if (leadRecForJs.Maritial_Status__c == 'Unmarried') {
            component.set("v.ShowFillFamilyComposition", false);
            component.set("v.ShowFillOtherDetails", true);
            
            component.set("v.rownumber", '6');
            
        }
    },
    CreateLead1: function (component, event, helper) {
        debugger;
        component.set("v.showSpinner",true);
        var action = component.get('c.updateLead');
        var leadEducationrecords = component.get("v.SelfEducationDetails");
        var leadWorkExperiencerecords = component.get("v.SelfWorkExperienceRecords");
        var SpouseEducationrecords = component.get("v.SpouseEducationDetails");
        var SpouseWorkExperiencerecords = component.get("v.SpouseWorkExperienceRecords");

        
        var leadr = component.get("v.leadRec");
        var leadrecfromUrl = component.get("v.LeadrecordId");
        var recid;
        if (leadrecfromUrl != undefined) {
            recid = leadrecfromUrl
        }else {
            recid = component.get("v.recordId");
        }

        action.setParams({
            'leadId1': recid,
            'ledRec': leadr,
            'LeadEducationDetails': leadEducationrecords,
            'LeadWorkExperience': leadWorkExperiencerecords,
            'SpouseEducationDetails': SpouseEducationrecords,
            'SpouseWorkExperience': SpouseWorkExperiencerecords

        });
        action.setCallback(this, function (result) {
            var state = result.getState();
            if (state === "SUCCESS") {

                var data = result.getReturnValue();
                //component.set("v.leadId", data.Id);
                //alert("Success")

                alert('Your Details have been submitted successfully!!!, Thank you');
                component.set("v.truthy", false);
                component.set("v.ShowUploadDocComp", true);
                component.set("v.ShowuploadResume", true);
                component.set("v.ShowUploadExperienceLetter", true);
                component.set("v.ShowUploadJobOfferLetter", true);
                component.set("v.ShowUploadGraduationDegree", true);
                component.set("v.ShowUploadOthers", true);
                component.set("v.showSpinner",false);

            } else {
                alert("ERROR");
            }

        });
        $A.enqueueAction(action);

    },
    /*handleEvent : function (component, event, helper)  {
        debugger;
        var response = event.getParam("eventResponse"); 
        var tempFilenames = component.get("v.fileNameList"); 
        tempFilenames.push(response.Docfilename);
        component.set("v.fileNameList", tempFilenames);

        var tempChildCompDetail = component.get("v.ChildCompDetaillist");
        tempChildCompDetail.push(response);
        component.set("v.ChildCompDetaillist", tempChildCompDetail);
        
        
    },*/

    Clearform: function (component, event, helper) {
        debugger;

    },

    handleSave: function (component, event, helper) {
        debugger;
        component.set("v.disableUploadSave", true);
        /*var AllfilesName = component.get("v.fileNameList");
        var AllChildComDetailsList = component.get("v.ChildCompDetaillist");
        if (AllChildComDetailsList.length >0) {
            
            var successMessages = [];

            for (let i= 0; i < AllChildComDetailsList.length; i++) {
                var childcomauraidForJs = AllChildComDetailsList[i].DocChildcmpauraidname;
                var childComponent = component.find(childcomauraidForJs);
                var message = childComponent.childMessageMethod();
                
            }
            
        }
        else{
            alert('Please Select a Valid File');
            return;
        }*/


        if (component.find("Resumeuploader").get("v.files") != null) {
            if (component.find("Resumeuploader").get("v.files").length > 0) {
                //var s = component.get("v.FilesUploaded");
                helper.uploadHelper(component, event, 'Resumeuploader', 'Resume');
            }

        }

        //Resume;Experience Letter;Job Offer Letter;Graduation Degree;Others


        if (component.find("ExpLetuploader").get("v.files") != null) {
            if (component.find("ExpLetuploader").get("v.files").length > 0) {
                //var s1 = component.get("v.FilesUploaded1");
                helper.uploadHelper(component, event, 'ExpLetuploader', 'Experience Letter');
            }

        }
        if (component.find("JobOffLetteruploader").get("v.files") != null) {
            if (component.find("JobOffLetteruploader").get("v.files").length > 0) {
                //var s2 = component.get("v.FilesUploaded2");
                helper.uploadHelper(component, event, 'JobOffLetteruploader', 'Job Offer Letter');
            }

        }

        if (component.find("GradDeguploader").get("v.files") != null) {
            if (component.find("GradDeguploader").get("v.files").length > 0) {
                //var s3 = component.get("v.FilesUploaded3");
                helper.uploadHelper(component, event, 'GradDeguploader', 'Graduation Degree');
            }

        }
        if (component.find("Othersuploader").get("v.files") != null) {
            if (component.find("Othersuploader").get("v.files").length > 0) {
                //var s4 = component.get("v.FilesUploaded4");
                helper.uploadHelper(component, event, 'Othersuploader', 'Others');
            }

        }
        else {
            alert('Please Select a Valid File');
            return;
        }
        alert('Your documents have been submitted successfully!');
        //var CroyezWebsiteUrl = 'https://croyezimmigration.com/';
        //window.open(CroyezWebsiteUrl, "_self");

    },


    ResumehandleFilesChange: function (component, event, helper) {
        debugger;
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },

    ExpLethandleFilesChange: function (component, event, helper) {
        debugger;
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName1", fileName);
    },
    JobOffLethandleFilesChange: function (component, event, helper) {
        debugger;
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName2", fileName);
    },
    GradDegreehandleFilesChange: function (component, event, helper) {
        debugger;
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName3", fileName);
    },
    OthershandleFilesChange: function (component, event, helper) {
        debugger;
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName4", fileName);
    },
    handleCancel: function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }

})