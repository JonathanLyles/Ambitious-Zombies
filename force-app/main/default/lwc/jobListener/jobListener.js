// c/jobListener.js
import { LightningElement } from 'lwc';
import { subscribe, onError } from 'lightning/empApi';
import jobService from 'c/jobService';

export default class JobListener extends LightningElement {
    channelName = '/event/New_Jobs_Event__e';
    subscription = {};

    connectedCallback() {
        console.log('jobListener connected to DOM');  
        this.handleSubscribe();
        this.registerErrorListener();
    }

    handleSubscribe() {
        const messageCallback = (response) => {
            console.log('Platform event received:', JSON.stringify(response, null, 2));
            const payload = response.data.payload;

            const result = {
                SearchId__c: payload.SearchId__c,
                JobList__c: payload.Payload__c
            };

            
            // Notify all subscribed components
            jobService.publishResults(result);
        };

        subscribe(this.channelName, -1, messageCallback)
            .then((response) => {
                this.subscription = response;
                console.log('Subscribed to', this.channelName);
            });
    }

    registerErrorListener() {
        onError((error) => console.error('EMP API error:', error));
    }
}
