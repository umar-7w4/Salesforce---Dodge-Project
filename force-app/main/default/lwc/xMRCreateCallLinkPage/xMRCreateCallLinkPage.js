import {LightningElement, api, track} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import XMRealityLogo from '@salesforce/resourceUrl/XMRealityLogo';
import logOutUserFromXMReality from '@salesforce/apex/XMRealityCreateLinkController.logOutUserFromXMReality';
import checkIfCallLinkIsActive from '@salesforce/apex/XMRealityCreateLinkController.checkIfCallLinkIsActive';
import createCallLink from '@salesforce/apex/XMRealityCreateLinkController.createCallLink';

export default class XMRealityCreateCallLinkPage extends LightningElement {

    @api recordId;
    @api userName;
    @api recipientName;
    @api usrDetails;
    XMRlogo = XMRealityLogo;
    @api isValidToken;
    linkTimeOut;
    isSpinner = true;
    metadataValue = '';

    handleRecipientChange(event) {
        this.recipientName = event.target.value;
    }

    // Need to pass event to Federation login page
    handleSignin() {
        this.dispatchEvent(new CustomEvent('signinopen', {}));
    }

    connectedCallback() {
        this.isSpinner = true;
        if (this.isValidToken) {
            checkIfCallLinkIsActive({recordId: this.recordId}).then(result => {
                if (result !== null && result !== undefined) {
                    this.linkTimeOut = result.timeoutHours;
                    this.recipientName = result.wrp.recipientName;
                    if (result.wrp.metadata !== undefined && result.wrp.metadata !== null) {
                        this.metadataValue = result.wrp.metadata;
                    }
                    if (result.isGeneric || (result.isGeneric === false && result.wrp.isActive === false)) {
                        // Second page
                    } else {
                        this.dispatchEvent(new CustomEvent('sendlinkdisplay', {detail: {resultwrap: JSON.stringify(result)}}));
                    }

                } else {
                    this.showToast('Error', 'Exceptipn: Please contact system admin!', 'error');
                }
            }).catch(error => {
                this.error = error;
                console.dir(this.error);
            })
        }
        this.isSpinner = false;
    }

    @api
    handleCallFromParent(isSignedIn) {
        this.isValidToken = isSignedIn;

        if (this.isValidToken) {
            this.connectedCallback();
        }
    }

    // @api
    // updateComponent() {
    //     console.log('updateComponent()');
    //     this.connectedCallback();
    // }

    handleCreateLink() {
        this.isSpinner = true;
        if (this.recipientName === undefined || this.recipientName === null || this.recipientName === '') {
            this.showToast('Error', 'Recipient Name is Mandatory! Please contact system admin.', 'error');
        } else {
            //createlink funtionality
            createCallLink({
                recordId: this.recordId,
                recipientName: this.recipientName,
                metadata: this.metadataValue,
                userDetails: this.usrDetails
            }).then(result => {
                if (result.apiStatus) {
                    this.isSpinner = false;
                    if (result.isGeneric) {
                        this.dispatchEvent(new CustomEvent('sendlinkdisplay', {detail: {resultwrap: JSON.stringify(result)}}));
                    } else if (!result.isGeneric) {
                        this.dispatchEvent(new CustomEvent('initiatecalllog', {detail: {resultwrap: JSON.stringify(result)}}));
                        this.dispatchEvent(new CustomEvent('sendlinkdisplay', {detail: {resultwrap: JSON.stringify(result)}}));
                    }
                } else {
                    alert('Unable to generate call link, Please contact system admin!');
                }


            }).catch(error => {
                this.error = error;
                console.dir(this.error);
            })

        }
        this.isSpinner = false;
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