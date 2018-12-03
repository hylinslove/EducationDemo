//
//  CaptureViewController.m
//  EducationDemo
//
//  Created by xianglong on 2018/11/28.
//  Copyright © 2018年 xianglong. All rights reserved.
//

#import "CaptureViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SaveViewController.h"

@interface CaptureViewController ()<UIGestureRecognizerDelegate>
- (IBAction)back:(id)sender;
- (IBAction)capture:(id)sender;
- (IBAction)confirm:(id)sender;
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *shutterButton;

@property (weak, nonatomic) IBOutlet UIView *backView;
//AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureSession* session;
//输入设备
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
//照片输出流
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;
//预览图层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
//记录开始的缩放比例
@property(nonatomic,assign)CGFloat beginGestureScale;
//最后的缩放比例
@property(nonatomic,assign)CGFloat effectiveScale;

@property (nonatomic,strong) NSData *imageData;

@end

@implementation CaptureViewController {
    BOOL isUsingFrontFacingCamera;
    BOOL isCompress;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isUsingFrontFacingCamera = NO;
    isCompress = YES;
    self.tabBarItem.title = @"拍题";
    self.tabBarController.title = @"拍题";
    [self initCaptureSession];
    [self setUpGesture];
    self.effectiveScale = self.beginGestureScale = 1.0f;
    
}

-(void)initCaptureSession{
    self.session = [[AVCaptureSession alloc]init];
    NSError *error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    CGSize size = rect.size;
    
    CGFloat width = size.width;
    
    CGFloat height = size.height;
    self.previewLayer.frame = CGRectMake(0, 0,width, height - 130);
    self.backView.layer.masksToBounds = YES;
    [self.backView.layer addSublayer:self.previewLayer];
    
    
}

- (IBAction)capture:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyMMdd_hhmmss"];
    
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"yyy-MM-dd hh:mm:ss"];
    
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput        connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        //停止预览
        [self stopSession];
        self.confirmButton.hidden = false;
        self.cancelButton.hidden = false;
        self.shutterButton.hidden = true;
        
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
//        UIImage *selectedImg = [UIImage imageWithData:jpegData];
        
        _imageData = jpegData;
        
        
        //使用hcimage保存图片和位置信息
 
        //保存图片至本地文件夹
//        hcImage.date = [NSDate date];
//        NSData *data;
//        if (isCompress) {
//            data = UIImageJPEGRepresentation(selectedImg, 0.2);
//        }else{
//            data = UIImageJPEGRepresentation(selectedImg, 1);
//        }
        
//        NSMutableString *outPath = [NSMutableString string];
//        NSString *dirDoc = [self dirDoc];
//        NSString *path = [dirDoc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@@%@@%@@%@@FWJ%@",self.taskID,self.taskID,[dateFormatter stringFromDate:hcImage.date],hcImage.longitude,hcImage.latitude,hcImage.fxj]];
//        [outPath appendString:path];
//        if(_photoType == 1) {
//
//            [outPath appendString:@"@zuozhen"];
//        }
//        [outPath appendString:@".jpg"];
        
//        if ([data writeToFile:outPath atomically:YES] == YES ) {
//            NSLog(@"保存路径：----------------——%@",outPath);
//        } else {
//            NSLog(@"保存路径：----------------——保存失败");
//        }
//
//        UIImage *image = [UIImage imageWithData:data];
//        _snailImage.image = image;
        
//        [self startSession];
    }];
    
}

//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.backView];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        
        
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        
        CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
        
    }
    
}

