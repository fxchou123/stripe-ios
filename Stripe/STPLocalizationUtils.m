//
//  STPLocalizationUtils.m
//  Stripe
//
//  Created by Brian Dorfman on 8/11/16.
//  Copyright © 2016 Stripe, Inc. All rights reserved.
//

#import "STPLocalizationUtils.h"
#import "STPBundleLocator.h"

@implementation STPLocalizationUtils

+ (NSString *)localizedStripeStringForKey:(NSString *)key {
    
    /**
     If the main app has a localization that we do not support, we want to switch
     to pulling strings from the main bundle instead of our own bundle so that
     users can add translations for our strings without having to fork the sdk.
     
     At launch, NSBundles' store what language(s) the user requests that they
     actually have translations for in `preferredLocalizations`.
     
     We compare our framework's resource bundle to the main app's bundle, and
     if their language choice doesn't match up we switch to pulling strings
     from the main bundle instead.
     
     This also prevents language mismatches. E.g. the user lists portuguese and
     then spanish as their preferred languages. The main app supports both so all its
     strings are in pt, but we support spanish so our bundle marks es as our
     preferred language and our strings are in es.
     */
    
    NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:@"language"];
    NSString *localizationBundlePathName = @"Base";
    
    if ([language isEqualToString:@"cn"]) {
        localizationBundlePathName = @"zh-Hans";
    } else if ([language isEqualToString:@"tw"]) {
        localizationBundlePathName = @"zh-Hant";
    }
    
    NSString *localizationBundlePath = [[NSBundle mainBundle] pathForResource:localizationBundlePathName ofType:@"lproj"];
    NSBundle *bundle = localizationBundlePath ? [NSBundle bundleWithPath:localizationBundlePath] : [NSBundle mainBundle];
    NSString *translation = [bundle localizedStringForKey:key value:nil table:@"Stripe"];
    
    return translation;
}

@end
