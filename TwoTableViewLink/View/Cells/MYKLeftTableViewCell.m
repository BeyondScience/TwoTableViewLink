//
//  MYKLeftTableViewCell.m
//  TwoTableViewLink
//
//  Created by Li Peixin on 2018/4/11.
//  Copyright © 2018年 Li Peixin. All rights reserved.
//

#import "MYKLeftTableViewCell.h"

@implementation MYKLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.contentView.backgroundColor = KLightYellowColor;
        self.lblName.textColor = kOrangeTextColor;
    }else{
        self.contentView.backgroundColor = [UIColor clearColor];
        self.lblName.textColor = [UIColor blackColor];
    }
}

@end
