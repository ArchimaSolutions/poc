/* eslint-disable no-undef */
import { LightningElement, api, wire } from 'lwc';
import jquery from '@salesforce/resourceUrl/symphonyjQueryPackage';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';

export default class SymphonyFineTuneRecommendation extends LightningElement {
    @api recordId;

    @wire(getRecord, {})
    fineTuneRecommendations;

    renderedCallback() {
        Promise.all([
            loadScript(this, jquery + '/jQuery.js'),
            loadScript(this, jquery + '/jQueryUi.js'),
            loadStyle(this, jquery + '/jQuery-UI.css')
        ])
        .then(() => {
            // eslint-disable-next-line no-console
            console.log('jquery loaded');
            this.initializeSlider();
        })
        .catch(error => {
            // eslint-disable-next-line no-console
            console.log(error.message);
        })
    }
    initializeSlider() {
        const theSlider = this.template.querySelector( 'div.slider-range' );
        const theInput = this.template.querySelector( 'input.amount' );
        //this.template.querySelector( 'div.slider-range' ).slider({
        $(theSlider).slider({
            range: true,
            min: 0,
            max: 500,
            values: [ 75, 300 ],
            slide: function( event, ui ) {
              $(theInput).val( '$' + ui.values[ 0 ] + ' - $' + ui.values[ 1 ] );
            }
          });
        $(theInput).val( '$' + $(theSlider).slider( 'values', 0 ) +
            " - $" + $(theSlider).slider( 'values', 1 ) );    
    }
}