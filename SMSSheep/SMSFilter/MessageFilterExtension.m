//
//  MessageFilterExtension.m
//  SMSFilter
//
//  Created by ken.liu on 2019/4/18.
//  Copyright © 2019 ken.liu. All rights reserved.
//

#import "MessageFilterExtension.h"
#import "SMSPredict.h"

@interface MessageFilterExtension () <ILMessageFilterQueryHandling>

@end

@implementation MessageFilterExtension

#pragma mark - ILMessageFilterQueryHandling

- (void)handleQueryRequest:(ILMessageFilterQueryRequest *)queryRequest context:(ILMessageFilterExtensionContext *)context completion:(void (^)(ILMessageFilterQueryResponse *))completion {
    // First, check whether to filter using offline data (if possible).
    ILMessageFilterAction offlineAction = [self offlineActionForQueryRequest:queryRequest];
    
    switch (offlineAction) {
        case ILMessageFilterActionAllow:
        case ILMessageFilterActionFilter: {
            // Based on offline data, we know this message should either be Allowed or Filtered. Send response immediately.
            ILMessageFilterQueryResponse *response = [[ILMessageFilterQueryResponse alloc] init];
            response.action = offlineAction;
            
            completion(response);
            break;
        }
            
        case ILMessageFilterActionNone: {
            // Based on offline data, we do not know whether this message should be Allowed or Filtered. Defer to network.
            // Note: Deferring requests to network requires the extension target's Info.plist to contain a key with a URL to use. See documentation for details.
            [context deferQueryRequestToNetworkWithCompletion:^(ILNetworkResponse *_Nullable networkResponse, NSError *_Nullable error) {
                ILMessageFilterQueryResponse *response = [[ILMessageFilterQueryResponse alloc] init];
                response.action = ILMessageFilterActionNone;
                
                if (networkResponse) {
                    // If we received a network response, parse it to determine an action to return in our response.
                    response.action = [self actionForNetworkResponse:networkResponse];
                } else {
                    NSLog(@"Error deferring query request to network: %@", error);
                }
                
                completion(response);
            }];
            break;
        }
    }
}

- (ILMessageFilterAction)offlineActionForQueryRequest:(ILMessageFilterQueryRequest *)queryRequest {
    // Replace with logic to perform offline check whether to filter first (if possible).
    NSString *msg = queryRequest.messageBody;
    NSLog(@"msg = %@", msg);
    
    if ([SMSPredict predictSMS:msg]) {
        NSLog(@"predict = yes");
        return ILMessageFilterActionFilter;
    }
    NSLog(@"predict = no");
    return ILMessageFilterActionNone;
}

- (ILMessageFilterAction)actionForNetworkResponse:(ILNetworkResponse *)networkResponse {
    // Replace with logic to parse the HTTP response and data payload of `networkResponse` to return an action.
    NSLog(@"sms come on ========== 222222222222");
    return ILMessageFilterActionNone;
}

@end
