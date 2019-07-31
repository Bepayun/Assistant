//
//  MySetViewControllerCell.m
//  is_ass
//
//  Created by Bepa  on 2017/9/4.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#define cellHeight 55

#import "MySetViewControllerCell.h"

@interface MySetViewControllerCell ()

@property (nonatomic, strong) UILabel *lineOne;
@property (nonatomic, strong) UILabel *lineTwo;
@property (nonatomic, strong) UIButton *exitButton;

@end

@implementation MySetViewControllerCell

+ (MySetViewControllerCell *)cellForTableView:(UITableView *)tableView {
    static NSString *identifier = @"MySetViewControllerCell";
    MySetViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MySetViewControllerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)createViews {
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 27, 27)];
    self.imgView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.imgView];
    __weak MySetViewControllerCell *weakself = self;
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.mas_left).offset(10);
        make.centerY.equalTo(weakself.mas_centerY);
        make.height.mas_equalTo(27);
        make.width.mas_equalTo(24);
    }];
    //
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgView.mas_centerY);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    
    //
    self.dotImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.dotImageView];
    [self.dotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.mas_centerY);
        make.right.equalTo(weakself.mas_right).offset(-35);
        make.width.height.mas_equalTo(20);
    }];
    //
    self.lineOne = [[UILabel alloc] init];
    self.lineOne.backgroundColor = RGB(234, 238, 241);
    [self.contentView addSubview:self.lineOne];
    [self.lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).offset(8);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(1);
    }];
    self.lineTwo = [[UILabel alloc] init];
    self.lineTwo.backgroundColor = RGB(234, 238, 241);
    [self.contentView addSubview:self.lineTwo];
    [self.lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.right.equalTo(weakself);
        make.height.mas_equalTo(1);
    }];
    //
    self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.exitButton setTitle:kLoginButtonName forState:UIControlStateNormal];
    [self.exitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.exitButton];
    self.exitButton.hidden = YES;
    [self.exitButton addTarget:self action:@selector(exitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakself);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(100);
    }];
}
- (void)exitButtonClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    _exitBlock(sender);
    sender.userInteractionEnabled = YES;
}
- (void)setCellType:(CellType)cellType {
    _cellType = cellType;
    if (cellType == 0) {
        self.imgView.hidden = NO;
        self.titleLabel.hidden = NO;
        self.exitButton.hidden = YES;
        self.lineOne.hidden = NO;
        self.lineTwo.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    } else if (cellType == 1) {
        self.imgView.hidden = YES;
        self.titleLabel.hidden = YES;
        self.exitButton.hidden = NO;
        self.lineOne.hidden = YES;
        self.lineTwo.hidden = NO;
        self.separatorInset = UIEdgeInsetsZero;
    }
}
+ (CGFloat)getCellHeight {
    return cellHeight;
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
