/* eslint-disable no-console */
/* eslint-disable no-undef */
import { LightningElement, api, wire, track } from 'lwc';
import jquery from '@salesforce/resourceUrl/symphonyjQueryPackage';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import symphonyGetFineTuneRecommendations from '@salesforce/apex/symphonyGetFineTuneRecommendations.symphonyGetFineTuneRecommendations';
import saveFineTuneRecommendations from '@salesforce/apex/symphonyGetFineTuneRecommendations.symphonySaveFineTuneRecommendations';

export default class SymphonyFineTuneRecommendation extends LightningElement {
    @api recordId;
    @track recId; 
    @track fineTuneData = {};
    @track error = '';
    @track PPOCheck = true;
    @track HMOCheck = true;
    @track POSCheck = true;
    @track HSACheck = true;
    @track ClientSeeCheck = true;
    @track theResult = '';

    @wire(symphonyGetFineTuneRecommendations, { recordId: '$recId'})
    wireFineTune({
        error,
        data
    }) {
        if(data) {
            this.fineTuneData = data;
            this.PPOCheck = data.E2E_Symphony_PPO_Medical_Plan__c;
            this.HMOCheck = data.E2E_Symphony_HMO_Medical_Plan__c;
            this.POSCheck = data.E2E_Symphony_POS_Medical_Plan__c;
            this.HSACheck = data.E2E_Symphony_HSA_Medical_Plan__c;
            this.ClientSeeCheck = data.E2E_Symphony_Data_sets_visible_to_client__c;
            this.initializeSlider(250,6200, this.fineTuneData.E2E_Symphony_Indvdl_In_Ntwk_Deduct_Min__c, 
                this.fineTuneData.E2E_Symphony_Indivdl_Ddtbl_InNet_Max__c, 'Individual deductible in network- ',
                'label.indDedInNetwork','div.slider-lowIndDedInNetwork','div.slider-highIndDedInNetwork',
                'span.amountIndDedInNetwork', 'div.slider-rangeIndDedInNetwork', '$','');
            this.initializeSlider(750,22500, this.fineTuneData.E2E_Symphony_Invdl_Out_Ntwk_Dtbl_Min__c, 
                this.fineTuneData.E2E_Symphony_Indvl_Out_Network_Ddct_Max__c, 'Individual deductible out of network- ',
                'label.indDedOutNetwork','div.slider-lowIndDedOutNetwork','div.slider-highIndDedOutNetwork',
                'span.amountIndDedOutNetwork', 'div.slider-rangeIndDedOutNetwork', '$','');
            this.initializeSlider(500,12400,this.fineTuneData.E2E_Sym_Family_In_Network_Deductible_Min__c, 
                this.fineTuneData.E2E_Sym_Family_In_Network_Deductible_Max__c, 'Family deductible in network- ',
                'label.famDedInNetwork','div.slider-lowFamDedInNetwork','div.slider-highFamDedInNetwork',
                'span.amountFamDedInNetwork', 'div.slider-rangeFamDedInNetwork', '$','');
            this.initializeSlider(1500,45000,this.fineTuneData.E2E_Sym_Fam_Out_Network_Deductible_Min__c, 
                this.fineTuneData.E2E_Sym_Fam_Out_Network_Deductible_Max__c, 'Family deductible out of network- ',
                'label.famDedOutNetwork','div.slider-lowFamDedOutNetwork','div.slider-highFamDedOutNetwork',
                'span.amountFamDedOutNetwork', 'div.slider-rangeFamDedOutNetwork', '$','');
            this.initializeSlider(2500,8150,this.fineTuneData.E2E_Symphony_Individual_Max_OoP_in_ntwrk__c, 
                this.fineTuneData.E2E_Symphony_Indvdl_Max_OoP_in_ntwrk_max__c, 'Individual Maximum Out-of-Pocket in network- ',
                'label.indMOOPInNetwork','div.slider-lowIndMOOPInNetwork','div.slider-highIndMOOPInNetwork',
                'span.amountIndMOOPInNetwork', 'div.slider-rangeIndMOOPInNetwork', '$','');
            this.initializeSlider(7500,24450,this.fineTuneData.E2E_Symphony_Indvdl_Max_OoP_ot_ntwrk_min__c, 
                this.fineTuneData.E2E_Symphony_Indvdl_Max_OoP_ot_ntwrk_max__c, 'Individual Maximum Out-of-Pocket out of network- ',
                'label.indMOOPOutNetwork','div.slider-lowIndMOOPOutNetwork','div.slider-highIndMOOPOutNetwork',
                'span.amountIndMOOPOutNetwork', 'div.slider-rangeIndMOOPOutNetwork', '$','');
            this.initializeSlider(5000,16300,this.fineTuneData.E2E_Symphony_Family_Max_Oo_in_ntwrk_min__c, 
                this.fineTuneData.E2E_Symphony_Family_Max_OoP_in_ntwrk_max__c, 'Family Maximum Out-of-Pocket in network- ',
                'label.famMOOPInNetwork','div.slider-lowFamMOOPInNetwork','div.slider-highFamMOOPInNetwork',
                'span.amountFamMOOPInNetwork', 'div.slider-rangeFamMOOPInNetwork', '$','');
            this.initializeSlider(15000,48900,this.fineTuneData.E2E_Symphony_Family_Max_OoP_ot_ntwrk_min__c, 
                this.fineTuneData.E2E_Symphony_Family_Max_OoP_ot_ntwrk_max__c, 'Family Maximum Out-of-Pocket out of network- ',
                'label.famMOOPOutNetwork','div.slider-lowFamMOOPOutNetwork','div.slider-highFamMOOPOutNetwork',
                'span.amountFamMOOPOutNetwork', 'div.slider-rangeFamMOOPOutNetwork', '$','');
            this.initializeSlider(0,40,this.fineTuneData.E2E_Sym_In_Network_Coinsurance_Minimum__c, 
                this.fineTuneData.E2E_Sym_In_Network_Coinsurance_Maximum__c, 'In network Coinsurance- ',
                'label.inNetworkCoinsurance','div.slider-lowInNetworkCoinsurance','div.slider-highInNetworkCoinsurance',
                'span.amountInNetworkCoinsurance', 'div.slider-rangeInNetworkCoinsurance', '','%');
            this.initializeSlider(30,50,this.fineTuneData.E2E_Sym_Out_Network_Coinsurance_Minimum__c, 
                this.fineTuneData.E2E_Sym_Out_Network_Coinsurance_Maximum__c, 'Out of network Coinsurance- ',
                'label.outNetworkCoinsurance','div.slider-lowOutNetworkCoinsurance','div.slider-highOutNetworkCoinsurance',
                'span.amountOutNetworkCoinsurance', 'div.slider-rangeOutNetworkCoinsurance', '','%');
            this.initializeSlider(0,20,this.fineTuneData.E2E_Symphony_Pharmacy_Tier_1_coinsur_min__c, 
                this.fineTuneData.E2E_Symphony_Pharmacy_Tier_1_coinsur_max__c, 'Pharmacy Teir 1 coinsurance- ',
                'label.pharmTier1Coinsurance','div.slider-lowPharmTier1Coinsurance','div.slider-highPharmTier1Coinsurance',
                'span.amountPharmTier1Coinsurance', 'div.slider-rangePharmTier1Coinsurance', '','%');
            this.initializeSlider(0,20,this.fineTuneData.E2E_Symphony_Pharmacy_Tier_2_coinsur_min__c, 
                this.fineTuneData.E2E_Symphony_Pharmacy_Tier_2_coinsur_max__c, 'Pharmacy Teir 2 coinsurance- ',
                'label.pharmTier2Coinsurance','div.slider-lowPharmTier2Coinsurance','div.slider-highPharmTier2Coinsurance',
                'span.amountPharmTier2Coinsurance', 'div.slider-rangePharmTier2Coinsurance', '','%');
            this.initializeSlider(0,20,this.fineTuneData.E2E_Symphony_Pharmacy_Tier_3_coinsur_min__c, 
                this.fineTuneData.E2E_Symphony_Pharmacy_Tier_3_coinsur_max__c, 'Pharmacy Teir 3 coinsurance- ',
                'label.pharmTier3Coinsurance','div.slider-lowPharmTier3Coinsurance','div.slider-highPharmTier3Coinsurance',
                'span.amountPharmTier3Coinsurance', 'div.slider-rangePharmTier3Coinsurance', '','%');
            this.initializeSlider(0,25,this.fineTuneData.E2E_Symphony_Pharmacy_Tier_4_Coinsur_min__c, 
                this.fineTuneData.E2E_Symphony_Pharmacy_Tier_4_coinsur_max__c, 'Pharmacy Teir 4 coinsurance- ',
                'label.pharmTier4Coinsurance','div.slider-lowPharmTier4Coinsurance','div.slider-highPharmTier4Coinsurance',
                'span.amountPharmTier4Coinsurance', 'div.slider-rangePharmTier4Coinsurance', '','%');
                    
            this.initializeSlider(10,15,this.fineTuneData.E2E_Symphony_Pharmacy_Tier_1_copay_min__c, 
                this.fineTuneData.E2E_Symphony_Pharmacy_Tier_1_copay_max2__c, 'Pharmacy Teir 1 copay- ',
                'label.pharmTier1Copay','div.slider-lowPharmPharmTier1Copay','div.slider-highPharmTier1Copay',
                'span.amountPharmTier1Copay', 'div.slider-rangePharmTier1Copay', '$','');
            this.initializeSlider(10,15,this.fineTuneData.E2E_Symphony_Pharmacy_Tier_2_copay_min__c, 
                this.fineTuneData.E2E_Symphony_Pharmacy_Tier_2_copay_max__c, 'Pharmacy Teir 2 copay- ',
                'label.pharmTier2Copay','div.slider-lowPharmTier2Copay','div.slider-highPharmTier2Copay',
                'span.amountPharmTier2Copay', 'div.slider-rangePharmTier2Copay', '$','');
            this.initializeSlider(40,50,this.fineTuneData.E2E_Symphony_Pharmacy_Tier_3_copay_min__c, 
                this.fineTuneData.E2E_Symphony_Pharmacy_Tier_3_copay_max__c, 'Pharmacy Teir 3 copay- ',
                'label.pharmTier3Copay','div.slider-lowPharmTier3Copay','div.slider-highPharmTier3Copay',
                'span.amountPharmTier3Copay', 'div.slider-rangePharmTier3Copay', '$','');
            this.initializeSlider(70,100,this.fineTuneData.E2E_Symphony_Pharmacy_Tier_4_copay_min__c, 
                this.fineTuneData.E2E_Symphony_Pharmacy_Tier_4_copay_max__c, 'Pharmacy Teir 4 copay- ',
                'label.pharmTier4Copay','div.slider-lowPharmTier4Copay','div.slider-highPharmTier4Copay',
                'span.amountPharmTier4Copay', 'div.slider-rangePharmTier4Copay', '$','');
                

        }
        else if (error) {
            this.error = error;
        }
    }


