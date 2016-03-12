//
//  ESHttpClient.h
//  Easy Star
//
//  Created by Longueville Xavier on 09/03/16.
//  Copyright © 2016 Longueville Xavier. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ESHttpClient : NSObject

+ (void) getDepartureInfosAtStops:(NSMutableArray *)stops withCompletionHandler:(void (^)(NSDictionary *))complete failure:(void (^)(NSError *))failure;

@end
