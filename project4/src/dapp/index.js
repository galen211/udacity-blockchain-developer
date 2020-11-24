import DOM from './dom';
import Contract from './contract';
import './flightsurety.css';


(async() => {

    let result = null;

    let contract = new Contract('localhost', () => {

        // Read transaction
        contract.isOperational((error, result) => {
            console.log(error,result);
            display('Operational Status', 'Check if contract is operational', [ { label: 'Operational Status', error: error, value: result} ]);
        });

        // Airline registers Flights
        DOM.elid('register-flight').addEventListener('click', () => {
            let flight = DOM.elid('new-flight').value;
            if(flight != '')
            {
                //Forward call to smart contract
                contract.registerFlight(flight, (error, result) => {
                    display('Register Flight', 'Trigger App contract', [ { label: 'Registration:', error: error,  value: 'Success - registered. ' } ]);
                });
            }
            
        });
    
        // User buys insurance
        DOM.elid('buy-insurance').addEventListener('click', () => {
        // Get User address from Metamask
        if (!contract.owner) {
            alert("You need to install and login to an Ethereum-compatible wallet or extension like MetaMask to use this dApp.");
            //return false; //Do something to abort the process?
        }
        else{ //Proceed to buy insurance under the user's account
            let flight = DOM.elid('flight-number').value;
            let amount = DOM.elid('insurance-value').value;
            if(confirm('You are about to pay '+ amount +' Ethers for insuring your trip on flight '+flight+'. The amount will be deducted from the account: ' + contract.owner + '.\nAre you sure?'))
            {                    
                //Forward call to smart contract
                contract.buyInsurance(flight, amount, (error, result) => {
                    display('Buy Insurance', 'Trigger App contract', [ { label: 'Buying result:', error: error,  value: 'Success - insured ' + result.flight + ' with ' + result.amount + ' ethers.'} ]);
                    //Display updated list of all insured flights for this customer
                   /* contract.viewInsuredFlights((error2, result2) => {
                        console.log('Flight insured successfully. Here is the updated list of your insured flights transactions:\n');
                        //for(var i=0; i<result[0].length; i++)
                            //console.log(result[0][i] + '\t' + result[1][i] + ' ethers\n');
                        console.log(JSON.stringify(result2));
                    });*/
                });

            }

        }
            
        });

        // User-submitted transaction
        DOM.elid('submit-oracle').addEventListener('click', () => {
            let flight = DOM.elid('flight-number-oracles').value;
            // Write transaction
            contract.fetchFlightStatus(flight, (error, result) => {
                /* Flight status codes
                STATUS_CODE_UNKNOWN = 0; 
                STATUS_CODE_ON_TIME = 10;
                STATUS_CODE_LATE_AIRLINE = 20;
                STATUS_CODE_LATE_WEATHER = 30;
                STATUS_CODE_LATE_TECHNICAL = 40;
                STATUS_CODE_LATE_OTHER = 50;*/
                let status = '';
                switch(result)
                {
                    case '0': status = 'Unkown';  break;
                    case '10': status = 'On Time'; break;
                    case '20': status = 'Late- airline'; break;
                    case '30': status = 'Late- Weather'; break;
                    case '40': status = 'Late- Technical'; break;
                    case '50': status = 'Late- Other';
                }
                display('Oracles', 'Trigger oracles', [ { label: 'Fetch Flight Status', error: error, value: status} ]);
            });
        });

        let credit = 0;
        // Claim Insurance
        DOM.elid('claim-insurance').addEventListener('click', () => {
            let flight = DOM.elid('flight-number-claim').value;
            // Write transaction
            contract.claimInsurance(flight, (errorClaim, resultClaim) => {
                
                contract.getCredit((errorGet, resultGet) => {

                    credit = resultGet / Math.pow(10, 18); //convert from wei back to ether

                    display('Insurance Amount', 
                        (errorClaim? 'You are not legible to a refund for flight ':'You are legible to a refund for flight ') + flight, 
                        [ { label: 'Total credit amount in Ether:', 
                            error: errorGet, 
                            value: JSON.stringify(credit),
                            insuranceCredit: credit
                        } ]);
                        DOM.elid('withdraw-credit').style.display = 'inline';
                    console.log('claimInsurance in contract.js returned result: ' + credit);
                });//end getCredit
            }); //end claimInsurance
        });


        // Withdraw Credit
        let withdrawButton = DOM.elid('withdraw-credit');
        withdrawButton.style.display = 'none';

        //if(withdrawButton)  //First make sure the button exists
            withdrawButton.addEventListener('click', () => {
            //console.log('Withdraw button was clicked!'+ credit);   
                if(credit > 0)  //Make sure there is credit
                {
                    if(confirm(credit +' Ethers are going to be transferred to this account: '+contract.owner+'\nPlease confirm.'))
                    {
                        contract.withdraw((error, result) => {
                            if(!error){
                                console.log('You have been credited ' + credit + ' Ethers to your account.')
                                credit = 0; //reset the credit amount after withdawal -- to prevent misleading messages to the user
                                withdrawButton.style.display = 'none'; //Do not allow more withdrawals
                            }else
                                console.log('Withdraw function returned error: ' + error);
                        });
                    }
                }
            });
    
    });
    

})();


function getAccounts(callback) {
    web3.eth.getAccounts((error,result) => {
        if (error) {
            console.log(error);
        } else {
            callback(result);
        }
    });
}

function display(title, description, results) {
    let displayDiv = DOM.elid("display-wrapper");
    let section = DOM.section();
    section.appendChild(DOM.h2(title));
    section.appendChild(DOM.h5(description));
    results.map((result) => {
        let row = section.appendChild(DOM.div({className:'row'}));
        row.appendChild(DOM.div({className: 'col-sm-4 field'}, result.label));
        row.appendChild(DOM.div({className: 'col-sm-8 field-value'}, result.error ? String(result.error) : result.value));

        
    })
    displayDiv.append(section);

}