//
//  FMInstrucationTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMInstrucationTableViewCell.h"
#import "FMInstrucationModel.h"

@interface FMInstrucationTableViewCell ()

@property (nonatomic,strong) UIView      *rootView;
@property (nonatomic,strong) UIImageView *headImgView;
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UILabel     *timeLabel;
@property (nonatomic,strong) UILabel     *contentLabel;
@property (nonatomic,strong) UILabel     *stateLabel;
@property (nonatomic,strong) UILabel     *expireTimeLabel;
@property (nonatomic,strong) UILabel     *handleLabel;

@end

@implementation FMInstrucationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [self setupUI];
    }
    return self;
}

#pragma mark 填充数据
- (void)fillContentWithData:(FMInstrucationModel *)model type:(NSInteger)type {
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage ctPlaceholderImage]];
    self.nameLabel.text = type == 0 ? model.fromEmployeeName : model.employeeName;
    self.timeLabel.text = [[FeimaManager sharedFeimaManager] timeWithTimeInterval:model.createTime format:@"yyyy.MM.dd HH:mm"];
    self.contentLabel.text = [NSString stringWithFormat:@"指令内容：%@",model.content];
    self.stateLabel.text = model.statusName;
    self.stateLabel.hidden = type == 1 ;
    NSString *expTime = [[FeimaManager sharedFeimaManager] timeWithTimeInterval:model.endTime format:@"yyyy.MM.dd HH:mm"];
    self.expireTimeLabel.text = [NSString stringWithFormat:@"截止期限: %@",expTime];
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for (FMEmployeeModel *eModel in model.employees) {
        [names addObject:eModel.name];
    }
    self.handleLabel.text = [NSString stringWithFormat:@"执行人：%@",[names componentsJoinedByString:@" "]];
}

#pragma mark -- Private methods
- (void)setupUI {
    [self.contentView addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(8);
        make.top.mas_equalTo(16);
        make.right.mas_equalTo(-7);
        make.height.mas_greaterThanOrEqualTo(110);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [self.rootView addSubview:self.headImgView];
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(42, 42));
    }];
    
    [self.rootView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImgView.mas_right).offset(12);
        make.top.mas_equalTo(self.headImgView.mas_top);
        make.height.mas_equalTo(22);
        make.width.mas_greaterThanOrEqualTo(20);
    }];
    
    [self.rootView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(10);
        make.bottom.mas_equalTo(self.nameLabel.mas_bottom);
        make.height.mas_equalTo(22);
        make.width.mas_greaterThanOrEqualTo(110);
    }];
    
    [self.rootView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(4);
        make.height.mas_greaterThanOrEqualTo(22);
    }];
    
    [self.rootView addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.nameLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    
    [self.rootView addSubview:self.expireTimeLabel];
    [self.expireTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(4);
        make.height.mas_equalTo(17);
        make.width.mas_greaterThanOrEqualTo(20);
    }];
    
    [self.rootView addSubview:self.handleLabel];
    [self.handleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.expireTimeLabel.mas_bottom).offset(4);
        make.right.mas_equalTo(self.rootView.mas_right).offset(-10);
        make.height.mas_greaterThanOrEqualTo(17);
        make.bottom.mas_equalTo(self.rootView.mas_bottom).offset(-10);
    }];
    
}

#pragma mark -- Getters
#pragma mark root
- (UIView *)rootView {
    if (!_rootView) {
        _rootView = [[UIView alloc] init];
        _rootView.backgroundColor = [UIColor whiteColor];
        _rootView.layer.cornerRadius = 4;
        _rootView.clipsToBounds = YES;
    }
    return _rootView;
}

#pragma mark 头像
-(UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.layer.cornerRadius = 21;
        _headImgView.layer.masksToBounds = YES;
    }
    return _headImgView;
}

#pragma mark 用户名
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont mediumFontWithSize:16];
        _nameLabel.textColor = [UIColor systemColor];
    }
    return _nameLabel;
}

#pragma mark 时间
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont regularFontWithSize:12];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#747474"];
    }
    return _timeLabel;
}

#pragma mark 内容
-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont mediumFontWithSize:12];
        _contentLabel.textColor = [UIColor textBlackColor];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

#pragma mark 状态
-(UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont regularFontWithSize:12];
        _stateLabel.textColor = [UIColor systemColor];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _stateLabel;
}

#pragma mark 截止时间
-(UILabel *)expireTimeLabel{
    if (!_expireTimeLabel) {
        _expireTimeLabel = [[UILabel alloc] init];
        _expireTimeLabel.font = [UIFont regularFontWithSize:12];
        _expireTimeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _expireTimeLabel;
}

#pragma mark 执行人
-(UILabel *)handleLabel{
    if (!_handleLabel) {
        _handleLabel = [[UILabel alloc] init];
        _handleLabel.font = [UIFont regularFontWithSize:12];
        _handleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _handleLabel.numberOfLines = 0;
    }
    return _handleLabel;
}

@end
