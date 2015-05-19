//
//  JTHuodongquanTableViewCell.h
//  清一丽
//
//  Created by 小七 on 15-2-15.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTHuodongquanTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView * bgImgView;
@property(nonatomic,strong)UIImageView * imgView;
@property(nonatomic,strong)UILabel * titleLab;
@property(nonatomic,strong)UILabel * dateLab;
@property(nonatomic,strong)UILabel * numLab;
@property(nonatomic,strong)UILabel * finishLab;
@property(nonatomic,strong)UIButton * zeBarBtn;
@property(nonatomic,assign)int UsedOrOvertime;
-(void)refreshUI;
@end
