//
//  ESBusDeparture.h
//  Easy Star
//
//  Created by Longueville Xavier on 10/03/16.
//  Copyright © 2016 Longueville Xavier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESBusDeparture : NSObject

@property (nonatomic, strong) NSString *routeId;
@property (nonatomic, strong) NSString *stopId;
@property (nonatomic, strong) NSString *headSign;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSDate *date;

@end
