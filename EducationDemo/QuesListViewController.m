//
//  QuesListViewController.m
//  EducationDemo
//
//  Created by xianglong on 2018/11/29.
//  Copyright © 2018年 xianglong. All rights reserved.
//

#import "QuesListViewController.h"
#import "QuesTableViewCell.h"
#import "DBManager.h"
#import "QesModel.h"
@interface QuesListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *quesList;

@end

@implementation QuesListViewController{
    int width;
    int height;
    NSMutableArray *quesArray;
    DBManager *manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _ques_id;
    manager = [DBManager sharedManger];
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    width = screenFrame.size.width;
    height = screenFrame.size.height;
    _quesList.delegate = self;
    _quesList.dataSource = self;
    
    [self loadData];
}

-(void) loadData {
    
    quesArray = [manager queryQuesForUser:_user class:_ques_id];
    [_quesList reloadData];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    QuesTableViewCell *cell = [QuesTableViewCell cell];
    
    [cell setContent:quesArray[indexPath.row]];
    NSLog([NSString stringWithFormat:@"第%i个",indexPath.row]);
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return quesArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
