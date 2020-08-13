//
//  FMWorkViewController.m
//  feima
//
//  Created by fei on 2020/7/29.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMWorkViewController.h"
#import "FMClockInViewController.h"
#import "FMWorkCollectionViewCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "UIView+Extend.h"
#import "FMWorkbenchModel.h"

@interface FMWorkViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UIScrollView       *rootScrollView;
@property (nonatomic, strong) UILabel            *titleLab;
@property (nonatomic, strong) SDCycleScrollView  *cycleScrollView;
@property (nonatomic, strong) UIButton           *toWorkBtn;
@property (nonatomic, strong) UIButton           *offWorkBtn;
@property (nonatomic,strong) UILabel             *workTitleLab;
@property (nonatomic,strong) UICollectionView    *workCollectionView;

@property (nonatomic,strong) NSMutableArray      *workbenchArray;

@end

@implementation FMWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBar = YES;
    
    [self setupView];
    [self loadMenuListData];
}

#pragma mark 状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#pragma mark -- UICollectionViewDataSource and UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.workbenchArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FMWorkCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dict = self.workbenchArray[indexPath.row];
    cell.iconImgView.image = ImageNamed(dict[@"icon"]);
    cell.titleLab.text = dict[@"name"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.workbenchArray[indexPath.row];
    NSString *classStr = [NSString stringWithFormat:@"FM%@ViewController",dict[@"router"]];
    Class aClass = NSClassFromString(classStr);
    BaseViewController *vc = (BaseViewController *)[[aClass alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(60, 80);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 25;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return (kScreen_Width-4*60-40)/3.0;
}

#pragma mark -- Events response
#pragma mark 上班打卡或下班打卡
- (void)workForPauchCardAction:(UIButton *)sender {
    FMClockInViewController *clockInVC = [[FMClockInViewController alloc] init];
    [self.navigationController pushViewController:clockInVC animated:YES];
}

#pragma mark -- Private methods
#pragma mark 获取菜单列表
- (void)loadMenuListData {
    NSArray *arr = @[@{@"icon":@"contacts",@"name":@"通讯录",@"router":@"Address"},@{@"icon":@"customer",@"name":@"客户管理",@"router":@"Customer"},@{@"icon":@"visit",@"name":@"客户分布",@"router":@"CustomerDistributed"},@{@"icon":@"work_path",@"name":@"工作路线",@"router":@"WorkRoute"},@{@"icon":@"work_path",@"name":@"员工分布",@"router":@"Distributed"},@{@"icon":@"intructions",@"name":@"指令",@"router":@"Instruction"},@{@"icon":@"goods",@"name":@"进销存",@"router":@"Invoicing"},@{@"icon":@"employee_manage",@"name":@"员工管理",@"router":@"Employee"},@{@"icon":@"goods_manage",@"name":@"商品管理",@"router":@"Goods"},@{@"icon":@"company_manager",@"name":@"公司管理",@"router":@"Company"},@{@"icon":@"company_manager",@"name":@"报表管理",@"router":@"Report"}];
    
    [self.workbenchArray addObjectsFromArray:arr];
    [self.workCollectionView reloadData];
    
    [self.workCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo((self.workbenchArray.count/4+1)*80+(self.workbenchArray.count/4)*25);
    }];
    
    /*
    [[HttpRequest sharedInstance] getRequestWithUrl:api_menu_list success:^(id responseObject) {
        NSArray *data = responseObject[@"data"];
        NSArray *list = [NSArray yy_modelArrayWithClass:[FMWorkbenchModel class] json:data];
        
    } failure:^(NSString *errorStr) {
        
    }];
     */
}

#pragma mark 界面初始化
- (void)setupView{
    [self.view addSubview:self.rootScrollView];
    [self.rootScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.rootScrollView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(kNavBar_Height);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-30, 33));
    }];
    
    [self.rootScrollView addSubview:self.cycleScrollView];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(22);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-30, 140));
    }];
    
    [self.rootScrollView addSubview:self.toWorkBtn];
    [self.toWorkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(self.cycleScrollView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake((kScreen_Width-45)/2.0, 60));
    }];
    
    [self.rootScrollView addSubview:self.offWorkBtn];
    [self.offWorkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.toWorkBtn.mas_right).offset(15);
        make.top.mas_equalTo(self.cycleScrollView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake((kScreen_Width-45)/2.0, 60));
    }];
    
    [self.rootScrollView addSubview:self.workTitleLab];
    [self.workTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.top.mas_equalTo(self.offWorkBtn.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-40, 22));
    }];
    
    [self.rootScrollView addSubview:self.workCollectionView];
    [self.workCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.workTitleLab.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width, 80*3+3*25));
        make.bottom.mas_equalTo(self.workCollectionView.mas_bottom);
    }];
}

