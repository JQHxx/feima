//
//  FMSumUpViewController.m
//  feima
//
//  Created by fei on 2020/8/23.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMSumUpViewController.h"
#import "FMPhotoCollectionView.h"
#import "FMInstrucationViewModel.h"

@interface FMSumUpViewController ()

@property (nonatomic,strong) UILabel               *titleLabel;
@property (nonatomic,strong) UITextView            *summaryTextView;
@property (nonatomic,strong) UILabel               *photoTitleLabel; //照片
@property (nonatomic,strong) FMPhotoCollectionView *photoView;
@property (nonatomic,strong) UIButton              *publishBtn;

@property (nonatomic,strong) FMInstrucationViewModel *adapter;

@end

@implementation FMSumUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"指令总结";
    
    [self setupUI];
}

#pragma mark -- Event response
#pragma mark 提交
- (void)submitSummaryAction:(UIButton *)sender {
    if (kIsEmptyString(self.summaryTextView.text)) {
        [self.view makeToast:@"总结内容不能为空" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    NSArray *images = [self.photoView getAllImages];
    if (images.count == 0) {
        [self.view makeToast:@"图片不能为空" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    NSString *imagesStr = [images componentsJoinedByString:@","];
    [self.adapter instrucationCompleteWithInstructionRecordId:self.instructionRecordId summary:self.summaryTextView.text images:imagesStr complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(kNavBar_Height+30);
        make.size.mas_equalTo(CGSizeMake(65, 24));
    }];
    
    [self.view addSubview:self.summaryTextView];
    [self.summaryTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(100);
    }];
    
    [self.view addSubview:self.photoTitleLabel];
    [self.photoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.summaryTextView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(240, 24));
    }];
    
    [self.view addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.photoTitleLabel.mas_bottom).offset(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(70);
    }];
    
    [self.view addSubview:self.publishBtn];
    [self.publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.photoView.mas_bottom).offset(30);
        make.left.mas_equalTo(18);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-36, 46));
    }];
}


#pragma mark -- Getters
#pragma mark 名称
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont regularFontWithSize:16];
        _titleLabel.textColor = [UIColor textBlackColor];
        _titleLabel.text = @"内容总结";
    }
    return _titleLabel;
}

#pragma mark 总结
- (UITextView *)summaryTextView {
    if (!_summaryTextView) {
        _summaryTextView = [[UITextView alloc] init];
        _summaryTextView.font = [UIFont regularFontWithSize:16];
        _summaryTextView.textColor = [UIColor textBlackColor];
        _summaryTextView.layer.cornerRadius = 5;
        _summaryTextView.layer.borderColor = [UIColor lineColor].CGColor;
        _summaryTextView.layer.borderWidth = 1.0;
    }
    return _summaryTextView;
}

#pragma mark 照片
- (UILabel *)photoTitleLabel {
    if (!_photoTitleLabel) {
        _photoTitleLabel = [[UILabel alloc] init];
        _photoTitleLabel.font = [UIFont mediumFontWithSize:18];
        _photoTitleLabel.textColor = [UIColor textBlackColor];
        _photoTitleLabel.text = @"添加照片";
    }
    return _photoTitleLabel;
}

#pragma mark 添加照片
- (FMPhotoCollectionView *)photoView {
    if (!_photoView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _photoView = [[FMPhotoCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _photoView.maxImagesCount = 4;
    }
    return _photoView;
}

#pragma mark 提交
- (UIButton *)publishBtn {
    if (!_publishBtn) {
        _publishBtn = [UIButton submitButtonWithFrame:CGRectZero title:@"提交" target:self selector:@selector(submitSummaryAction:)];
    }
    return _publishBtn;
}

- (FMInstrucationViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMInstrucationViewModel alloc] init];
    }
    return _adapter;
}

@end
