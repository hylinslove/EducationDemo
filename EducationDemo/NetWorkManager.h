//
//  NetWorkManager.h
//  EducationDemo
//
//  Created by xianglong on 2018/11/29.
//  Copyright © 2018年 xianglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetWorkManager : NSObject
@property (nonatomic, strong) AFHTTPSessionManager *serviceManager;

+ (instancetype)sharedManger;

//注册-申请验证码
- (void)getVerificationWithPhonenumber:(NSString *)phonenumber success:(void(^) (NSDictionary *responseOBJ))successBlock failure:(void(^) (NSError *error))failureBlock;

//注册-验证 验证码
- (void)verifyPhonenumber:(NSString *)phonenumber verification:(NSString *)verification success:(void(^) (NSDictionary *responseOBJ))successBlock failure:(void(^) (NSError *error))failureBlock;

//注册
- (void)registerWithUsername:(NSString *)username password:(NSString *)password fullname:(NSString *)fullname xzqh:(NSString *)xzqh organization:(NSString *)organization job:(NSString *)job success:(void(^) (NSDictionary *responseOBJ))successBlock failure:(void(^) (NSError *error))failureBlock;

//修改密码
- (void)modifyPasswordPhonenumber:(NSString *)phonenumber password:(NSString *)password success:(void(^) (NSDictionary *responseOBJ))successBlock failure:(void(^) (NSError *error))failureBlock;


//登录用
- (void)userLogin:(NSString *)userName password:(NSString *)password success:(void(^) (NSDictionary *responseOBJ))successBlock failure:(void(^) (NSError *error))failureBlock;

//更新任务
- (void)getMissionWithUsername:(NSString *)username andXZQMC:(NSString *)xzqmc success:(void(^)(NSArray *responseOBJ)) successBlock failure:(void(^) (NSError *error))failureBlock;

//同步任务
- (void)updateMissionWithGXRQ:(NSString *)gxrq andUserName:(NSString *)userName success:(void(^)(NSArray *responseOBJ)) successBlock failure:(void(^) (NSError *error))failureBlock;

////上传任务
//- (void)uploadTaskWithGuid:(NSString *)guid progress:(void(^)(NSProgress * uploadProgress)) progressBlock success:(void(^)(id responseOBJ)) successBlock failure:(void(^) (NSError *error))failureBlock;


@end
