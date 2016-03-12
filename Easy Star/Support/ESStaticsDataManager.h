//
//  ESStaticsDataManager.h
//  Easy Star
//
//  Created by Longueville Xavier on 09/03/16.
//  Copyright © 2016 Longueville Xavier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESStaticsDataManager : NSObject

+ (instancetype) sharedInstance;

- (void) loadData;
- (void) changeDefaultRealmPath;

@end
