//
//  AppDelegate.h
//  EducationDemo
//
//  Created by xianglong on 2018/11/26.
//  Copyright © 2018年 xianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (strong, nonatomic) NSString *userId;

- (void)saveContext;


@end

