//
//  FMGoodsQuantityView.m
//  feima
//
//  Created by fei on 2020/8/31.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMGoodsQuantityView.h"

@interface FMGoodsQuantityView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton     *subtractBtn;
@property (nonatomic, strong) UITextField  *quantityText;
@property (nonatomic, strong) UIButton     *addBtn;


@end

@implementation FMGoodsQuantityView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.subtractBtn];
        [self addSubview:self.quantityText];
        [self addSubview:self.addBtn];
    }
    return self;
}

#pragma mark -- event response
#pragma mark 数量加减
- (void)handleQuantityAction:(UIButton *)sender {
    NSInteger num = [self.quantityText.text integerValue];
    if (sender.tag == 100) { //减
        if (num < 1) {
            return;
        }
        num -- ;
    } else {
        num ++ ;
    }
    self.quantityText.text = [NSString stringWithFormat:@"%ld",num];
    if (self.myBlock) {
        self.myBlock(num);
    }
}

#pragma mark 监听输入
- (void)didChangedTextField:(UITextField *)textField {
    MyLog(@"text:%@",textField.text);
    NSInteger num = [textField.text integerValue];
    textField.text = [NSString stringWithFormat:@"%ld",num];
    if (self.myBlock) {
        self.myBlock(num);
    }
}

#pragma mark 设置数量
- (void)setQuatity:(NSInteger)quatity {
    _quatity = quatity;
    self.quantityText.text = [NSString stringWithFormat:@"%ld",quatity];
}

#pragma mark -- Getters
#pragma mark 减
- (UIButton *)subtractBtn {
    if (!_subtractBtn) {
        _subtractBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
        [_subtractBtn setTitle:@"-" forState:UIControlStateNormal];
        [_subtractBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
        _subtractBtn.titleLabel.font = [UIFont mediumFontWithSize:20];
        _subtractBtn.layer.cornerRadius = 15;
        _subtractBtn.layer.borderWidth = 2;
        _subtractBtn.layer.borderColor = [UIColor textBlackColor].CGColor;
        _subtractBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
        [_subtractBtn addTarget:self action:@selector(handleQuantityAction:) forControlEvents:UIControlEventTouchUpInside];
        _subtractBtn.tag = 100;
    }
    return _subtractBtn;
}

#pragma mark 数量
- (UITextField *)quantityText {
    if (!_quantityText) {
        _quantityText = [[UITextField alloc] initWithFrame:CGRectMake(self.subtractBtn.right, 5, 60, 30)];
        _quantityText.textColor = [UIColor textBlackColor];
        _quantityText.textAlignment = NSTextAlignmentCenter;
        _quantityText.font = [UIFont regularFontWithSize:16];
        _quantityText.keyboardType = UIKeyboardTypeNumberPad;
        _quantityText.text = @"0";
        [_quantityText addTarget:self action:@selector(didChangedTextField:) forControlEvents:UIControlEventEditingChanged];
    }
    return _quantityText;
}

#pragma mark 加
- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.quantityText.right, 5, 30, 30)];
        [_addBtn setTitle:@"+" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addBtn.titleLabel.font = [UIFont mediumFontWithSize:20];
        _addBtn.layer.cornerRadius = 15;
        _addBtn.backgroundColor = [UIColor systemColor];
        _addBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
        [_addBtn addTarget:self action:@selector(handleQuantityAction:) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.tag = 101;
    }
    return _addBtn;
}


@end
