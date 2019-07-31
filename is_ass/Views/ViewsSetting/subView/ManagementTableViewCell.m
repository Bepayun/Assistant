//
//  ManagementTableViewCell.m
//  is_ass
//
//  Created by Bepa  on 2017/9/15.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "ManagementTableViewCell.h"

@implementation ManagementTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createViews];
    }
    return self;
}
- (void)createViews {
    _accountNamelabel = [[UILabel alloc] init];
    [self.contentView addSubview:_accountNamelabel];
    _accountNamelabel.text = @"";
    _accountNamelabel.textColor = RGB(18, 150, 219);
    _accountNamelabel.textAlignment = NSTextAlignmentLeft;
    _accountNamelabel.font = [UIFont systemFontOfSize:16.0f];
    //
    _nicknameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_nicknameLabel];
    _nicknameLabel.text = @"";
    _nicknameLabel.textColor = RGB(18, 150, 219);
    _nicknameLabel.textAlignment = NSTextAlignmentLeft;
    _nicknameLabel.font = [UIFont systemFontOfSize:16.0f];
    //
    _deleteBtn = [[UIButton alloc] init];
    //_deleteBtn.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_deleteBtn];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_deleteBtn addTarget:self action:@selector(deleteAccountDatas:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat height = 25;
    CGFloat spaciing = 15;
    __weak ManagementTableViewCell *weakself = self;
    [_accountNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.contentView.mas_top).offset(spaciing);
        make.left.equalTo(weakself.contentView.mas_left).offset(spaciing);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(height);
    }];
    [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.contentView.mas_top).offset(spaciing);
        make.left.equalTo(self.accountNamelabel.mas_right);
        make.right.equalTo(self.deleteBtn.mas_left).offset(-spaciing);
        make.height.mas_equalTo(height);
    }];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.contentView.mas_top).offset(spaciing);
        make.right.equalTo(weakself.contentView.mas_right).offset(-10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(height);
    }];
    [_deleteBtn.layer setMasksToBounds:YES];
    [_deleteBtn.layer setMasksToBounds:YES];
    [_deleteBtn.layer setBorderWidth:1.0];
    [_deleteBtn.layer setBorderColor:[UIColor blackColor].CGColor];
    _deleteBtn.clipsToBounds = YES;
    _deleteBtn.layer.cornerRadius = 5;
    
    //
    UILabel *line = [[UILabel alloc] init];
    [self.contentView addSubview:line];
    line.backgroundColor = RGB(234, 238, 241);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakself.contentView);
        make.height.mas_equalTo(1);
    }];
}
- (void)deleteAccountDatas:(UIButton *)sender {
    
    if (self.delegate) {
        [self.delegate deleteAccountDatas:_model indexPath:_indexPath];
    }
}
- (void)setModel:(ManagementModel *)model {
    _model = model;
}
+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
