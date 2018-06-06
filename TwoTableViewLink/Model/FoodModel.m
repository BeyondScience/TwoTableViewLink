//
//  FoodModel.m
//  TwoTableViewLink
//
//  Created by Li Peixin on 2018/4/11.
//  Copyright © 2018年 Li Peixin. All rights reserved.
//

#import "FoodModel.h"
#import "MJExtension.h"
#import "MYKVegatableModel.h"

@implementation FoodModel
/* 实现该方法，说明数组中存储的模型数据类型 */
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"farmvegetable" : @"MYKVegatableModel"};
}
@end
