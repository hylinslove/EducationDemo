//
//  CALayer+XibBorderColor.m
//  EducationDemo
//
//  Created by xianglong on 2018/11/28.
//  Copyright © 2018年 xianglong. All rights reserved.
//

#import "CALayer+XibBorderColor.h"
#import <UIKit/UIKit.h>


@implementation CALayer (XibBorderColor)
// CALayer+XibBorderColor.m

- (void)setBorderColorWithUIColor:(UIColor *)color
{
    
    self.borderColor = color.CGColor;
}

@end
