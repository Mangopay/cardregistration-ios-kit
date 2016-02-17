//
//  MPConstants.h
//  mangopay
//
//  Created by Victor on 2/17/16.
//  Copyright © 2016 mangopay. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MP_UrlParamLanguage @"lang"
#define MP_UrlParamEmail @"customerEmail"
#define MP_UrlParamCurrency @"currency"

#define MP_baseURL @"https://api.sandbox.mangopay.com"


// Create a new CardRegistration object on the server and pass it over to the JavaScript kit:
// Initialize with card register data prepared on the server
mangoPay.cardRegistration.init({
    cardRegistrationURL: {CardRegistrationURL property},
    preregistrationData: {PreregistrationData property},
    accessKey: {AccessKey property},
    Id: {Id property}
});


// Card data collected from the user
#define MP_cardNumber @""
#define MP_cardExpirationDate @""
#define MP_cardCvx @""
#define MP_cardType @""


// Set MangoPay API base URL and Client ID
mangoPay.cardRegistration.baseURL = "https://api.sandbox.mangopay.com";
mangoPay.cardRegistration.clientId = {your-client-id};