//相机聚焦
- (void)focusAtPoint{
    CGPoint point = CGPointMake(0.5f, 0.5f);
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device.isFocusPointOfInterestSupported &&[device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            NSLog(@"--------聚焦--------------");
            device.focusPointOfInterest = point;
            device.focusMode = AVCaptureFocusModeAutoFocus;
            [device unlockForConfiguration];
        }
        else{
            NSLog(@"--------聚焦--------------%@",error);
        }
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

#pragma 创建手势
- (void)setUpGesture{
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusAtPoint)];
    
    
    tap.delegate = self;
    
    [self.backView addGestureRecognizer:pinch];
    [self.backView addGestureRecognizer:tap];
}
//设备方向
- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = true;
    self.navigationController.navigationBar.hidden = true;
    self.confirmButton.hidden = true;
    self.cancelButton.hidden = true;
    self.shutterButton.hidden = false;
    
    _imageData = nil;
    
    if (self.session) {
        
        [self.session startRunning];
    }
    
    if(_is_saved !=nil && [_is_saved isEqualToString:@"1"]) {
        _is_saved = @"0";
        self.tabBarController.selectedIndex = 0;
        self.tabBarController.tabBar.hidden = false;
        self.navigationController.navigationBar.hidden = false;
    }
   
}
-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = true;
    self.navigationController.navigationBar.hidden = true;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    _ques_id = nil;
    if (self.session) {
        
        [self.session stopRunning];
    }
}
//添加图片水印
-(UIImage *)addText:(UIImage *)img text:(NSString *)text1
{
    //get image width and height
    NSString* mark = text1;
    int w = img.size.width;
    int h = img.size.height;
    
    //    UIGraphicsBeginImageContext(img.size);
    UIGraphicsBeginImageContextWithOptions(img.size, YES, 1);
    [img drawInRect:CGRectMake(0,0, w, h)];
    
    NSDictionary *attr = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:64],  //设置字体
                           NSForegroundColorAttributeName : [UIColor redColor]   //设置字体颜色
                           };
    
    [mark drawInRect:CGRectMake(20,64,w,500) withAttributes:attr];
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:UIImageJPEGRepresentation(aimg, 0.8)];
}
//开始预览
- (void)startSession{
    
    if (![self.session isRunning]) {
        
        [self.session startRunning];
    }
}
//停止预览
- (void)stopSession{
    
    if ([self.session isRunning]) {
        
        [self.session stopRunning];
    }
}
//获取Documents目录
-(NSString *)dirDoc{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

//获取时间戳
-(NSString *)getCurrentTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];

    return timeSp;
    
}

-(NSString*)getCurrentDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.tabBarController.tabBar.hidden = false;
    self.navigationController.navigationBar.hidden = false;
    SaveViewController *saveVC = segue.destinationViewController;
    
    saveVC.segue = segue;
    if (_imageData == nil) {
        NSLog(@"------------------图片为空");
    } else{
         NSLog(@"------------------图片不为空");
        saveVC.ques_id = _ques_id;
    }
    [super prepareForSegue:segue sender:sender];
}
- (IBAction)back:(id)sender {
    self.tabBarController.selectedIndex = 0;
    self.tabBarController.tabBar.hidden = false;
    self.navigationController.navigationBar.hidden = false;
}

- (IBAction)confirm:(id)sender {
    if (_ques_id==nil) {
        //新建错题
        _ques_id = [self getCurrentTime];
        NSMutableString *outPathQues = [NSMutableString string];
        
        NSMutableString *outPathAns = [NSMutableString string];
        
        NSString *rootPath = [self dirDoc];
        NSString *qesPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/ques/",_ques_id]];
         NSString *ansPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/ans/",_ques_id]];
        [outPathQues appendString:qesPath];
        [outPathAns appendString:ansPath];
        
        NSFileManager *fm = [[NSFileManager alloc]init];
        [fm createDirectoryAtPath:outPathAns withIntermediateDirectories:YES attributes:nil error:nil];
        [fm createDirectoryAtPath:outPathQues withIntermediateDirectories:YES attributes:nil error:nil];
        
        [outPathAns appendString:[NSString stringWithFormat:@"/%@.jpg",[self getCurrentDate]]];
        [outPathQues appendString:[NSString stringWithFormat:@"/%@.jpg",[self getCurrentDate]]];
        [_imageData writeToFile:outPathAns atomically:YES];
        
        
        
        if ([_imageData writeToFile:outPathQues atomically:YES] == YES ) {
            NSLog(@"保存路径：----------------——%@",outPathQues);
        } else {
            NSLog(@"保存路径：----------------——保存失败");
        }
        [self performSegueWithIdentifier:@"newQes" sender:self];
    } else {
        if(_is_ques) {
            NSMutableString *outPathQues = [NSMutableString string];
            NSString *rootPath = [self dirDoc];
            NSString *qesPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/ques/",_ques_id]];
            [outPathQues appendString:qesPath];
            [outPathQues appendString:[NSString stringWithFormat:@"%@.jpg",[self getCurrentDate]]];
            if ([_imageData writeToFile:outPathQues atomically:YES] == YES ) {
                NSLog(@"保存路径：----------------——%@",outPathQues);
            } else {
                NSLog(@"保存路径：----------------——保存失败");
            }
        } else {
            NSMutableString *outPathAns = [NSMutableString string];
            NSString *rootPath = [self dirDoc];
            NSString *ansPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/ans/",_ques_id]];
            [outPathAns appendString:ansPath];
            [outPathAns appendString:[NSString stringWithFormat:@"%@.jpg",[self getCurrentDate]]];
           
            if ([_imageData writeToFile:outPathAns atomically:YES] == YES ) {
                NSLog(@"保存路径：----------------——%@",outPathAns);
            } else {
                NSLog(@"保存路径：----------------——保存失败");
            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)cancel:(id)sender {
    _imageData = nil;
    [self startSession];
    self.confirmButton.hidden = true;
    self.cancelButton.hidden = true;
    self.shutterButton.hidden = false;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return NO;
    //    return YES;
}

@end
