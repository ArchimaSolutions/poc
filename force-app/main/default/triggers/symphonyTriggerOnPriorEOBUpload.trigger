trigger symphonyTriggerOnPriorEOBUpload on ContentDocumentLink (before insert) {
    //This needs to be 100% rewritten to only run on Symphony opportunities and add error checking and better bulk
    //This should NOT BE IN THE TRIGGER quick Demo code
    system.debug('I am here');
    Boolean isCensus = false;
    List<ContentDocumentLink> cdls = ( Trigger.new == null ? Trigger.old : Trigger.new );
    Set<Id> parentIds = new Set<Id>();
    List<Census_Reimagine_POC__c> bulkAdd = new List<Census_Reimagine_POC__c>();
    List<Prior_EOB_Symphony__c> bulkAddPriorEOB = new List<Prior_EOB_Symphony__c>();
    for (ContentDocumentLink cdl: cdls) {
        //Only add Ids of opportunitites 
        system.debug(cdl.LinkedEntityId);
        if(String.valueOf(cdl.LinkedEntityId).startsWith('001')) {
            parentIds.add( cdl.LinkedEntityId);
            //Get document record
            ContentDocument getDocRecord = [SELECT Id, Title FROM ContentDocument Where Id = :cdl.ContentDocumentId];
            //Opportunity getOpp = [SELECT Id, Name FROM Opportunity WHERE Id = :cdl.LinkedEntityId];
            Account getAcc = [SELECT Id, Name FROM Account WHERE Id = :cdl.LinkedEntityId];
            if(getDocRecord.Title == 'Census') {
                isCensus = true;
                Census_Reimagine_POC__c newCensusRecord = new Census_Reimagine_POC__c();
                newCensusRecord.Name = getAcc.Name;
                newCensusRecord.Current_As_Of__c = Date.Today();
                newCensusRecord.Average_age_of_Employees__c = 32;
                newCensusRecord.Employee_active__c = 145;

                //newCensusRecord.Opportunity__c = getOpp.Id;
                newCensusRecord.Account__c = getAcc.Id;
                bulkAdd.add(newCensusRecord);
            } else {
                Prior_EOB_Symphony__c newPriorEOB = new Prior_EOB_Symphony__c(
                    Name = getAcc.Name, AVG_PREM_PMPM__c=1000.00, Current_Family_Deductible_In_Network__c=2500.00,
                    Current_Family_Deductible_OON__c=5000.00, Current_Individual_Deductible_In_Network__c=1000.00,
                    Current_Individual_Deductible_OON__c=3500.00, Current_Coinsurance_INN__c=80,
                    Current_OOP_max_Family_INN__c=10000.00, Current_OOP_max_Family_OON__c=25000.00,
                    Current_OOP_max_Individual_INN__c=2250.00, Current_OOP_max_Individual_OON__c=4000.00,
                    Current_premium_PMPM_Family_INN__c=750.99, Current_premium_PMPM_Family_OON__c=1400.00,
                    Current_premium_PMPM_Individual_IN__c=3450.00, Current_premium_PMPM_Individual_OON__c=2039.99,
                    Account__c=getAcc.Id, Current_Coinsurance_OON__c=20
                );
                bulkAddPriorEOB.add(newPriorEOB); 
            }

        }
    }
    insert bulkAdd;
    insert bulkAddPriorEOB;
    if(isCensus) {
        Census_Member_Reimagine_POC__c t1 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('3/21/1983'),Contract_Type__c='3',Gender__c='F');
        insert t1;
        Census_Member_Reimagine_POC__c t2 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('7/24/1959'),Contract_Type__c='1',Gender__c='F');
        insert t2;
        Census_Member_Reimagine_POC__c t3 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('1/16/1959'),Contract_Type__c='1',Gender__c='F');
        insert t3;
        Census_Member_Reimagine_POC__c t4 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('8/18/1963'),Contract_Type__c='9',Gender__c='F');
        insert t4;
        Census_Member_Reimagine_POC__c t5 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('7/23/1984'),Contract_Type__c='9',Gender__c='F');
        insert t5;
        Census_Member_Reimagine_POC__c t6 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('4/29/1982'),Contract_Type__c='9',Gender__c='F');
        insert t6;
        Census_Member_Reimagine_POC__c t7 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('6/27/1948'),Contract_Type__c='2',Gender__c='M');
        insert t7;
        Census_Member_Reimagine_POC__c t8 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('5/31/1952'),Contract_Type__c='2',Gender__c='M');
        insert t8;
        Census_Member_Reimagine_POC__c t9 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('8/3/1947'),Contract_Type__c='2',Gender__c='M');
        insert t9;
        Census_Member_Reimagine_POC__c t10 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('11/18/1966'),Contract_Type__c='2',Gender__c='F');
        insert t10;
        Census_Member_Reimagine_POC__c t11 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('7/1/1975'),Contract_Type__c='3',Gender__c='M');
        insert t11;
        Census_Member_Reimagine_POC__c t12 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('5/10/1968'),Contract_Type__c='3',Gender__c='F');
        insert t12;
        Census_Member_Reimagine_POC__c t13 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('5/3/1962'),Contract_Type__c='3',Gender__c='M');
        insert t13;
        Census_Member_Reimagine_POC__c t14 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('9/2/1965'),Contract_Type__c='3',Gender__c='M');
        insert t14;
        Census_Member_Reimagine_POC__c t15 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('7/1/1982'),Contract_Type__c='3',Gender__c='F');
        insert t15;
        Census_Member_Reimagine_POC__c t16 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('12/7/1980'),Contract_Type__c='3',Gender__c='F');
        insert t16;
        Census_Member_Reimagine_POC__c t17 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('6/13/1983'),Contract_Type__c='3',Gender__c='F');
        insert t17;
        Census_Member_Reimagine_POC__c t18 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('10/21/1959'),Contract_Type__c='1',Gender__c='F');
        insert t18;
        Census_Member_Reimagine_POC__c t19 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('11/13/1962'),Contract_Type__c='1',Gender__c='F');
        insert t19;
        Census_Member_Reimagine_POC__c t20 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('9/24/1959'),Contract_Type__c='1',Gender__c='F');
        insert t20;
        Census_Member_Reimagine_POC__c t21 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('11/26/1958'),Contract_Type__c='1',Gender__c='F');
        insert t21;
        Census_Member_Reimagine_POC__c t22 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('3/22/1951'),Contract_Type__c='1',Gender__c='F');
        insert t22;
        Census_Member_Reimagine_POC__c t23 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('1/30/1962'),Contract_Type__c='1',Gender__c='F');
        insert t23;
        Census_Member_Reimagine_POC__c t24 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('6/14/1972'),Contract_Type__c='1',Gender__c='F');
        insert t24;
        Census_Member_Reimagine_POC__c t25 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('2/10/1955'),Contract_Type__c='1',Gender__c='F');
        insert t25;
        Census_Member_Reimagine_POC__c t26 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('8/29/1978'),Contract_Type__c='1',Gender__c='F');
            insert t26;
            Census_Member_Reimagine_POC__c t27 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('7/22/1975'),Contract_Type__c='1',Gender__c='F');
            insert t27;
            Census_Member_Reimagine_POC__c t28 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('10/19/1986'),Contract_Type__c='1',Gender__c='F');
            insert t28;
            Census_Member_Reimagine_POC__c t29 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('10/12/1978'),Contract_Type__c='1',Gender__c='F');
            insert t29;
            Census_Member_Reimagine_POC__c t30 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('12/24/1992'),Contract_Type__c='1',Gender__c='F');
            insert t30;
            Census_Member_Reimagine_POC__c t31 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('9/8/1959'),Contract_Type__c='1',Gender__c='F');
            insert t31;
            Census_Member_Reimagine_POC__c t32 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('2/4/1957'),Contract_Type__c='1',Gender__c='F');
            insert t32;
            Census_Member_Reimagine_POC__c t33 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('5/20/1960'),Contract_Type__c='1',Gender__c='F');
            insert t33;
            Census_Member_Reimagine_POC__c t34 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('9/27/1986'),Contract_Type__c='1',Gender__c='F');
            insert t34;
            Census_Member_Reimagine_POC__c t35 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('1/19/1982'),Contract_Type__c='1',Gender__c='F');
            insert t35;
            Census_Member_Reimagine_POC__c t36 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('12/5/1969'),Contract_Type__c='1',Gender__c='F');
            insert t36;
            Census_Member_Reimagine_POC__c t37 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('6/2/1978'),Contract_Type__c='1',Gender__c='F');
            insert t37;
            Census_Member_Reimagine_POC__c t38 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('10/29/1980'),Contract_Type__c='1',Gender__c='F');
            insert t38;
            Census_Member_Reimagine_POC__c t39 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('10/2/1991'),Contract_Type__c='1',Gender__c='F');
            insert t39;
            Census_Member_Reimagine_POC__c t40 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('4/1/1978'),Contract_Type__c='1',Gender__c='F');
            insert t40;
            Census_Member_Reimagine_POC__c t41 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('5/31/1982'),Contract_Type__c='1',Gender__c='F');
            insert t41;
            Census_Member_Reimagine_POC__c t42 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('2/1/1954'),Contract_Type__c='1',Gender__c='F');
            insert t42;
            Census_Member_Reimagine_POC__c t43 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('5/9/1982'),Contract_Type__c='1',Gender__c='M');
            insert t43;
            Census_Member_Reimagine_POC__c t44 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('5/27/1959'),Contract_Type__c='1',Gender__c='F');
            insert t44;
            Census_Member_Reimagine_POC__c t45 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('12/30/1958'),Contract_Type__c='1',Gender__c='F');
            insert t45;
            Census_Member_Reimagine_POC__c t46 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('12/13/1977'),Contract_Type__c='1',Gender__c='F');
            insert t46;
            Census_Member_Reimagine_POC__c t47 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('8/30/1958'),Contract_Type__c='1',Gender__c='F');
            insert t47;
            Census_Member_Reimagine_POC__c t48 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('12/17/1952'),Contract_Type__c='1',Gender__c='F');
            insert t48;
        Census_Member_Reimagine_POC__c t49 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('10/30/1961'),Contract_Type__c='1',Gender__c='F');
        insert t49;
        Census_Member_Reimagine_POC__c t50 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('9/25/1985'),Contract_Type__c='1',Gender__c='F');
        insert t50;
        Census_Member_Reimagine_POC__c t51 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('6/27/1971'),Contract_Type__c='1',Gender__c='F');
        insert t51;
        Census_Member_Reimagine_POC__c t52 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('6/8/1967'),Contract_Type__c='1',Gender__c='F');
        insert t52;
        Census_Member_Reimagine_POC__c t53 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('2/6/1954'),Contract_Type__c='1',Gender__c='F');
        insert t53;
        Census_Member_Reimagine_POC__c t54 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('10/14/1965'),Contract_Type__c='1',Gender__c='F');
        insert t54;
        Census_Member_Reimagine_POC__c t55 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('2/16/1957'),Contract_Type__c='1',Gender__c='F');
        insert t55;
        Census_Member_Reimagine_POC__c t56 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('3/22/1968'),Contract_Type__c='1',Gender__c='F');
        insert t56;
        Census_Member_Reimagine_POC__c t57 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('3/18/1980'),Contract_Type__c='1',Gender__c='F');
        insert t57;
        Census_Member_Reimagine_POC__c t58 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('12/6/1960'),Contract_Type__c='1',Gender__c='F');
        insert t58;
        Census_Member_Reimagine_POC__c t59 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('1/8/1956'),Contract_Type__c='1',Gender__c='F');
        insert t59;
        Census_Member_Reimagine_POC__c t60 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('11/23/1965'),Contract_Type__c='1',Gender__c='M');
        insert t60;
        Census_Member_Reimagine_POC__c t61 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('8/3/1991'),Contract_Type__c='1',Gender__c='F');
        insert t61;
        Census_Member_Reimagine_POC__c t62 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('4/9/1973'),Contract_Type__c='1',Gender__c='M');
        insert t62;
        Census_Member_Reimagine_POC__c t63 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('6/6/1968'),Contract_Type__c='1',Gender__c='F');
        insert t63;
        Census_Member_Reimagine_POC__c t64 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('3/29/1996'),Contract_Type__c='1',Gender__c='F');
        insert t64;
        Census_Member_Reimagine_POC__c t65 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('6/8/1988'),Contract_Type__c='1',Gender__c='F');
        insert t65;
        Census_Member_Reimagine_POC__c t66 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('2/16/1976'),Contract_Type__c='1',Gender__c='M');
        insert t66;
        Census_Member_Reimagine_POC__c t67 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('10/27/1962'),Contract_Type__c='1',Gender__c='F');
        insert t67;
        Census_Member_Reimagine_POC__c t68 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('5/9/1967'),Contract_Type__c='1',Gender__c='F');
        insert t68;
        Census_Member_Reimagine_POC__c t69 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('9/23/1990'),Contract_Type__c='1',Gender__c='F');
        insert t69;
        Census_Member_Reimagine_POC__c t70 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('1/9/1999'),Contract_Type__c='1',Gender__c='F');
        insert t70;
        Census_Member_Reimagine_POC__c t71 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('10/17/1958'),Contract_Type__c='1',Gender__c='F');
        insert t71;
        Census_Member_Reimagine_POC__c t72 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('2/14/1982'),Contract_Type__c='1',Gender__c='F');
        insert t72;
        Census_Member_Reimagine_POC__c t73 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('10/14/1956'),Contract_Type__c='1',Gender__c='F');
        insert t73;
        Census_Member_Reimagine_POC__c t74 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('4/20/1965'),Contract_Type__c='1',Gender__c='F');
        insert t74;
         Census_Member_Reimagine_POC__c t75 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('8/1/1974'),Contract_Type__c='1',Gender__c='F');
        insert t75;
        Census_Member_Reimagine_POC__c t76 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('8/11/1956'),Contract_Type__c='1',Gender__c='F');
        insert t76;
        Census_Member_Reimagine_POC__c t77 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('11/25/1971'),Contract_Type__c='1',Gender__c='F');
        insert t77;
        Census_Member_Reimagine_POC__c t78 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('3/15/1985'),Contract_Type__c='1',Gender__c='F');
        insert t78;
        Census_Member_Reimagine_POC__c t79 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('12/19/1988'),Contract_Type__c='1',Gender__c='M');
        insert t79;
        Census_Member_Reimagine_POC__c t80 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('1/16/1985'),Contract_Type__c='1',Gender__c='F');
        insert t80;
        Census_Member_Reimagine_POC__c t81 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('10/28/1972'),Contract_Type__c='1',Gender__c='F');
        insert t81;
        Census_Member_Reimagine_POC__c t82 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('5/14/1985'),Contract_Type__c='1',Gender__c='F');
        insert t82;
        Census_Member_Reimagine_POC__c t83 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('11/12/1961'),Contract_Type__c='1',Gender__c='F');
        insert t83; 
        Census_Member_Reimagine_POC__c t84 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('1/20/1970'),Contract_Type__c='1',Gender__c='F');
        insert t84;
        Census_Member_Reimagine_POC__c t85 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('5/4/1983'),Contract_Type__c='1',Gender__c='F');
        insert t85;
        Census_Member_Reimagine_POC__c t86 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('8/14/1995'),Contract_Type__c='1',Gender__c='F');
        insert t86;
        Census_Member_Reimagine_POC__c t87 = new Census_Member_Reimagine_POC__c(Census__c=bulkAdd[0].Id,Birthday__c=Date.parse('2/5/1957'),Contract_Type__c='1',Gender__c='F');
        insert t87; 
    }  
}