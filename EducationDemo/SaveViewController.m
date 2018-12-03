//
//  SaveViewController.m
//  EducationDemo
//
//  Created by xianglong on 2018/11/30.
//  Copyright © 2018年 xianglong. All rights reserved.
//

#import "SaveViewController.h"
#import "UIColor+ColorChange.h"

#import "ImgCollectionViewCell.h"
#import "CaptureViewController.h"
#import "SectionHeader.h"
#import "AppDelegate.h"
#import "DBManager.h"
#import "QesModel.h"

@interface SaveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *quesImgCollection;
@property (weak, nonatomic) IBOutlet UITextView *fromText;
@property (weak, nonatomic) IBOutlet UITextView *tipText;
- (IBAction)selectClass:(UIButton *)sender;
- (IBAction)selectUnderstand:(UIButton *)sender;
- (IBAction)save:(id)sender;

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSMutableArray *quesImages;
@property (strong, nonatomic) NSMutableArray *answerImages;


@property (assign, nonatomic) NSInteger cellSection;

@property (assign, nonatomic) BOOL isSelectOriginalPhoto;




@end

@implementation SaveViewController {
    int width;
    int height;
    UIButton *lastClassButton;
    UIButton *lastUndersButton;
    
    NSString *selectClass;
    NSString *selectUnderstand;
    
    NSString *quesImgPath;
    NSString *ansImgPath;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    width = screenFrame.size.width;
    height = screenFrame.size.height;
    
    _quesImages = [NSMutableArray array];
    _answerImages = [NSMutableArray array];
    
    _fromText.layer.backgroundColor = [UIColor colorwithHexString:@"ededed"].CGColor;
    _fromText.layer.borderWidth = 1;
    _tipText.layer.backgroundColor = [UIColor colorwithHexString:@"ededed"].CGColor;
    _tipText.layer.borderWidth = 1;

    _quesImgCollection.delegate = self;
    _quesImgCollection.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"ImgCollectionViewCell" bundle: [NSBundle mainBundle]];
    [self.quesImgCollection registerNib:nib forCellWithReuseIdentifier:@"ImgCell"];
//    [self.quesImgCollection registerClass:[ImgPickCollectionViewCell class] forCellWithReuseIdentifier:@"ImgCell"];
    [self loadData];
    
    
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

-(void) loadData {
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _userId = appDelegate.userId;
    NSLog([NSString stringWithFormat:@"错题 id ：%@",_ques_id]);
    NSLog(@"************初始化多媒体文件***********");
    NSString *dirDoc = [self dirDoc];
    NSString *mediaPath = [dirDoc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/ques",_ques_id]];
    
    NSArray *fileList = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:mediaPath error:nil];
    
    for(NSString *fileName in fileList) {
        [_quesImages addObject:[mediaPath stringByAppendingPathComponent:fileName]];
        
        NSLog(@"file name：------------------- %@",fileName);
    }
    
    mediaPath = [dirDoc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/ans",_ques_id]];
    fileList = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:mediaPath error:nil];
    for(NSString *fileName in fileList) {
        [_answerImages addObject:[mediaPath stringByAppendingPathComponent:fileName]];
        NSLog(@"file name：------------------- %@",fileName);
    }
    if(_quesImages.count>0) {
        quesImgPath = _quesImages[0];
    } else{
        quesImgPath = @"";
    }
    if(_answerImages.count>0) {
        ansImgPath = _answerImages[0];
    } else{
        ansImgPath = @"";
    }
    
    [_quesImgCollection reloadData];
    
}

- (IBAction)selectClass:(UIButton *)sender {
    selectClass = sender.currentTitle;
    sender.backgroundColor = [UIColor colorwithHexString:@"ff0000"];
    [sender setTitleColor:[UIColor colorwithHexString:@"ffffff"] forState:UIControlStateDisabled];
    [sender setEnabled:false];
    
    if(lastClassButton!= nil) {
        lastClassButton.backgroundColor = [UIColor colorwithHexString:@"E1E1E1"];
        [lastClassButton setEnabled:true];
    }
    lastClassButton = sender;
    
}

- (IBAction)selectUnderstand:(UIButton *)sender {
    selectUnderstand = sender.currentTitle;
    sender.backgroundColor = [UIColor colorwithHexString:@"ff0000"];
    [sender setTitleColor:[UIColor colorwithHexString:@"ffffff"] forState:UIControlStateDisabled];
    [sender setEnabled:false];
    
    if(lastUndersButton!= nil) {
        lastUndersButton.backgroundColor = [UIColor colorwithHexString:@"E1E1E1"];
        [lastUndersButton setEnabled:true];
    }
    lastUndersButton = sender;
}

//保存错题
- (IBAction)save:(id)sender {
    QesModel *quesModel = [[QesModel alloc]init];
    
    quesModel.user= _userId;
    quesModel.ques_id= _ques_id;
    quesModel.ques_class= selectClass;
    quesModel.from= _fromText.text;
    
    quesModel.review_time= @"0";
    quesModel.understand= selectUnderstand;
    quesModel.tip= _tipText.text;
    quesModel.ans_img= ansImgPath;
    quesModel.ques_img= quesImgPath;
    quesModel.date= @"";

  
    DBManager *manager = [DBManager sharedManger];
    [manager insertQues:quesModel];
    
    // 1.弹框提醒
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存成功！" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        // 2.跳转到登录界面
        CaptureViewController *captureVC =  _segue.sourceViewController;
        captureVC.is_saved = @"1";
        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    SectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        header.titleLabel.text = @"题干";
    }else if (indexPath.section == 1){
        header.titleLabel.text = @"答案/原图:";
    }
    
    return header;
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ImgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImgCell" forIndexPath:indexPath];
    cell.imageView.image = nil;//防止cell重用问题

    //section 1  题干图片
    if (indexPath.section == 0) {
        if (indexPath.row == _quesImages.count) {
            cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn"];
            cell.deleBtn.hidden = YES;
        }else{
            cell.imageView.image = [UIImage imageWithContentsOfFile:_quesImages[indexPath.row]] ;
        }
        
    //section 1  答案图片
    }else if(indexPath.section == 1){
        if (indexPath.row == _answerImages.count) {
            cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn"];
            cell.deleBtn.hidden = YES;
        }else{
            cell.imageView.image = [UIImage imageWithContentsOfFile:_answerImages[indexPath.row]] ;
        }
    }
   

    cell.deleBtn.tag = indexPath.row*100+indexPath.section;
    [cell.deleBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return _quesImages.count+1;
    }else {
        return _answerImages.count+1;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((width-20)/4, (width)/4-5);
}



#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);//（上、左、下、右）
}


#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}






//CollectionCell中点击叉
- (void)deleteBtnClik:(UIButton *)sender {
    NSLog(@"delete！");
}

//获取Documents目录
-(NSString *)dirDoc{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}


@end
