//
//  ESCustomSearchBar.h
//  Easy Star
//
//  Created by Longueville Xavier on 10/03/16.
//  Copyright © 2016 Longueville Xavier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESCustomSearchBar : UISearchBar

- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font fontColor:(UIColor*)color;

@property (nonatomic, strong) UIFont    *preferredFont;
@property (nonatomic, strong) UIColor   *preferredTextColor;


@end
