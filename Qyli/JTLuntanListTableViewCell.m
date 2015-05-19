//
//  JTLuntanListTableViewCell.m
//  清一丽
//
//  Created by 小七 on 15-4-10.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTLuntanListTableViewCell.h"

@implementation JTLuntanListTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect rect=self.frame;
        rect.size.width=[UIScreen mainScreen].bounds.size.width;
        self.frame=rect;
        
        _bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, 270+(self.bounds.size.width-20-30)/5.0+10+30+10)];
        _bgImgView.image=[UIImage imageNamed:@"背景框.png"];
        [self addSubview:_bgImgView];
        
        _photoImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10,40, 40)];
        _photoImgView.layer.masksToBounds=YES;
        _photoImgView.layer.cornerRadius=20;
        [self.bgImgView addSubview:_photoImgView];
        
        _nameLab=[[UILabel alloc] initWithFrame:CGRectMake(60, 20, self.bounds.size.width-60-120-10, 20)];
        _nameLab.textColor=[UIColor brownColor];
        _nameLab.font=[UIFont systemFontOfSize:14];
        [self.bgImgView addSubview:_nameLab];
        
        _dateLab=[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-120-10, 20, 120, 20)];
        _dateLab.textColor=[UIColor grayColor];
        _dateLab.font=[UIFont systemFontOfSize:13];
        [self.bgImgView addSubview:_dateLab];
        
        _topicLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 60, self.bounds.size.width-20, 20)];
        _topicLab.textColor=[UIColor blackColor];
        _topicLab.font=[UIFont systemFontOfSize:16];
        _topicLab.numberOfLines=0;
        [self.bgImgView addSubview:_topicLab];
        
        
        _contentLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 80, self.bounds.size.width-20, 80)];
        _contentLab.textColor=[UIColor grayColor];
        _contentLab.font=[UIFont systemFontOfSize:14];
        _contentLab.numberOfLines=0;
        [self.bgImgView addSubview:_contentLab];
        
        
        _bigImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 160,self.bounds.size.width-20, 100)];
        _bigImgView.contentMode=UIViewContentModeScaleAspectFit;
        [self.bgImgView addSubview:_bigImgView];
        
        
        _imgView1=[[UIImageView alloc] initWithFrame:CGRectMake(10, 270,(self.bounds.size.width-20-30)/4.0, (self.bounds.size.width-20-30)/5.0)];
        [self.bgImgView addSubview:_imgView1];
        
        _imgView2=[[UIImageView alloc] initWithFrame:CGRectMake(10+(self.bounds.size.width-20-30)/4.0+10, 270,(self.bounds.size.width-20-30)/4.0, (self.bounds.size.width-20-30)/5.0)];
        [self.bgImgView addSubview:_imgView2];
        
        _imgView3=[[UIImageView alloc] initWithFrame:CGRectMake(10+(self.bounds.size.width-20-30)/4.0+10+(self.bounds.size.width-20-30)/4.0+10, 270,(self.bounds.size.width-20-30)/4.0, (self.bounds.size.width-20-30)/5.0)];
        [self.bgImgView addSubview:_imgView3];
        
        _imgView4=[[UIImageView alloc] initWithFrame:CGRectMake(10+(self.bounds.size.width-20-30)/4.0+10+(self.bounds.size.width-20-30)/4.0+10+(self.bounds.size.width-20-30)/4.0+10, 270,(self.bounds.size.width-20-30)/4.0, (self.bounds.size.width-20-30)/5.0)];
        [self.bgImgView addSubview:_imgView4];
        
    
        _bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, 270+(self.bounds.size.width-20-30)/5.0+10, self.bounds.size.width, 30)];
        _bottomView.backgroundColor=[UIColor clearColor];
        [self.bgImgView addSubview:_bottomView];
        
        _dingImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 0,30, 30)];
        _dingImgView.image=[UIImage imageNamed:@"顶1.png"];
        [self.bottomView addSubview:_dingImgView];
        
        _dingLab=[[UILabel alloc] initWithFrame:CGRectMake(10+30,5, 50, 20)];
        _dingLab.textColor=[UIColor grayColor];
        _dingLab.font=[UIFont systemFontOfSize:13];
        _dingLab.textAlignment=NSTextAlignmentCenter;
        [self.bottomView addSubview:_dingLab];
        
        
        _caiImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10+80,0,30, 30)];
        _caiImgView.image=[UIImage imageNamed:@"踩1.png"];
        [self.bottomView addSubview:_caiImgView];
        
        _caiLab=[[UILabel alloc] initWithFrame:CGRectMake(10+80+30, 5, 50, 20)];
        _caiLab.textColor=[UIColor grayColor];
        _caiLab.font=[UIFont systemFontOfSize:13];
        _caiLab.textAlignment=NSTextAlignmentCenter;
        [self.bottomView addSubview:_caiLab];
        
        _chatImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10+80+80,0,30, 30)];
        _chatImgView.image=[UIImage imageNamed:@"评论1.png"];
        [self.bottomView addSubview:_chatImgView];
        
        _chatLab=[[UILabel alloc] initWithFrame:CGRectMake(10+80+80+30,5, 50, 20)];
        _chatLab.textColor=[UIColor grayColor];
        _chatLab.font=[UIFont systemFontOfSize:13];
        _chatLab.textAlignment=NSTextAlignmentCenter;
        [self.bottomView addSubview:_chatLab];
        
        
        self.bounds=CGRectMake(0, 0, self.bounds.size.width,270+(self.bounds.size.width-20-30)/5.0+10+30+10+10);
    }
    return self;
}
-(void)refreshCell:(JTSortModel *)model
{
    [self.photoImgView setImageWithURL:[NSURL URLWithString:model.user.headPortraitImgUrlStr] placeholderImage:[UIImage imageNamed:@"头像.png"]];
    self.nameLab.text=model.user.userName;
    self.dateLab.text=model.registTime;
    self.topicLab.text=model.title;
    CGSize topicAutoSize=[self.topicLab.text boundingRectWithSize:CGSizeMake(self.bounds.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.topicLab.font} context:nil].size;
    if (topicAutoSize.height<20)
    {
        topicAutoSize.height=20;
    }
    self.topicLab.bounds=CGRectMake(0, 0, self.bounds.size.width-20, topicAutoSize.height);
    
    self.contentLab.text=model.name;
    CGSize contentAutoSize=[self.contentLab.text boundingRectWithSize:CGSizeMake(self.bounds.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentLab.font} context:nil].size;
    if (contentAutoSize.height<20)
    {
        contentAutoSize.height=20;
    }
    else if (contentAutoSize.height>60)
    {
         contentAutoSize.height=60;
    }
    self.contentLab.frame=CGRectMake(10, 60+topicAutoSize.height, self.bounds.size.width-20, contentAutoSize.height);
    
    if (model.imgUrlArr.count==0)
    {
        self.bigImgView.hidden=YES;
        self.imgView1.hidden=YES;
        self.imgView2.hidden=YES;
        self.imgView3.hidden=YES;
        self.imgView4.hidden=YES;
        self.bottomView.frame=CGRectMake(0, 60+topicAutoSize.height+contentAutoSize.height+10, SCREEN_WIDTH, 30);
        self.bounds=CGRectMake(0, 0, SCREEN_WIDTH,  60+topicAutoSize.height+contentAutoSize.height+10+30+20);
        self.bgImgView.frame=CGRectMake(0, 5, SCREEN_WIDTH, 60+topicAutoSize.height+contentAutoSize.height+10+30+10);
    }
    else if (model.imgUrlArr.count==1)
    {
        self.bigImgView.hidden=NO;
        [self.bigImgView setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
        self.imgView1.hidden=YES;
        self.imgView2.hidden=YES;
        self.imgView3.hidden=YES;
        self.imgView4.hidden=YES;
        self.bigImgView.frame=CGRectMake(10,  60+topicAutoSize.height+contentAutoSize.height+10, SCREEN_WIDTH-20, 100);
        self.bottomView.frame=CGRectMake(0, 60+topicAutoSize.height+contentAutoSize.height+10+100+10, SCREEN_WIDTH, 30);
        self.bounds=CGRectMake(0, 0, SCREEN_WIDTH,  60+topicAutoSize.height+contentAutoSize.height+10+100+10+30+20);
        self.bgImgView.frame=CGRectMake(0, 5, SCREEN_WIDTH, 60+topicAutoSize.height+contentAutoSize.height+10+100+10+30+10);
    }
    else if (model.imgUrlArr.count==2)
    {
        self.bigImgView.hidden=YES;
        self.imgView1.hidden=NO;
        [self.imgView1 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
        self.imgView2.hidden=NO;
        [self.imgView2 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
        self.imgView3.hidden=YES;
        self.imgView4.hidden=YES;
        self.imgView1.frame=CGRectMake(10,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
        self.imgView2.frame=CGRectMake(10+(SCREEN_WIDTH-20-30)/4.0+10,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
        self.bottomView.frame=CGRectMake(0, 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10, SCREEN_WIDTH, 30);
        self.bounds=CGRectMake(0, 0, SCREEN_WIDTH,  60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+20);
        self.bgImgView.frame=CGRectMake(0, 5, SCREEN_WIDTH, 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+10);
    }
    else if (model.imgUrlArr.count==3)
    {
        self.bigImgView.hidden=YES;
        self.imgView1.hidden=NO;
        [self.imgView1 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
        self.imgView2.hidden=NO;
        [self.imgView2 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
        self.imgView3.hidden=NO;
        [self.imgView3 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
        self.imgView4.hidden=YES;
        self.imgView1.frame=CGRectMake(10,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
        self.imgView2.frame=CGRectMake(10+(SCREEN_WIDTH-20-30)/4.0+10,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
        self.imgView3.frame=CGRectMake(10+(SCREEN_WIDTH-20-30)/4.0*2+20,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
        self.bottomView.frame=CGRectMake(0, 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10, SCREEN_WIDTH, 30);
        self.bounds=CGRectMake(0, 0, SCREEN_WIDTH,  60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+20);
        self.bgImgView.frame=CGRectMake(0, 5, SCREEN_WIDTH, 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+10);
    }
    else if (model.imgUrlArr.count==4)
    {
        self.bigImgView.hidden=YES;
        self.imgView1.hidden=NO;
        [self.imgView1 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
        self.imgView2.hidden=NO;
        [self.imgView2 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
        self.imgView3.hidden=NO;
        [self.imgView3 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
        self.imgView4.hidden=NO;
        [self.imgView4 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:3]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
        self.imgView1.frame=CGRectMake(10,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
        self.imgView2.frame=CGRectMake(10+(SCREEN_WIDTH-20-30)/4.0+10,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
        self.imgView3.frame=CGRectMake(10+(SCREEN_WIDTH-20-30)/4.0*2+20,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
        self.imgView3.frame=CGRectMake(10+(SCREEN_WIDTH-20-30)/4.0*3+30,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
        self.bottomView.frame=CGRectMake(0, 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10, SCREEN_WIDTH, 30);
        self.bounds=CGRectMake(0, 0, SCREEN_WIDTH,  60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+20);
        self.bgImgView.frame=CGRectMake(0, 5, SCREEN_WIDTH, 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+10);
    }
    self.dingLab.text=model.beginDate;
    self.caiLab.text=model.endDate;
    self.chatLab.text=model.commentCount;
    
//    [customCell.photoImgView setImageWithURL:[NSURL URLWithString:model.user.headPortraitImgUrlStr] placeholderImage:[UIImage imageNamed:@"头像.png"]];
//    customCell.nameLab.text=model.user.userName;
//    customCell.dateLab.text=model.registTime;
//    customCell.topicLab.text=model.title;
//    CGSize topicAutoSize=[customCell.topicLab.text boundingRectWithSize:CGSizeMake(customCell.bounds.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:customCell.topicLab.font} context:nil].size;
//    if (topicAutoSize.height<20)
//    {
//        topicAutoSize.height=20;
//    }
//    customCell.topicLab.bounds=CGRectMake(0, 0, customCell.bounds.size.width-20, topicAutoSize.height);
//    
//    customCell.contentLab.text=model.name;
//    CGSize contentAutoSize=[customCell.contentLab.text boundingRectWithSize:CGSizeMake(customCell.bounds.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:customCell.contentLab.font} context:nil].size;
//    if (contentAutoSize.height<20)
//    {
//        contentAutoSize.height=20;
//    }
//    customCell.contentLab.frame=CGRectMake(10, 60+topicAutoSize.height, customCell.bounds.size.width-20, contentAutoSize.height);
//    
//    if (model.imgUrlArr.count==0)
//    {
//        customCell.bigImgView.hidden=YES;
//        customCell.imgView1.hidden=YES;
//        customCell.imgView2.hidden=YES;
//        customCell.imgView3.hidden=YES;
//        customCell.imgView4.hidden=YES;
//        customCell.bottomView.frame=CGRectMake(0, 60+topicAutoSize.height+contentAutoSize.height+10, SCREEN_WIDTH, 30);
//        customCell.bounds=CGRectMake(0, 0, SCREEN_WIDTH,  60+topicAutoSize.height+contentAutoSize.height+10+30+20);
//        customCell.bgImgView.frame=CGRectMake(0, 5, SCREEN_WIDTH, 60+topicAutoSize.height+contentAutoSize.height+10+30+10);
//    }
//    else if (model.imgUrlArr.count==1)
//    {
//        customCell.bigImgView.hidden=NO;
//        [customCell.bigImgView setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
//        customCell.imgView1.hidden=YES;
//        customCell.imgView2.hidden=YES;
//        customCell.imgView3.hidden=YES;
//        customCell.imgView4.hidden=YES;
//        customCell.bigImgView.frame=CGRectMake(10,  60+topicAutoSize.height+contentAutoSize.height+10, SCREEN_WIDTH-20, 100);
//        customCell.bottomView.frame=CGRectMake(0, 60+topicAutoSize.height+contentAutoSize.height+10+100+10, SCREEN_WIDTH, 30);
//        customCell.bounds=CGRectMake(0, 0, SCREEN_WIDTH,  60+topicAutoSize.height+contentAutoSize.height+10+100+10+30+20);
//        customCell.bgImgView.frame=CGRectMake(0, 5, SCREEN_WIDTH, 60+topicAutoSize.height+contentAutoSize.height+10+100+10+30+10);
//    }
//    else if (model.imgUrlArr.count==2)
//    {
//        customCell.bigImgView.hidden=YES;
//        customCell.imgView1.hidden=NO;
//        [customCell.imgView1 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
//        customCell.imgView2.hidden=NO;
//        [customCell.imgView2 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
//        customCell.imgView3.hidden=YES;
//        customCell.imgView4.hidden=YES;
//        customCell.imgView1.frame=CGRectMake(10,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
//        customCell.imgView2.frame=CGRectMake(10+(SCREEN_WIDTH-20-30)/4.0+10,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
//        customCell.bottomView.frame=CGRectMake(0, 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10, SCREEN_WIDTH, 30);
//        customCell.bounds=CGRectMake(0, 0, SCREEN_WIDTH,  60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+20);
//        customCell.bgImgView.frame=CGRectMake(0, 5, SCREEN_WIDTH, 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+10);
//    }
//    else if (model.imgUrlArr.count==3)
//    {
//        customCell.bigImgView.hidden=YES;
//        customCell.imgView1.hidden=NO;
//        [customCell.imgView1 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
//        customCell.imgView2.hidden=NO;
//        [customCell.imgView2 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
//        customCell.imgView3.hidden=NO;
//        [customCell.imgView3 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
//        customCell.imgView4.hidden=YES;
//        customCell.imgView1.frame=CGRectMake(10,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
//        customCell.imgView2.frame=CGRectMake(10+(SCREEN_WIDTH-20-30)/4.0+10,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
//        customCell.imgView3.frame=CGRectMake(10+(SCREEN_WIDTH-20-30)/4.0*2+20,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
//        customCell.bottomView.frame=CGRectMake(0, 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10, SCREEN_WIDTH, 30);
//        customCell.bounds=CGRectMake(0, 0, SCREEN_WIDTH,  60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+20);
//        customCell.bgImgView.frame=CGRectMake(0, 5, SCREEN_WIDTH, 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+10);
//    }
//    else if (model.imgUrlArr.count==4)
//    {
//        customCell.bigImgView.hidden=YES;
//        customCell.imgView1.hidden=NO;
//        [customCell.imgView1 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
//        customCell.imgView2.hidden=NO;
//        [customCell.imgView2 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
//        customCell.imgView3.hidden=NO;
//        [customCell.imgView3 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
//        customCell.imgView4.hidden=NO;
//        [customCell.imgView4 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:3]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
//        customCell.imgView1.frame=CGRectMake(10,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
//        customCell.imgView2.frame=CGRectMake(10+(SCREEN_WIDTH-20-30)/4.0+10,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
//        customCell.imgView3.frame=CGRectMake(10+(SCREEN_WIDTH-20-30)/4.0*2+20,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
//        customCell.imgView3.frame=CGRectMake(10+(SCREEN_WIDTH-20-30)/4.0*3+30,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
//        customCell.bottomView.frame=CGRectMake(0, 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10, SCREEN_WIDTH, 30);
//        customCell.bounds=CGRectMake(0, 0, SCREEN_WIDTH,  60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+20);
//        customCell.bgImgView.frame=CGRectMake(0, 5, SCREEN_WIDTH, 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+10);
//    }
//    customCell.dingLab.text=model.beginDate;
//    customCell.caiLab.text=model.endDate;
//    customCell.chatLab.text=model.commentCount;


}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
