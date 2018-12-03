//
//  LoginViewController.m
//  EducationDemo
//
//  Created by xianglong on 2018/11/27.
//  Copyright © 2018年 xianglong. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"

@interface LoginViewController ()
- (IBAction)doLogin:(id)sender;

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated {
   
}
-(void)viewDidAppear:(BOOL)animated {
//    if (true) {
//        NSLog(@"登录跳转");
//        [self performSegueWithIdentifier:@"Login" sender:self];
////        [self presentViewController:[MainViewController alloc] animated:YES completion:nil];
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doLogin:(id)sender {
     [self performSegueWithIdentifier:@"Login" sender:self];
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return NO;
    //    return YES;
}
@end
