//
//  QesModel.h
//  EducationDemo
//
//  Created by xianglong on 2018/12/2.
//  Copyright © 2018年 xianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QesModel : NSObject
@property (strong, nonatomic) NSString *ques_id;
@property (strong, nonatomic) NSString *ques_class;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *tip;
@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSString *understand;
@property (assign, nonatomic) NSString *review_time;
@property (strong, nonatomic) NSString *ques_img;
@property (strong, nonatomic) NSString *ans_img;
@property (strong, nonatomic) NSString *date;
@end
