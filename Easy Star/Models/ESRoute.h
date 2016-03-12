//
//  ESRoute.h
//  Easy Star
//
//  Created by Longueville Xavier on 09/03/16.
//  Copyright © 2016 Longueville Xavier. All rights reserved.
//

#import <Realm/Realm.h>

@interface ESRoute : RLMObject

@property NSString *id;
@property NSString *agencyId;
@property NSString *shortName;
@property NSString *longName;
@property NSString *desc;
@property NSString *type;
@property NSString *color;
@property NSString *textColor;


@end

// This protocol enables typed collections. i.e.:
// RLMArray<ESRoute>
RLM_ARRAY_TYPE(ESRoute)
