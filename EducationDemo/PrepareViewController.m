//
//  PrepareViewController.m
//  EducationDemo
//
//  Created by xianglong on 2018/11/29.
//  Copyright © 2018年 xianglong. All rights reserved.
//

#import "PrepareViewController.h"

@interface PrepareViewController ()

@end

@implementation PrepareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}
-(void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults] ;
    NSString *isLogin = @"";
    if (ud!=nil) {
         isLogin = [ud objectForKey:@"isLogin"];
    }
    
    if ([isLogin isEqualToString:@"true"]) {
        [self performSegueWithIdentifier:@"showMain" sender:self];
    } else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return NO;
    //    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
