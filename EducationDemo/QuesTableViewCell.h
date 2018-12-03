//
//  QuesTableViewCell.h
//  EducationDemo
//
//  Created by xianglong on 2018/11/30.
//  Copyright © 2018年 xianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QesModel.h"

@interface QuesTableViewCell : UITableViewCell
+(instancetype)cell;
-(void) setContent:(QesModel *) qes;
@property (weak, nonatomic) IBOutlet UIButton *isKnow;
@property (weak, nonatomic) IBOutlet UIImageView *quesImage;
@property (weak, nonatomic) IBOutlet UILabel *reviewTime;

@end
