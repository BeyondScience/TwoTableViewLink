//
//  MYKAddressView.m
//  TwoTableViewLink
//
//  Created by Li Peixin on 2018/4/10.
//  Copyright © 2018年 Li Peixin. All rights reserved.
//

#import "MYKAddressView.h"

@implementation MYKAddressView

- (IBAction)chooseAddressAction:(id)sender {
    if (_chooseAction) {
        _chooseAction();
    }
}

- (IBAction)selectAddressAction:(id)sender {
    if (_selectAction) {
        _selectAction();
    }
}

@end
