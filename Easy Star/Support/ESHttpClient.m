//
//  ESHttpClient.m
//  Easy Star
//
//  Created by Longueville Xavier on 09/03/16.
//  Copyright © 2016 Longueville Xavier. All rights reserved.
//

#import "ESHttpClient.h"


static NSString *baseUrl    = @"http://data.keolis-rennes.com/json/?cmd=getbusnextdepartures&version=2.1&key=76GKT2XFRBR8WNY&param[mode]=stop";

@implementation ESHttpClient


+ (void) getDepartureInfosAtStops:(NSMutableArray *)stops withCompletionHandler:(void (^)(NSDictionary *))complete failure:(void (^)(NSError *))failure
{
    NSURLSession *session = [NSURLSession sharedSession];

    
    [[session dataTaskWithURL:[NSURL URLWithString:[ESHttpClient buildQueryUrlForStopsId:stops]]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSError *jsonError;
                
                NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingAllowFragments
                                                  error:&jsonError];
                if (!jsonError && !error) {
                    complete(parsedData);
                }
                else {
                    failure(error);
                }
                
                
            }] resume];
}


+ (NSString *) buildQueryUrlForStopsId:(NSMutableArray*)stops
{
    NSMutableString *urlString = [NSMutableString new];
    
    [urlString appendString:baseUrl];
    
    for (NSString *stop in stops) {
        [urlString appendFormat:@"&param[stop][]=%@", stop];
    }
    
    return urlString;
}
@end