#pragma mark 创建btn
- (UIButton *)setupButtonWithBgColor:(UIColor *)bgColor
                                icon:(NSString *)iconName
                               title:(NSString *)title
                                 tag:(NSInteger)tag{
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = bgColor;
    [btn setImage:ImageNamed(iconName) forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont mediumFontWithSize:18];
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    btn.tag = tag;
    [btn addTarget:self action:@selector(workForPauchCardAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark -- Getters
#pragma mark 根视图
- (UIScrollView *)rootScrollView {
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc] init];
        _rootScrollView.showsHorizontalScrollIndicator = NO;
        _rootScrollView.showsVerticalScrollIndicator = NO;
    }
    return _rootScrollView;
}

#pragma mark 标题
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont mediumFontWithSize:24];
        _titleLab.textColor = [UIColor textBlackColor];
        _titleLab.text = @"王俊凯的工作台";
    }
    return _titleLab;
}

#pragma mark 循环滚动
-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageNamesGroup:@[@"home_banner"]];
        _cycleScrollView.layer.cornerRadius = 10;
        _cycleScrollView.clipsToBounds = YES;
    }
    return _cycleScrollView;
}

#pragma mark 上班打卡
- (UIButton *)toWorkBtn {
    if (!_toWorkBtn) {
        UIColor *bgColor = [UIColor bm_colorGradientChangeWithSize:CGSizeMake((kScreen_Width-45)/2.0, 60) direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHexString:@"#FFCC6A"] endColor:[UIColor colorWithHexString:@"#F9A406"]];
        _toWorkBtn = [self setupButtonWithBgColor:bgColor icon:@"checkIn" title:@"上班打卡" tag:100];
    }
    return _toWorkBtn;
}

#pragma mark 下班打卡
- (UIButton *)offWorkBtn {
    if (!_offWorkBtn) {
        UIColor *bgColor = [UIColor bm_colorGradientChangeWithSize:CGSizeMake((kScreen_Width-45)/2.0, 60) direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHexString:@"#3340EE"] endColor:[UIColor colorWithHexString:@"#6387FE"]];
        _offWorkBtn = [self setupButtonWithBgColor:bgColor icon:@"off_work" title:@"下班打卡" tag:101];
    }
    return _offWorkBtn;
}

#pragma mark 标题
- (UILabel *)workTitleLab {
    if (!_workTitleLab) {
        _workTitleLab = [[UILabel alloc] init];
        _workTitleLab.font = [UIFont mediumFontWithSize:16];
        _workTitleLab.textColor = [UIColor textBlackColor];
        _workTitleLab.text = @"工作台";
    }
    return _workTitleLab;
}

#pragma mark 工作台
- (UICollectionView *)workCollectionView {
    if (!_workCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20); //设置其边界
        _workCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _workCollectionView.scrollEnabled = NO;
        _workCollectionView.backgroundColor = [UIColor whiteColor];
        _workCollectionView.delegate = self;
        _workCollectionView.dataSource = self;
        _workCollectionView.showsVerticalScrollIndicator= NO;
        _workCollectionView.showsHorizontalScrollIndicator = NO;
        [_workCollectionView registerClass:[FMWorkCollectionViewCell class] forCellWithReuseIdentifier:@"FMWorkCollectionViewCell"];
    }
    return _workCollectionView;
}

- (NSMutableArray *)workbenchArray{
    if (!_workbenchArray) {
        _workbenchArray = [[NSMutableArray alloc] init];
    }
    return _workbenchArray;
}

@end
