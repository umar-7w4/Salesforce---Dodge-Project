/*
----------------------------------------------------------------------------
|  Class: RedirCtrl
|
|  Filename: RedirCtrl.cls
|
|  Author: Umar Mohammad
|
|  Description:
|     XXXXX
----------------------------------------------------------------------------
*/

public with sharing class RedirCtrl {

    public PageReference urlRedirection() {

        Map<String, String> params = ApexPages.currentPage().getParameters();
        String pageUrl = ApexPages.currentPage().getUrl();

        System.debug('PARAMS = ' + params);
        System.debug('URL = ' + pageUrl);

        XMR_App_Setting__mdt appSettings = XMR_App_Setting__mdt.getInstance('General');

        String url =
            appSettings.TeamsIntegrationLoginPage__c
                + params.get('uri')
                + '&state='
                + params.get('state');

        PageReference page = new PageReference(url);
        page.setRedirect(true);
        return page;
    }
}
