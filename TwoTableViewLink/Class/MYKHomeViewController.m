//
//  MYKHomeViewController.m
//  TwoTableViewLink
//
//  Created by Li Peixin on 2018/4/10.
//  Copyright © 2018年 Li Peixin. All rights reserved.
//

#import "MYKHomeViewController.h"
//第三方框架
#import "masonry.h"
#import "MJExtension.h"

#import "MYKAddressView.h"
#import "MYKSendTimesView.h"
#import "MYKLeftTableViewCell.h"
#import "MYKRightTableViewCell.h"
#import "FoodModel.h"
#import "MYKVegatableModel.h"

#import "NextViewController.h"

@interface MYKHomeViewController ()<UITableViewDelegate, UITableViewDataSource, MYKRightTableViewCellDelegate>{
    MYKAddressView *addressView;
    MYKSendTimesView *sendView;
}
@property (nonatomic) UITableView *leftTableView;
@property (nonatomic) UITableView *rightTableView;

@property (nonatomic, assign) BOOL isRepeatRolling;  // 是否重复滚动
@property (nonatomic) NSIndexPath *lastIndexPath;//选中的indexpath
@property (nonatomic) NSMutableArray *arrData;

@property (nonatomic) NSMutableArray *arrSelected;//选中的cell
@end

#define LeftTable_Width 100  // 左侧tableView的宽度
#define Address_Height  80   // 地址视图高度
#define SendView_Height 40   // 派送次数视图高度

@implementation MYKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isRepeatRolling = NO;
    self.navigationItem.title = @"TableView联动";
    _arrData = [NSMutableArray array];
    _arrSelected = [NSMutableArray array];
    [self loadData];
    [self setUpUI];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark -- loadUI
-(void)setUpUI{
    //适配iOS版本
    if (@available(iOS 11.0, *)) {
        self.leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.rightTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    //选择地址View
    addressView = [[[NSBundle mainBundle] loadNibNamed:@"MYKAddressView" owner:self options:nil] firstObject];
    [addressView setChooseAction:^{
        NSLog(@"切换地址");
    }];
    [addressView setSelectAction:^{
        NSLog(@"选择地址");
    }];
    [self.view addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusH + kNaviH);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(Address_Height);
    }];
    //剩余配送次数View
    sendView = [[[NSBundle mainBundle] loadNibNamed:@"MYKSendTimesView" owner:self options:nil] firstObject];
    [self.view addSubview:sendView];
    [sendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addressView.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(SendView_Height);
    }];
    
    float tabY = Address_Height + kStatusH + kNaviH + SendView_Height;
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tabY, LeftTable_Width, kScreenH - tabY - 50) style:UITableViewStylePlain];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.showsVerticalScrollIndicator = NO;
    _leftTableView.estimatedRowHeight = 0;
    _leftTableView.backgroundColor = KLightYellowColor;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_leftTableView registerNib:[UINib nibWithNibName:@"MYKLeftTableViewCell" bundle:nil] forCellReuseIdentifier:kLeftCellID];
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.view addSubview:_leftTableView];
    
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(LeftTable_Width, tabY, kScreenW - LeftTable_Width, kScreenH - tabY - 50) style:UITableViewStyleGrouped];
    _rightTableView.backgroundColor = [UIColor clearColor];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.showsVerticalScrollIndicator = NO;
    _rightTableView.estimatedRowHeight = 0;
    _rightTableView.estimatedSectionFooterHeight = 0;
    _rightTableView.estimatedSectionHeaderHeight = 0;
    [_rightTableView registerNib:[UINib nibWithNibName:@"MYKRightTableViewCell" bundle:nil] forCellReuseIdentifier:kRightCellID];
    [self.view addSubview:_rightTableView];
}

-(void)loadData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"vegetable" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *proprietaryArray = [FoodModel mj_objectArrayWithKeyValuesArray:dict[@"farm_vegetable"]];
    [_arrData addObjectsFromArray:proprietaryArray];
}

