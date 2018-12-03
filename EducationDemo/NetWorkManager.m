//
//  NetWorkManager.m
//  EducationDemo
//
//  Created by xianglong on 2018/11/29.
//  Copyright © 2018年 xianglong. All rights reserved.
//

#import "NetWorkManager.h"


#define kLOGINURL @"http://221.178.156.98:8091/njtz/app/login.do"

#define kGETDATA @"http://221.178.156.98:8091/njtz/app/getData.do"

#define kRemoveYHC @"http://221.178.156.98:8091/njtz/app/getYhcTb.do"

#define kGETINFOBYHCZT @"http://221.178.156.98:8091/domain/service/rest/sjdj/getInfoByHczt"

#define kUploadLocInfo @"http://221.178.156.98:8091/njtz/app/updateGPS.do"
@implementation NetWorkManager
static NetWorkManager *manager = nil;



+(instancetype)sharedManger{
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[self alloc]init];
        manager.serviceManager = [AFHTTPSessionManager manager];
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        manager.serviceManager.responseSerializer = responseSerializer;
        manager.serviceManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", @"text/plain", nil];
        
    });
    return manager;
}

//注册通过手机号获取验证码
- (void)getVerificationWithPhonenumber:(NSString *)phonenumber success:(void (^)(NSDictionary *))successBlock failure:(void (^)(NSError *))failureBlock{
    
    NSDictionary *param = @{@"phone":phonenumber};
    NSString *url = @"http://221.178.156.98:8091/njtz/app/sendVerification.do";
    [_serviceManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}
//注册验证验证码
- (void)verifyPhonenumber:(NSString *)phonenumber verification:(NSString *)verification success:(void (^)(NSDictionary *))successBlock failure:(void (^)(NSError *))failureBlock{
    
    NSDictionary *param = @{@"phone":phonenumber,
                            @"verification":verification};
    NSString *url = @"http://221.178.156.98:8091/njtz/app/verify.do";
    [_serviceManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}
//注册
-(void)registerWithUsername:(NSString *)username password:(NSString *)password fullname:(NSString *)fullname xzqh:(NSString *)xzqh organization:(NSString *)organization job:(NSString *)job success:(void (^)(NSDictionary *))successBlock failure:(void (^)(NSError *))failureBlock{
    
    NSDictionary *param = @{@"username":username==nil?@"":username,
                            @"password":password==nil?@"":password,
                            @"fullname":fullname==nil?@"":fullname,
                            @"xzqh":xzqh==nil?@"":xzqh,
                            @"organization":organization==nil?@"":organization,
                            @"job":job==nil?@"":job};
    
    NSString *url = @"http://221.178.156.98:8091/njtz/app/regPhone.do";
    [_serviceManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
    
    
}

//重置密码
- (void)modifyPasswordPhonenumber:(NSString *)phonenumber password:(NSString *)password success:(void (^)(NSDictionary *))successBlock failure:(void (^)(NSError *))failureBlock{
    
    NSDictionary *param = @{@"username":phonenumber,
                            @"password":password};
    
    NSString *url = @"http://221.178.156.98:8091/njtz/app/modifyPassword.do";
    
    [_serviceManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
    
}

//登录
- (void)userLogin:(NSString *)userName password:(NSString *)password success:(void (^)(NSDictionary *))successBlock failure:(void (^)(NSError *))failureBlock{
    
    NSDictionary *param = @{@"username":userName,
                            @"password":password};
    
    [self.serviceManager POST:kLOGINURL parameters:param progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        successBlock(responseObject);
        //      [self removeYhcTaskbyXian:[responseObject valueForKey:@"msg"]];
        //      [self removeYhcTaskbyXian:@"340225"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failureBlock(error);
        
    }];
    
}


//更新任务
- (void)getMissionWithUsername:(NSString *)username andXZQMC:(NSString *)xzqmc success:(void (^)(NSArray *))successBlock failure:(void (^)(NSError *))failureBlock{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *gxrq = [formatter stringFromDate:[NSDate date]];
    
    NSDictionary *param = @{@"gxrq":gxrq,
                            @"xzqh":xzqmc,
                            @"USERNAME":username
                            };
    
    [self.serviceManager POST:kGETDATA parameters:param progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failureBlock(error);
    }];
    
}

//同步任务
- (void)updateMissionWithGXRQ:(NSString *)gxrq andUserName:(NSString *)userName success:(void (^)(NSArray *))successBlock failure:(void (^)(NSError *))failureBlock{
    
    if (gxrq == nil || userName == nil) {
        NSLog(@"gxrq 或者 userName 为空");
        return;
    }
    
    NSDictionary *param = @{
                            @"GXRQ":gxrq,
                            @"USERNAME":userName
                            };
    
    [self.serviceManager POST:kGETINFOBYHCZT parameters:param progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
    
    
}




- (void)uploadLocInfo:(NSDictionary *)info{
    
    //http://218.4.170.54:8093/domain/service/rest/zghcAction/updateGPS
    
    [self.serviceManager POST:kUploadLocInfo parameters:info progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        NSLog(@"111");
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
}
//获取Documents目录
-(NSString *)dirDoc{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

@end
