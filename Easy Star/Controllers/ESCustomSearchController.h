//
//  ESCustomSearchController.h
//  Easy Star
//
//  Created by Longueville Xavier on 10/03/16.
//  Copyright © 2016 Longueville Xavier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESCustomSearchBar.h"


@protocol ESCustomSearchControllerDelegate <NSObject>

-(void)didStartSearching;

-(void)didTapOnSearchButton;

-(void)didTapOnCancelButton;

-(void)didChangeSearchText:(NSString*)searchText;

@end

@interface ESCustomSearchController : UISearchController

@property (strong, nonatomic) ESCustomSearchBar *customSearchBar;
@property (weak, nonatomic) id<ESCustomSearchControllerDelegate> customDelegate;

- (instancetype)initWithSearchResultsController:(UIViewController*)searchResultController   searchBarFrame:(CGRect)frame
                                  searchBarFont:(UIFont *)searchBarFont
                             searchBarTextColor:(UIColor *)searchBarTextColor
                             searchBarTintColor:(UIColor *)searchBarTintColor;
@end
