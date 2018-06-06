//
//  MYKRightTableViewCell.h
//  TwoTableViewLink
//
//  Created by Li Peixin on 2018/4/11.
//  Copyright © 2018年 Li Peixin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FoodModel;
@class MYKRightTableViewCell;

@protocol MYKRightTableViewCellDelegate <NSObject>

@optional
//选择右边的选择按钮
-(void)selectedBtn:(UIButton *)btn tableViewCell:(MYKRightTableViewCell *)cell;

//点击图片
-(void)checkFood:(UIImageView *)sender tableViewCell:(MYKRightTableViewCell *)cell;

@end

@interface MYKRightTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgFood;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblWeight;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;

@property (weak, nonatomic) IBOutlet UIButton *btnSelected;

@property (nonatomic) FoodModel *foodModel;//蔬菜模型

@property (nonatomic, weak) id <MYKRightTableViewCellDelegate> delegate;


@end
