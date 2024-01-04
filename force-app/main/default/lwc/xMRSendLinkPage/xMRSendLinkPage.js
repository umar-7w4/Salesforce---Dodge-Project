import {LightningElement, api, track} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import XMRealityLogo from '@salesforce/resourceUrl/XMRealityLogo';
import XMRRedWarningIcon from '@salesforce/resourceUrl/XMR_Red_Warning_Icon';
import sendEmailNotification from '@salesforce/apex/XMRealitySendLinkController.sendEmailNotification';
import sendSMSNotification from '@salesforce/apex/XMRealitySendLinkController.sendSMSNotification';

export default class XMRealitySendLinkPage extends LightningElement {

    @api recordId;
    @api userName;
    @api usrDetails;
    @api respwrp;
    XMRlogo = XMRealityLogo;
    XMRWarning = XMRRedWarningIcon;
    phoneNum;
    email;
    displaySmsMessage;
    displayEmailMessage;
    displaySms = false;
    displayEmail = false;
    isButtonDisabled;
    selectedTemplateId;
    linkDatetime;
    intervalTimer;
    @track isModalOpen = false;
    @track assignmentRecords;
    @track assignmentColumns = [{
        label: 'Name',
        fieldName: 'Name',
        type: 'text',
        wrapText: true,
        hideDefaultActions: true,
        initialWidth: 140
    }, {label: 'Subject', fieldName: 'Subject', type: 'text', wrapText: true, hideDefaultActions: true}];
    @track selectedRowValue;
    @track tokenExpiryTimeInSec;
    @track callerUserName;
    @track otherUserOnLink;
    TimeResult;

    @api
    connectedCallback() {
        this.phoneNum = this.respwrp.wrp.phoneNumber;
        this.email = this.respwrp.wrp.email;

        if (this.respwrp.emailTempLst !== undefined && this.respwrp.emailTempLst !== null && (this.respwrp.emailTempLst.length > 1 || this.respwrp.emailTempLst.length === 1)) {
            this.isButtonDisabled = false;
        } else {
            this.isButtonDisabled = true;
        }

        this.tokenExpiryTimeInSec = this.respwrp.wrp.xmrExpiration;
        this.callerUserName = this.respwrp.wrp.xmrCallerUserName;
        console.log('### SendLinkPage.connectedCallback() this.callerUserName = ' + this.callerUserName);
        console.log('### SendLinkPage.connectedCallback() userDetails.XMR_Username__c = ' + this.usrDetails.XMR_Username__c);
        this.otherUserOnLink = (this.callerUserName !== this.usrDetails.XMR_Username__c);
        this.linkDatetime = this.respwrp.wrp.xmrExpirationTime;
        console.log('linkDatetime = ', this.linkDatetime);
        this.logoutTimeLeft(this);
        this.handleLinkPollInterval();
    }

    handleLinkPollInterval() {
        console.log('Setting interval 60s');
        this.intervalTimer = window.setInterval(this.logoutTimeLeft, 60000, this);
    }

    logoutTimeLeft(self) {
        let now = new Date();
        let end = new Date(self.linkDatetime);
        let diff = (end - now);
        console.log('TIME: now=' + now + ' end=' + end + ' diff=' + diff)
        if (diff < 0) {
            window.clearInterval(self.intervalTimer);
            self.dispatchEvent(new CustomEvent('createlinkdisplay'));
        } else {
            let diffDatetime = new Date(diff);
            let hours = diffDatetime.getUTCHours();
            let minutes = diffDatetime.getUTCMinutes();
            self.TimeResult = '';
            if (hours > 0) {
                self.TimeResult += hours + ' hours ';
            }
            self.TimeResult += minutes + ' minutes';
            if (hours === 0 && minutes === 0) {
                self.TimeResult = 'less than a minute'
            }
        }
    }

    // @api
    // updateComponent() {
    //     console.log('updateComponent()');
    //     this.connectedCallback();
    // }

    getSelectedAssignmentName(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedRowValue = selectedRows[0].Id;
    }

    handleEmailChange(event) {
        this.email = event.target.value;
    }

    handlePhoneChange(event) {
        this.phoneNum = event.target.value;
    }


    handleSendSMS() {
        if (this.phoneNum !== undefined && this.phoneNum !== '' && this.phoneNum != null) {
            sendSMSNotification({
                recipientNumber: this.phoneNum,
                userDetails: this.usrDetails,
                token: this.respwrp.wrp.xmrCallId
            }).then(result => {
                if (result.isSuccess) {
                    this.displaySms = true;
                    this.displaySmsMessage = result.message;
                } else {
                    this.showToast('Error', result.message, 'error');
                }


            }).catch(error => {
                this.error = error;
                console.dir(this.error);
            })
        } else {
            this.showToast('Error', 'Please enter a recipient number!', 'error');
        }
    }

    validateSendEmail() {

        //enable here to see
        if (this.respwrp.emailTempLst !== undefined && this.respwrp.emailTempLst !== null && this.respwrp.emailTempLst.length > 1) {
            //display table
            this.openModal();
        } else if (this.respwrp.emailTempLst !== undefined && this.respwrp.emailTempLst !== null && this.respwrp.emailTempLst.length === 1) {
            this.selectedTemplateId = this.respwrp.emailTempLst[0].Id;
            this.handleSendEmail();
        }
    }

    handleSendEmail() {
        //need to perform validity check
        if (this.email !== undefined && this.email !== '' && this.email !== null) {
            sendEmailNotification({
                emailID: this.email,
                recId: this.recordId,
                emailTemplateId: this.selectedTemplateId
            }).then(result => {
                this.displayEmail = true;
                this.displayEmailMessage = result;
                this.selectedRowValue = null;
            }).catch(error => {
                this.error = error;
                console.dir(this.error);
            })
        } else {
            this.showToast('Error', 'Please enter a email id!', 'error');
        }
    }

    openModal() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }

    submitDetails() {
        if (this.selectedRowValue === undefined || this.selectedRowValue === null) {
            this.showToast('Error', 'Please select a template to send an email!', 'error');
        } else {
            this.isModalOpen = false;
            this.selectedTemplateId = this.selectedRowValue;
            this.handleSendEmail();
        }
    }

    handleNewCreateLink() {
        this.dispatchEvent(new CustomEvent('createlinkdisplay'));
    }

    showToast(titleVal, messageVal, toastType) {
        const evt = new ShowToastEvent({
            title: titleVal,
            message: messageVal,
            variant: toastType,
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

}