//
//  ESStop.m
//  Easy Star
//
//  Created by Longueville Xavier on 09/03/16.
//  Copyright © 2016 Longueville Xavier. All rights reserved.
//

#import "ESStop.h"

@implementation ESStop

+ (NSMutableArray *)filterUniqueNameFromSet:(RLMResults *)set
{
    NSMutableArray *disctinctArray = [NSMutableArray array];
    
    NSMutableArray *uniqueNames = [NSMutableArray array];
    
    for (ESStop *stop in set) {
        
        NSString *stopName = stop.name;
        
        ESStop *uniqueStop = (ESStop *)stop;
        
        if (![uniqueNames containsObject:stopName]) {
            [disctinctArray addObject:uniqueStop];
            [uniqueNames addObject:stopName];
        }
    }
    
    return disctinctArray;
}

@end
