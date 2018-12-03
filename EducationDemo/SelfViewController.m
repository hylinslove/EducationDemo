//
//  SelfViewController.m
//  EducationDemo
//
//  Created by xianglong on 2018/11/29.
//  Copyright © 2018年 xianglong. All rights reserved.
//

#import "SelfViewController.h"

@interface SelfViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *icon_me;

@end

@implementation SelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.icon_me.layer.cornerRadius=self.icon_me.frame.size.width/2;//裁成圆角
    self.icon_me.layer.masksToBounds=YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
//    self.tabBarController.tabBar.hidden = true;
    self.navigationController.navigationBar.hidden = true;
    
}

- (void)viewWillDisappear:(BOOL)animated{
//    self.tabBarController.tabBar.hidden = false;
    self.navigationController.navigationBar.hidden = false;
    
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

@end
