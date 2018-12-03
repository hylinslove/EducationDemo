//
//  SaveViewController.h
//  EducationDemo
//
//  Created by xianglong on 2018/11/30.
//  Copyright © 2018年 xianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveViewController : UIViewController
@property (strong,nonatomic) NSData *imgData;
@property (strong,nonatomic) NSString *ques_id;

@property (strong,nonatomic) UIStoryboardSegue *segue;
@end
