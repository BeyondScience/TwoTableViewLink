//
//  MYKAddressView.h
//  TwoTableViewLink
//
//  Created by Li Peixin on 2018/4/10.
//  Copyright © 2018年 Li Peixin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYKAddressView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;

@property (nonatomic, copy) dispatch_block_t chooseAction;//点击选择地址跳转
@property (nonatomic, copy) dispatch_block_t selectAction;//最左边的按钮

@end
