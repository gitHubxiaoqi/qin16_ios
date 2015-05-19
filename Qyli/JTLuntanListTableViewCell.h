//
//  JTLuntanListTableViewCell.h
//  清一丽
//
//  Created by 小七 on 15-4-10.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTLuntanListTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView * bgImgView;

@property(nonatomic,strong)UIImageView * photoImgView;
@property(nonatomic,strong)UILabel * nameLab;
@property(nonatomic,strong)UILabel * topicLab;
@property(nonatomic,strong)UILabel * dateLab;
@property(nonatomic,strong)UILabel * contentLab;

@property(nonatomic,strong)UIImageView * bigImgView;

@property(nonatomic,strong)UIImageView * imgView1;
@property(nonatomic,strong)UIImageView * imgView2;
@property(nonatomic,strong)UIImageView * imgView3;
@property(nonatomic,strong)UIImageView * imgView4;


@property(nonatomic,strong)UIView * bottomView;
@property(nonatomic,strong)UIImageView * dingImgView;
@property(nonatomic,strong)UIImageView * caiImgView;
@property(nonatomic,strong)UIImageView * chatImgView;

@property(nonatomic,strong)UILabel * dingLab;
@property(nonatomic,strong)UILabel * caiLab;
@property(nonatomic,strong)UILabel * chatLab;

-(void)refreshCell:(JTSortModel *)senderModel;
@end
