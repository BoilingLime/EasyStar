//
//  ESDiplayBusResultViewController.h
//  Easy Star
//
//  Created by Longueville Xavier on 10/03/16.
//  Copyright © 2016 Longueville Xavier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESStop.h"

@interface ESDisplayBusResultViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
}
@property (strong, nonatomic) NSMutableArray *busData;
@property (strong, nonatomic) NSMutableArray *distinctStops;
@property (strong, nonatomic) RLMResults *busStops;

@end
