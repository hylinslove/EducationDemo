//
//  DBManager.m
//  EducationDemo
//
//  Created by xianglong on 2018/11/29.
//  Copyright © 2018年 xianglong. All rights reserved.
//

#import "DBManager.h"
#import "AppDelegate.h"


@implementation DBManager

+(instancetype)sharedManger{
    static DBManager *manager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
       manager = [[self alloc]init];
        
        
    });
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *DBPath = [documentPath stringByAppendingPathComponent:@"edu.db"];
    //    NSLog(@"%@",DBPath);
    manager.db = [FMDatabase databaseWithPath:DBPath];
    return manager;
}

-(void) initDBTool {
    if(![_db open]) {
        NSLog(@"%@",[_db lastErrorMessage]);
        return;
    }
    //创建表
    if (![_db executeUpdate:@"CREATE TABLE IF NOT EXISTS QUES(ID INTEGER PRIMARY KEY AUTOINCREMENT,QUES_ID TEXT,QUES_CLASS TEXT,USER TEXT,TIP TEXT,QUES_FROM TEXT,UNDERSTAND TEXT,REVIEW_TIME TEXT,QUES_IMG TEXT,ANS_IMG TEXT,DATE TEXT)"]) {
        NSLog(@"创建wptask错误：%@",[_db lastErrorMessage]);
    }
    
    if (![_db executeUpdate:@"CREATE TABLE IF NOT EXISTS USER(ID INTEGER PRIMARY KEY AUTOINCREMENT,USER_ID TEXT,GRADE TEXT, NAME TEXT,SCHOOL TEXT,ICON TEXT)"]) {
        NSLog(@"创建task错误：%@",[_db lastErrorMessage]);
    }
    
    [_db close];
}

-(void)insertQues:(QesModel *)ques {
    if(![_db open]) {
        NSLog(@"%@",[_db lastErrorMessage]);
        return;
    }
    if (![_db executeUpdateWithFormat:@"INSERT OR IGNORE INTO QUES(QUES_ID,QUES_CLASS,USER,TIP,QUES_FROM,UNDERSTAND,REVIEW_TIME,QUES_IMG,ANS_IMG,DATE) VALUES(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@)",ques.ques_id,ques.ques_class,ques.user,ques.tip,ques.from,ques.understand,ques.review_time,ques.ques_img,ques.ans_img,ques.date]){
        NSLog(@"插入错误：%@",[_db lastErrorMessage]);
    }
    
    [_db close];
}

-(NSMutableArray *)queryQuesForUser:(NSString *)ueser class:(NSString *)class {
    NSMutableArray *arr = [NSMutableArray array];
    if(![_db open]) {
        NSLog(@"%@",[_db lastErrorMessage]);
        return arr;
    }
    
    FMResultSet *result = [_db executeQuery:@"select * from 'QUES' where user = ? and QUES_CLASS = ?" ,ueser,class];
    
    while ([result next]) {
        QesModel *ques = [[QesModel alloc] init];
        
        ques.user= [result stringForColumn:@"USER"];
        ques.ques_id= [result stringForColumn:@"QUES_ID"];
        ques.ques_class= [result stringForColumn:@"QUES_CLASS"];
        ques.from= [result stringForColumn:@"QUES_FROM"];
        ques.review_time= [result stringForColumn:@"REVIEW_TIME"];
        ques.understand= [result stringForColumn:@"UNDERSTAND"];
        ques.tip= [result stringForColumn:@"TIP"];
        ques.ans_img= [result stringForColumn:@"ANS_IMG"];
        ques.ques_img= [result stringForColumn:@"QUES_IMG"];
        ques.date= [result stringForColumn:@"DATE"];
        
        [arr addObject:ques];
        NSLog(@"从数据库查询到的人员 %@",ques.ques_id);
    }
    [_db close];
    return arr;
}




@end
