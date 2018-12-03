//
//  QuesTableViewCell.m
//  EducationDemo
//
//  Created by xianglong on 2018/11/30.
//  Copyright © 2018年 xianglong. All rights reserved.
//

#import "QuesTableViewCell.h"

@implementation QuesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cell
{
    QuesTableViewCell *myCell = [[[NSBundle mainBundle] loadNibNamed:@"QuesTableViewCell" owner:self options:nil] lastObject];
    return myCell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setContent:(QesModel *)qes {
    [self.reviewTime setText: qes.review_time];
    self.quesImage.image = [UIImage imageWithContentsOfFile:qes.ques_img];
//    [self.imageView setImage:[UIImage imageWithContentsOfFile:qes.ques_img]];
    NSLog([NSString stringWithFormat:@"图片路径：%@",qes.ques_img]);
//    [self.isKnow.titleLabel setText:qes.understand];
    [self.isKnow setTitle:qes.understand forState:UIControlStateNormal];
    

}

@end
