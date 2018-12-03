//
//  ClassCollectionViewCell.h
//  EducationDemo
//
//  Created by xianglong on 2018/11/28.
//  Copyright © 2018年 xianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon_class;
@property (weak, nonatomic) IBOutlet UILabel *name_class;
@property (weak, nonatomic) IBOutlet UILabel *count_class;

@end
