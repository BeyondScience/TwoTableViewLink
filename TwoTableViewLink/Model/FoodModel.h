//
//  FoodModel.h
//  TwoTableViewLink
//
//  Created by Li Peixin on 2018/4/11.
//  Copyright © 2018年 Li Peixin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodModel : NSObject

@property (nonatomic, copy) NSString *catgroyid;
@property (nonatomic, copy) NSString *vegname;          // 菜品名字
@property (nonatomic, strong) NSMutableArray *farmvegetable;   // 蔬菜列表

@end