    renderedCallback() {
        Promise.all([
            loadScript(this, jquery + '/jQuery.js'),
            loadScript(this, jquery + '/jQueryUi.js'),
            loadStyle(this, jquery + '/jQuery-UI.css')
        ])
        .then(() => {
            this.recId = this.recordId;
            console.log('jquery loaded');
        })
        .catch(error => {
            console.log(error.message);
        })
    }

    saveRecord() {
        saveFineTuneRecommendations({ recordId : this.recId, PPOCheck : this.PPOCheck, HMOCheck : this.HMOCheck,
            POSCheck : this.POSCheck, HSACheck: this.HSACheck })
            .then(result => {
                console.log(result);
            })
            .catch(error => {
                console.log('error occured');
                console.log(JSON.stringify(error));
            })
    }

    initializeSlider(sliderLow, sliderHigh, valueLow, valueHigh, label, targetLabel, targetSliderLow,
        targetSliderHigh, targetInput, targetSlider, dollarSign, percentSigh) {
        const theSlider = this.template.querySelector(targetSlider);
        const theInput = this.template.querySelector(targetInput);
        const sliderHighDiv = this.template.querySelector(targetSliderHigh);
        const sliderLowDiv = this.template.querySelector(targetSliderLow);
        const theLabel = this.template.querySelector(targetLabel);

        $(theSlider).slider({
            range: true,
            min: sliderLow,
            max: sliderHigh,
            values: [ valueLow, valueHigh ],
            slide: function( event, ui ) {
              $(theInput).html( dollarSign + ui.values[ 0 ] + percentSigh + ' - ' + dollarSign + ui.values[ 1 ] + percentSigh);
            }
        });
        $(theLabel).html(label);    
        $(theInput).html( dollarSign + $(theSlider).slider( 'values', 0 ) + percentSigh +
            " - " + dollarSign + $(theSlider).slider( 'values', 1 ) + percentSigh);
        
        $(sliderHighDiv).html(dollarSign + sliderHigh + percentSigh);
        $(sliderLowDiv).html(dollarSign + sliderLow + percentSigh);
    }

    toggleHSA() {
        this.HSACheck = !this.HSACheck;
        // eslint-disable-next-line no-console
        console.log(this.HSACheck);
    }
    togglePPO() {
        this.PPOCheck = !this.PPOCheck;
    }
    togglePOS() {
        this.POSCheck = !this.POSCheck;
    }
    toggleHMO() {
        this.HMOCheck = !this.HMOCheck;
    }
}