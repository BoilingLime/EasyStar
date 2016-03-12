//
//  ESStop.h
//  Easy Star
//
//  Created by Longueville Xavier on 09/03/16.
//  Copyright © 2016 Longueville Xavier. All rights reserved.
//

#import <Realm/Realm.h>

@interface ESStop : RLMObject

@property NSString *id;
@property NSString *code;
@property NSString *name;
@property NSString *desc;

@property double latitude;
@property double longitude;


+ (NSMutableArray *)filterUniqueNameFromSet:(RLMResults *)set;


@end

// This protocol enables typed collections. i.e.:
// RLMArray<ESStop>
RLM_ARRAY_TYPE(ESStop)