#pragma mark -- UITableView Delegate && DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _leftTableView) {
        return 1;
    }else{
        return _arrData.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return self.arrData.count;
    }else{
        FoodModel *model = _arrData[section];
        return model.farmvegetable.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _leftTableView) {
        MYKLeftTableViewCell *leftCell = [tableView dequeueReusableCellWithIdentifier:kLeftCellID];
        FoodModel *model = _arrData[indexPath.row];
        leftCell.lblName.text = model.vegname;
        leftCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath == _lastIndexPath) {
            [_leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        return leftCell;
    }else{
        FoodModel *model = _arrData[indexPath.section];
        MYKRightTableViewCell *rightCell = [tableView dequeueReusableCellWithIdentifier:kRightCellID];
        rightCell.selectionStyle = UITableViewCellSelectionStyleNone;
        rightCell.lblName.text = model.vegname;
        rightCell.delegate = self;
        for (NSIndexPath *selectIndex in _arrSelected) {
            if (indexPath == selectIndex) {
                rightCell.btnSelected.selected = YES;
                [rightCell.btnSelected setImage:[UIImage imageNamed:@"zhifu_weixz_selected"] forState:UIControlStateSelected];
            }
        }
        return rightCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
        return 50;
    }else{
        return 100;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return 0;
    }else{
        return 30;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return CGFLOAT_MIN;
    } else {
        return CGFLOAT_MIN;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return nil;
    }else{
        return @"我的菜";
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return nil;
    }else{
        FoodModel *model = _arrData[section];
        UIView *headView = [UIView new];
        headView.backgroundColor = RGBA(254.f, 230.f, 206.f, 1);
        UILabel *headLabel = [UILabel new];
        headLabel.font = kkFont16;
        headLabel.text = [NSString stringWithFormat:@"%@",model.vegname];
        [headView addSubview:headLabel];

        [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.equalTo(headView);
        }];

        return headView;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
        
        MYKLeftTableViewCell *leftCell = (MYKLeftTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        leftCell.selected = YES;
        self.lastIndexPath = indexPath;
        _isRepeatRolling = YES;
        [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else{
        [self.navigationController pushViewController:[NextViewController new] animated:YES];
    }
}

#pragma mark ---UIScrollViewDelegate
// scrollView 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isRepeatRolling = NO;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self viewUpAnimationWihtScrollView:scrollView];
    if (scrollView == self.rightTableView) {
        //取出当前显示的最顶部的cell的indexpath
        //当前tableview页面可见的分区属性 indexPathsForVisibleRows
        // 取出显示在 视图 且最靠上 的 cell 的 indexPath
        // 判断tableView是否滑动到最底部
        CGFloat height = scrollView.frame.size.height;
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
        
        if (bottomOffset <= height) {//滑动到底部了
            NSIndexPath *bottomIndexPath = [[self.rightTableView indexPathsForVisibleRows] lastObject];
            NSIndexPath *moveIndexPath = [NSIndexPath indexPathForRow:bottomIndexPath.section inSection:0];
            if (self.isRepeatRolling == NO) { // 防止重复滚动
                [self.leftTableView selectRowAtIndexPath:moveIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            }
        } else {//没有滑动到底部
            NSIndexPath *topIndexPath = [[self.rightTableView indexPathsForVisibleRows] firstObject];
            NSIndexPath *moveIndexPath = [NSIndexPath indexPathForRow:topIndexPath.section inSection:0];
            if (self.isRepeatRolling == NO) { // 防止重复滚动
                [self.leftTableView selectRowAtIndexPath:moveIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            }
        }
    }else{
        return;
    }
}

#pragma mark - 滑动视图上移动画
- (void)viewUpAnimationWihtScrollView:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y > 0) {
        [addressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(-Address_Height+NAVIGATION_HEIGHT);
            make.height.mas_equalTo(Address_Height);
        }];
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
            self.rightTableView.frame = CGRectMake(LeftTable_Width, SendView_Height + NAVIGATION_HEIGHT, kScreenWidth - LeftTable_Width, kScreenHeight - NAVIGATION_HEIGHT - 50 - SendView_Height);
            self.leftTableView.frame = CGRectMake(0,  SendView_Height + NAVIGATION_HEIGHT, LeftTable_Width, kScreenHeight - NAVIGATION_HEIGHT - 50 - SendView_Height);
        } completion:^(BOOL finished) {
            nil;
        }];
    } else {
        [addressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(NAVIGATION_HEIGHT);
            make.height.mas_equalTo(Address_Height);
        }];
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
            self.rightTableView.frame = CGRectMake(LeftTable_Width, Address_Height + SendView_Height+NAVIGATION_HEIGHT, kScreenWidth - LeftTable_Width, kScreenHeight - NAVIGATION_HEIGHT - 50 - Address_Height - SendView_Height);
            self.leftTableView.frame = CGRectMake(0, Address_Height + SendView_Height + NAVIGATION_HEIGHT, LeftTable_Width, kScreenHeight - NAVIGATION_HEIGHT - 50 - Address_Height - SendView_Height);
        } completion:^(BOOL finished) {
            nil;
        }];
    }
}

#pragma mark -- MYKRightTableViewCellDelegate
-(void)selectedBtn:(UIButton *)btn tableViewCell:(MYKRightTableViewCell *)cell{
    btn.selected = !btn.selected;
    [btn setImage:[UIImage imageNamed:@"zhifu_weixz_selected"] forState:UIControlStateSelected];
    NSIndexPath *indexPath = [_rightTableView indexPathForCell:cell];
    [self.arrSelected addObject:indexPath];
}

-(void)checkFood:(UIImageView *)sender tableViewCell:(MYKRightTableViewCell *)cell{
    NSIndexPath *indexPath = [_rightTableView indexPathForCell:cell];
    NSLog(@"cell图片被点击  %@",indexPath);
}

@end

















