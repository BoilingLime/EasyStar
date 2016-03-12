//
//  ESTrip.h
//  Easy Star
//
//  Created by Longueville Xavier on 09/03/16.
//  Copyright © 2016 Longueville Xavier. All rights reserved.
//

#import <Realm/Realm.h>

@interface ESTrip : RLMObject

@property NSString *tripId;
@property NSString *serviceId;
@property NSString *routeId;
@property NSString *headsign;
@property BOOL direction;
@property BOOL wheelchairAccessible;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ESTrip>
RLM_ARRAY_TYPE(ESTrip)
