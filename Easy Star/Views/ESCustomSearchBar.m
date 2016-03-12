//
//  ESCustomSearchBar.m
//  Easy Star
//
//  Created by Longueville Xavier on 10/03/16.
//  Copyright © 2016 Longueville Xavier. All rights reserved.
//

#import "ESCustomSearchBar.h"

@implementation ESCustomSearchBar
{
}


@synthesize preferredFont = _preferredFont;
@synthesize preferredTextColor = _preferredTextColor;

- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font fontColor:(UIColor*)color
{
    self = [super init];
    if (self) {
        self.frame = frame;
        _preferredFont = font;
        _preferredTextColor = color;
        self.searchBarStyle = UISearchBarStyleDefault;
        self.translucent = NO;
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    NSInteger index = [self indexOfSearchFieldInSubviews];
    UITextField *searchField = self.subviews[0].subviews[index];
    
    
    searchField.font = _preferredFont;
    searchField.textColor = _preferredTextColor;
    
    searchField.backgroundColor = self.barTintColor;
    
    [super drawRect:rect];
}


-(NSInteger)indexOfSearchFieldInSubviews
{
    NSInteger index;
    UIView *searchBarView = self.subviews[0];
    
    for (int i = 0; i < searchBarView.subviews.count; ++i) {
        if ([searchBarView.subviews[i] isKindOfClass:[UITextField class]]) {
            index = i;
            break;
        }
    }
    
    return index;
}

@end
