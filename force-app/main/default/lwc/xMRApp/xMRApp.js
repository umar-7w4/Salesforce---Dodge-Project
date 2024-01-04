import {LightningElement, api, track} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getUserAuthenticationDetails from '@salesforce/apex/XMRealityLoginHelper.getUserAuthenticationDetails';
import clearXMRCallLink from '@salesforce/apex/XMRealityLoginHelper.clearXMRCallLink';
import {NavigationMixin} from 'lightning/navigation';

export default class XMRealityApp extends LightningElement {

    @api recordId;
    @api usrDetails;
    error;
    username;
    displayCreateLinkPage;
    displaySendLinkPage;
    isValidToken;
    isSignedIn = false;
    @api respwrp;
    @api calllogdetail;


    connectedCallback() {
        getUserAuthenticationDetails().then(result => {
            if (result !== null && result !== undefined) {
                console.log('xMRApps.connectedCallback()', result);
                if (result.userdetails.XMR_Username__c != null) {
                    this.username = result.userdetails.XMR_Username__c;
                } else {
                    this.username = result.userdetails.Email;
                }
                this.usrDetails = result.userdetails;
                this.isValidToken = result.isValidToken;
                this.displayCreateLinkPage = true;
                this.displaySendLinkPage = false;

            } else {
                this.showToast('Error', 'Exception: Please contact system admin!', 'error');
            }

        }).catch(error => {
            this.error = error;
            console.dir(this.error);
        })
    }

    @api
    handleCallFromAuraComp(isSignedIn) {
        console.log('xMRApps.handleCallFromAuraComp()' + isSignedIn);
        this.isSignedIn = isSignedIn;
        this.connectedCallback();
        if (isSignedIn) {
            let comp = this.template.querySelector("c-x-M-R-Create-Call-Link-Page");
            console.log('create link com = ' + comp);
            if (comp !== null) {
                comp.handleCallFromParent(isSignedIn);
            }

            comp = this.template.querySelector("c-x-m-r-send-link-page");
            console.log('send link com = ' + comp);
            if (comp !== null) {
                comp.connectedCallback();
            }
        } else {
            let comp = this.template.querySelector("c-x-M-R-Create-Call-Link-Page");
            console.log('create link com = ' + comp);
            if (comp !== null) {
                comp.handleCallFromParent(isSignedIn);
            }
        }
    }

    // @api
    // updateChildComponent() {
    //     console.log('updateComponent()');
    //     let comp = this.template.querySelector("c-x-m-r-send-link-page");
    //     if (comp !== null) {
    //         comp.updateComponent();
    //     }
    // }

    showToast(titleVal, messageVal, toastType) {
        const evt = new ShowToastEvent({
            title: titleVal,
            message: messageVal,
            variant: toastType,
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    // This method needs to be called after logout from federationpage
    handleUserLogout() {
        this.isValidToken = false;
        this.displayCreateLinkPage = true;
        this.displaySendLinkPage = false;
    }

    // This method needs to be called after successfull login from federationpage
    handleUserSignin() {
        this.connectedCallback();
    }

    handleSendLink(event) {
        this.respwrp = JSON.parse(event.detail.resultwrap);
        this.displayCreateLinkPage = false;
        this.displaySendLinkPage = true;
        console.log('## onsendlinkdisplay: respwrp = ', this.respwrp);
    }

    handleCreateLink(event) {
        clearXMRCallLink({
            recID: this.recordId
        }).then(result => {
            if (result !== null && result !== undefined) {
                this.connectedCallback();
            } else {
                this.showToast('Error', 'Exception: Please contact system admin!', 'error');
            }

        }).catch(error => {
            this.error = error;
            console.dir(this.error);
        })

    }

    handlesigninopen(event) {
        this.dispatchEvent(new CustomEvent('signinopen', {}));
    }

    handleinitiatecalllog(event) {
        let respVal = JSON.parse(event.detail.resultwrap);
        respVal.wrp.recordId = this.recordId;
        this.calllogdetail = JSON.stringify(respVal.wrp);
        this.dispatchEvent(new CustomEvent('initiatecalllog', {detail: {calllogdetail: this.calllogdetail}}));
        //this.dispatchEvent(new CustomEvent('initiatecalllog',{detail: {resultwrap:JSON.stringify(event.detail.resultwrap)}}));
        //this.dispatchEvent(new CustomEvent('initiatecalllog',{}));
    }
}