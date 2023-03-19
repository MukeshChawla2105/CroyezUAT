import { LightningElement,track,wire,api} from 'lwc';
import getParentFolders from '@salesforce/apex/DMSConfigController.getParentFolder'
import getFolders from '@salesforce/apex/DMSConfigController.getFolders'
import uploadFile from '@salesforce/apex/DMSConfigController.uploadFile'
import createSFFolder from '@salesforce/apex/DMSConfigController.createFolder'
import updateFolderStatus from '@salesforce/apex/DMSConfigController.updateFolderStatus'
import getSFFiles from '@salesforce/apex/DMSConfigController.getFiles'
import deleteSFFile from '@salesforce/apex/DMSConfigController.deleteFile'
import deleteSFFolder from '@salesforce/apex/DMSConfigController.deleteFolder'
import { refreshApex } from '@salesforce/apex';

import {NavigationMixin} from 'lightning/navigation'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DmsDocViewer extends NavigationMixin(LightningElement)  {
    @api recordId;
    @track isLoading;
    @track path = [{name:"Home",folders:[]}]
    @track selectedFolder;
    @track fileData;

    @track wiredResp;

    @wire(getParentFolders,{recordId:'$recordId'})
    wiredResult(result){
        if(result){
            this.wiredResp = result;
            if(result.data){
                debugger;

                let folders = [];
                result.data.forEach(folder=>{
                    let obj = {...folder};
                    obj.active = false;
                    obj.style="";
                    folders.push(obj);
                })

                this.path[0].folders = folders;
                this.path[0].index = 0;
                this.selectedFolder = this.path[0];
                console.log('ParentFolders----',this.path);
                this.isHomeActive = true;
            }
        }
    }

    clearCache(){
        this.isHomeActive = true;
        this.folderDeletionDisable = true;
        this.showFileCreation = false;
        this.disableFileCreation = false;
        this.isFileUploading = false;
        this.fileDeletionDisable = true;
        this.showFolderCreation = false;
        this.disableCreate = true;

        this.selectedFolder = null;
        this.path =  [{name:"Home",folders:[]}];
    }



    getFiles(){
        let folderId = this.selectedFolder.folderId;
        getSFFiles({folderId}).then(result=>{
            console.log('Files fetched-----',result);

            let filesList = Object.keys(result).map(item=>({
                "label":result[item],
                "value": item,
                "url":`/sfc/servlet.shepherd/document/download/${item}`,
                "style":'',
                "active":false
            }))

            this.selectedFolder.files = filesList;
        }).catch(error=>{
            console.log('Error to fetch files',error);
        })   
    }

    getFolders(){
        debugger;
        let lastIndex = this.path.length-1;
        if(lastIndex!=0){
            getFolders({parentFId:this.path[lastIndex].folderId}).then(result=>{
                console.log('Sub Folders-----',result);

                let folders = [];
                result.forEach(folder=>{
                    let obj = {...folder};
                    obj.active = false;
                    obj.style="";
                    folders.push(obj);
                })
                this.path[lastIndex].index = lastIndex;
                this.path[lastIndex].folders = folders;
                this.selectedFolder = this.path[lastIndex];

                console.log('Path----',this.path);
                this.getFiles();
            }).catch(error=>{
                console.log("Error to get sub Folders---",error);
            })
        }
    }
    

    
    @track isHomeActive = true;

    pathClicked(event){
        debugger;
        let rIndex = 0;
        let pathIndex = parseInt(event.currentTarget.dataset.index);

        rIndex = pathIndex;
        pathIndex = pathIndex==0?pathIndex+1:pathIndex;

        if(pathIndex!=this.path.length-1 || rIndex==0){ 
            
            this.fileDeletionDisable = true;
            this.folderDeletionDisable = true;
            this.isHomeActive = rIndex==0;
            pathIndex = rIndex!=0?pathIndex+1:pathIndex;

            this.path = this.path.slice(0,pathIndex);
            this.selectedFolder = this.path[rIndex];
            this.getFolders();
        }
    }


    @track folderDeletionDisable = true;

  

    onFolderSingleClick(event){
        let id = event.currentTarget.dataset.id;

        if(this.path.length!=1){
            this.selectedFolder.folders.forEach(folder=>{
                folder.active = folder.Id == id;
                folder.style = folder.active?'color:blue':'';
                if(folder.active){
                    this.folderDeletionDisable = false;
                }
            })
        }
    }

    folderClicked(event){
        debugger;

        let id = event.currentTarget.dataset.id;
        let doc = this.selectedFolder.folders.find(item=>item.Id==id);

        this.fileDeletionDisable = true;

        getFolders({parentFId:id}).then(result=>{
            console.log('Sub Folders-----',result);
            if(result){

                this.path.push({name:doc.Name,folders:result,index:this.path.length,folderId:id})
                this.selectedFolder = this.path[this.path.length-1];

                this.isHomeActive = this.path.length==1;

                if(!this.isHomeActive){
                    this.getFiles();
                }
                console.log('Path---',this.path);
            }
        }).catch(error=>{
            console.log("Error to get sub Folders---",error);
        })       
    }


    @track showFileCreation = false;
    showFileCreationHandler(){
        this.showFileCreation = true;
    }

    

    closeFileCreation(){
        this.showFileCreation = false;
    }


    @track disableFileCreation = true;

    fileSelectedHandler(event){
        let file = event.target.files[0];
        var reader = new FileReader()
    
        this.fileData = {};

        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64,
                'recordId': this.selectedFolder.folderId
            }
            console.log(this.fileData)
            this.disableFileCreation = false;
        }
        reader.readAsDataURL(file)

    }


   

    @track isFileUploading = false;
    createFileSP(){
        const {base64, filename, recordId} = this.fileData
        this.isFileUploading = true;
        uploadFile({ base64, filename, recordId }).then(result=>{
            this.fileData = null
            let title = `${filename} uploaded successfully!!`;
            this.isFileUploading = false;
            this.showNotification('Success',title,'success');
            this.showFileCreation = false;
            this.getFolders();
        })
    }


    showNotification(title,message,variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    onFileDBClicked(event){
        console.log(event.currentTarget.dataset.id)
        this[NavigationMixin.Navigate]({ 
            type:'standard__namedPage',
            attributes:{ 
                pageName:'filePreview'
            },
            state:{ 
                selectedRecordId: event.currentTarget.dataset.id
            }
        })
    }

    @track fileDeletionDisable = true;
    onFileSingleClick(event){
        let fileId = event.currentTarget.dataset.id;
        this.selectedFolder.files.forEach(file=>{
            file.active = file.value == fileId;
            file.style = file.active?'color:blue':'';
            if(file.active){
                this.fileDeletionDisable = false;
            }
        })
    }


   
    @track showFolderCreation = false;
    showFolderCreationPopup(){
        this.showFolderCreation = true;
    }

    closeFolderCreation(){
        this.showFolderCreation = false;
        this.folderName = '';
    }

    @track disableCreate = true;
    @track folderName = '';
    inputHandler(event){
        this.folderName = event.target.value;
        if(!this.folderName || this.folderName.length==0){
            this.disableCreate = true;
        }else{
            this.disableCreate = false;
        }
    }

    createFolder(){
        if(!this.folderName || this.folderName.length==0){
            this.showNotification('Failed','Please enter the folder name','error');
            return;
        }

        this.isFileUploading = true;

        createSFFolder({parentFId:this.selectedFolder.folderId,folderName:this.folderName}).then(result=>{
            if(result=='Success'){
                this.isFileUploading = false;
                this.folderName = '';
                this.showFolderCreation = false;
                this.showNotification('Success',`${this.folderName} folder created!`,'success');
                this.getFolders();   
            }
        }).catch(error=>{
            console.log('Error to create folder---',error);
        })
    }



    deleteFiles(){
        debugger;
        let fileId = this.selectedFolder.files.find(item=>item.active).value;

        console.log('FileId',fileId);
        this.isLoading = true;
        deleteSFFile({fileId}).then(result=>{   
            console.log('File deletion result---',result);
            this.fileDeletionDisable = true;
            this.isLoading = false;
            this.showNotification('Success','File deleted Succesfully!','success');
            this.getFolders();
        }).catch(error=>{
            console.log('Error to delete the file---',error);
            this.showNotification('Error',error,'error');
        })
    }


    approveFile(){
        let folderId = this.selectedFolder.folderId;
        
        this.isLoading = true;

        updateFolderStatus({id:folderId,status:'Approved'}).then(result=>{
            if(result=='Success'){
                this.isLoading = false;
                this.showNotification('Success','File approved successfully','success');

                this.clearCache();
                refreshApex(this.wiredResp);
            }
        });

        console.log('Selected Folder---',this.selectedFolder);
    }

    rejectFile(){
        let folderId = this.selectedFolder.folderId;
        
        this.isLoading = true;

        updateFolderStatus({id:folderId,status:'Rejected'}).then(result=>{
            if(result=='Success'){
                this.isLoading = false;
                this.showNotification('Success','File rejected successfully','success');
                this.clearCache();
                refreshApex(this.wiredResp);
            }
        });

        console.log('Selected Folder---',this.selectedFolder);
    }

    deleteFolders(){
        debugger;
        let folderId = this.selectedFolder.folders.find(item=>item.active).Id;
        this.isLoading = true;
        deleteSFFolder({folderId}).then(result=>{   
            console.log('Folder deletion result---',result);
            this.folderDeletionDisable = true;
            this.isLoading = false;
            this.showNotification('Success','Folder deleted Succesfully!','success');
            this.getFolders();
        }).catch(error=>{
            console.log('Error to delete the folder---',error);
            this.showNotification('Error',error,'error');
        })
    }
}