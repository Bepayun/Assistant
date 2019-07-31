//
//  OrderPersonListView.h
//  assistant
//
//  Created by Bepa on 2017/9/15.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account_TaobaoCell.h"

@protocol OrderPersonListDelegate <NSObject>

-(void)addAccountwithTaobaoOrJD;
-(void)chooseAccountCertainTaskwithArray:(NSArray *)array;

@end

@interface OrderPersonListView : UIView<UITableViewDelegate,UITableViewDataSource,Account_TaobaoCellDelegate>{
 
    
}
@property (weak,nonatomic) id <OrderPersonListDelegate>delagate;
@property (nonatomic,strong)UIButton   *blackView;
@property (strong,nonatomic)UIImageView    *listview;
@property (nonatomic,strong)UITableView    *accountListTabelView;
@property (nonatomic,strong)NSMutableArray *taobaoAccountArray;
@property (nonatomic,strong)NSMutableArray *AccountArray;
@property (nonatomic,assign)int platformtype;


@end
