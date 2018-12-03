//
//  MainViewController.m
//  EducationDemo
//
//  Created by xianglong on 2018/11/27.
//  Copyright © 2018年 xianglong. All rights reserved.
//

#import "MainViewController.h"
#import "ClassCollectionViewCell.h"
#import "QuesClass.h"
#import "UIColor+ColorChange.h"
#import "DBManager.h"
#import "AppDelegate.h"
#import "QuesListViewController.h"

@interface MainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
//@property (retain, nonatomic)  UISearchBar *searchBar;

@end

@implementation MainViewController{
    int width;
    int height;
    NSMutableArray *classArray;
    DBManager *manager;
    AppDelegate *appDelegate;
    NSString *selectedQuesId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
    manager = [DBManager sharedManger];
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    self.mainCollectionView.delegate =self;
    self.mainCollectionView.dataSource = self;

    
    
     UINib *nib = [UINib nibWithNibName:@"ClassCollectionViewCell" bundle: [NSBundle mainBundle]];
    [self.mainCollectionView registerNib:nib forCellWithReuseIdentifier:@"cell"];
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    width = screenFrame.size.width;
    height = screenFrame.size.height;
    
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(width/2-15, 10, width/4, 40)];
//    title.text = @"首页";
//    title.textColor =[UIColor colorwithHexString:@"ffffff"];
//    [self.navigationController.navigationBar addSubview:title];
    
}
- (void) loadData {
    classArray = [NSMutableArray array];
   
    [classArray addObject:[self getClass:@"语文" withIcon:@"icon_yuwen"]];
    [classArray addObject:[self getClass:@"数学" withIcon:@"icon_shuxue"]];
    [classArray addObject:[self getClass:@"英语" withIcon:@"icon_yingyu"]];
    [classArray addObject:[self getClass:@"政治" withIcon:@"icon_zhengzhi"]];
    [classArray addObject:[self getClass:@"历史" withIcon:@"icon_lishi"]];
    [classArray addObject:[self getClass:@"生物" withIcon:@"icon_shengwu"]];
    [classArray addObject:[self getClass:@"地理" withIcon:@"icon_dili"]];
    [classArray addObject:[self getClass:@"物理" withIcon:@"icon_wuli"]];
    [classArray addObject:[self getClass:@"化学" withIcon:@"icon_huaxue"]];
    [classArray addObject:[self getClass:@"科学" withIcon:@"icon_kexue"]];
    
    [_mainCollectionView reloadData];
}

//构造学科item
-(QuesClass *) getClass:(NSString *)name withIcon:(NSString *)icon  {
    QuesClass *quesClass = [QuesClass alloc];
    quesClass.className = name;
    quesClass.classIcon = icon;
    
    quesClass.classNum =[manager queryQuesForUser:appDelegate.userId class:name].count;
    
    return quesClass;
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


//collection
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//获取总数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return classArray.count;
}

//获取item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"cell";
    ClassCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    QuesClass *quesClass =classArray[indexPath.row];

    [cell.name_class setText:quesClass.className];
    [cell.icon_class setImage:[UIImage imageNamed:quesClass.classIcon]];
    [cell.count_class setText:[NSString stringWithFormat:@"%zd",quesClass.classNum]];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
 
    return CGSizeMake((width-22)/3,(width-22)/3+10 );
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"select item at %ld",(long)indexPath.row);
    QuesClass *quesClass =classArray[indexPath.row];
    selectedQuesId = quesClass.className;
    [self performSegueWithIdentifier:@"itemClick" sender:self];
    
}


-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = false;
    [self loadData];
}
//#pragma mark  定义每个UICollectionView的横向间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}
//
//#pragma mark  定义每个UICollectionView的纵向间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    QuesListViewController *quesListVC  = segue.destinationViewController;
    quesListVC.ques_id = selectedQuesId;
    quesListVC.user = appDelegate.userId;
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return NO;
    //    return YES;
}




@end
