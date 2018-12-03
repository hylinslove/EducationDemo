//
//  DBManager.h
//  EducationDemo
//
//  Created by xianglong on 2018/11/29.
//  Copyright © 2018年 xianglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "QesModel.h"

@interface DBManager : NSObject
@property (strong, nonatomic)FMDatabase *db;
+ (instancetype)sharedManger;
-(void) initDBTool;
-(void) insertQues:(QesModel *)ques;
-(NSMutableArray *) queryQuesForUser:(NSString *)ueser class:(NSString *)class;

@end
