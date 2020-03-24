//
//  Counter.m
//  AwesomeProject
//
//  Created by brel on 3/18/20.
//  Copyright © 2020 Facebook. All rights reserved.
//
@import React;
#import <React/RCTEventEmitter.h>
@interface RCT_EXTERN_MODULE(AdobeAccessEnabler, RCTEventEmitter)
//requestorID: String, softwareStatement: String, resourceID: String?, baseURL: String?
RCT_EXTERN_METHOD(setupAccessEnabler:(NSDictionary*) pluginConfig)
RCT_EXTERN_METHOD(setProviderID:(NSString*) providerID)
RCT_EXTERN_METHOD(startLoginFlow:(NSDictionary*) additionalParameters callback:(RCTResponseSenderBlock)callback)
@end
