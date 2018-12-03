//
//  ImgCollectionViewCell.h
//  EducationDemo
//
//  Created by xianglong on 2018/12/1.
//  Copyright © 2018年 xianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deleBtn;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) id asset;
@end
