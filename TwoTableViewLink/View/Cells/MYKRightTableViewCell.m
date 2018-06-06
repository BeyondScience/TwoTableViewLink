//
//  MYKRightTableViewCell.m
//  TwoTableViewLink
//
//  Created by Li Peixin on 2018/4/11.
//  Copyright © 2018年 Li Peixin. All rights reserved.
//

#import "MYKRightTableViewCell.h"

@implementation MYKRightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkFood:tableViewCell:)]) {
        [self.delegate checkFood:self.imgFood tableViewCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedBtn:tableViewCell:)]) {
        [self.delegate selectedBtn:self.btnSelected tableViewCell:self];
    }
}

@end
