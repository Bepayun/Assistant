//
//  Account_TaobaoCell.m
//  assistant
//
//  Created by Bepa on 2017/9/18.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "Account_TaobaoCell.h"

@implementation Account_TaobaoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"beautifySlider_normal@2x"];
        UIImage *selectedimage = [UIImage imageNamed:@"beautifySlider@2x"];
        UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
        Button.backgroundColor = RGBA(255,255,255, 1.0);
        Button.frame = CGRectMake(15,(50-selectedimage.size.height*1.5)/2,selectedimage.size.width*1.5,selectedimage.size.height*1.5);
        [Button setImage:image forState:UIControlStateNormal];
        [Button setImage:selectedimage forState:UIControlStateDisabled];
        Button.titleLabel.font = [UIFont systemFontOfSize:12];
        [Button addTarget:self action:@selector(selectBegin:) forControlEvents:UIControlEventTouchUpInside];
         self.selectedButton = Button;
        [self.contentView addSubview:self.selectedButton];
        //
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.selectedButton.frame.origin.x+self.selectedButton.frame.size.width+5, self.selectedButton.frame.origin.y, self.frame.size.width-self.selectedButton.frame.size.width-50,self.selectedButton.frame.size.height)];
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = RGBA(45, 51,46, 1);
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.nameLabel];
       
    }
    return self;
}
- (void)selectBegin:(UIButton *)btn {
    
    [self.delagate Account_TaobaoCellSelected:btn];
    
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
