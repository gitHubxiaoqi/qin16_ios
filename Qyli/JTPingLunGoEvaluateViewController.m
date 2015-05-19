//
//  JTPingLunGoEvaluateViewController.m
//  Qyli
//
//  Created by 小七 on 14-12-4.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTPingLunGoEvaluateViewController.h"
#import "JTMycommentViewController.h"
@interface JTPingLunGoEvaluateViewController ()<UITextViewDelegate,UIAlertViewDelegate>
{
    UIScrollView * _bigScrollView;
    UITextView * _textView;
    int scroType1;
    int scroType2;
    int scroType3;
}

@end

@implementation JTPingLunGoEvaluateViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView3.hidden=YES;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView.hidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView3.hidden=NO;
    appDelegate.tabBarView2.hidden=NO;
    appDelegate.tabBarView.hidden=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self readyUI];
}
-(void)readyUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden=YES;
    //自定义导航条
    UIView * navLab=[[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    navLab.userInteractionEnabled=YES;
    navLab.backgroundColor=NAV_COLOR;
    [self.view addSubview:navLab];
    
    UILabel * navTitailLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navTitailLab.text=@"评价";
    navTitailLab.textAlignment=NSTextAlignmentCenter;
    navTitailLab.textColor=[UIColor whiteColor];
    navTitailLab.font=[UIFont systemFontOfSize:20];
    [navLab addSubview:navTitailLab];
    
    UIButton * leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 80, NAV_HEIGHT);
    [leftBtn addTarget:self action:@selector(leftBtnCilck) forControlEvents:UIControlEventTouchUpInside];
    [navLab addSubview:leftBtn];
    
    UIImageView * backImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回按钮.png"]];
    backImgView.frame=CGRectMake(20, (NAV_HEIGHT-15)/2, 10, 15);
    [leftBtn addSubview:backImgView];
    
    _bigScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    _bigScrollView.userInteractionEnabled=YES;
    [self.view addSubview:_bigScrollView];
    
    for (int i=0; i<self.typeListArr.count; i++)
    {
        UILabel * typeTilteLab=[[UILabel alloc] init];
        typeTilteLab.text=[_typeListArr objectAtIndex:i];
        typeTilteLab.textColor=[UIColor blackColor];
        typeTilteLab.font=[UIFont systemFontOfSize:18];
        CGSize autoSize=[ typeTilteLab.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:typeTilteLab.font} context:nil].size;
        if (autoSize.width<40)
        {
            autoSize.width=40;
        }
        typeTilteLab.frame=CGRectMake(10, 5+i*40,autoSize.width, 30);
        [_bigScrollView addSubview:typeTilteLab];
        
        if (self.idStr==nil)
        {
            for (int j=0; j<5; j++)
            {
                UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame=CGRectMake(10+autoSize.width+10+j*(30+10), 5+i*40, 30, 30);
                [btn setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                btn.tag=(i*5)+(j+21);
                [btn addTarget:self action:@selector(starBtn:) forControlEvents:UIControlEventTouchUpInside];
                [_bigScrollView addSubview:btn];
            }
            
            
            
        }
        else
        {
            for (int j=0; j<5; j++)
            {
                UIImage * img=[[UIImage alloc] init];
                if (j<[[self.scroeArr objectAtIndex:i] intValue])
                {
                    img=[UIImage imageNamed:@"comment_star.png"];
                }
                else
                {
                    img= [UIImage imageNamed:@"comment_star_gray.png"];
                }
                UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame=CGRectMake(10+autoSize.width+10+j*(30+10), 5+i*40, 30, 30);
                [btn setImage:img forState:UIControlStateNormal];
                btn.tag=(i*5)+(j+21);
                [btn addTarget:self action:@selector(starBtn:) forControlEvents:UIControlEventTouchUpInside];
                [_bigScrollView addSubview:btn];
            }
            
        }
        
    }
    int h=[_typeListArr count]*40;
    
    if (self.idStr==nil)
    {
        UIImageView * textViewBgImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_input_bg.9.png"]];
        textViewBgImgView.tag=60;
        textViewBgImgView.frame=CGRectMake(8,8+h, self.view.frame.size.width-8*2, 64);
        [_bigScrollView addSubview:textViewBgImgView];
        
        _textView=[[UITextView alloc] init];
        _textView.frame=CGRectMake(10,h+10, self.view.frame.size.width-20, 60);
        _textView.font=[UIFont systemFontOfSize:14];
        _textView.delegate=self;
        [_bigScrollView addSubview:_textView];
        
        UILabel * placeHolderLab=[[UILabel alloc] init];
        placeHolderLab.frame=CGRectMake(2, 0, 200, 30);
        placeHolderLab.text = @"说说你的感受吧。。";
        placeHolderLab.tag=40;
        placeHolderLab.enabled = NO;//lable必须设置为不可用
        placeHolderLab.textColor=[UIColor lightGrayColor];
        placeHolderLab.textAlignment=NSTextAlignmentLeft;
        placeHolderLab.font=[UIFont systemFontOfSize:14];
        placeHolderLab.backgroundColor = [UIColor clearColor];
        [_textView addSubview:placeHolderLab];
        
        UIButton * commentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        commentBtn.frame=CGRectMake(10, h+10+60+15, self.view.frame.size.width-20, 35);
        commentBtn.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:151.0/255.0 blue:48.0/255.0 alpha:1];
        [commentBtn setTitle:@"提交评价" forState:UIControlStateNormal];
        [commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commentBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        commentBtn.tag=50;
        [commentBtn addTarget:self action:@selector(commentBtn) forControlEvents:UIControlEventTouchUpInside];
        [_bigScrollView addSubview:commentBtn];
        
        _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, h+120);
    }
    else
    {
        if (self.scroeArr.count==0)
        {
        }
        else if (self.scroeArr.count==1)
        {
            scroType1=[[self.scroeArr objectAtIndex:0] intValue];
        }
        else if (self.scroeArr.count==2)
        {
            scroType1=[[self.scroeArr objectAtIndex:0] intValue];
            scroType2=[[self.scroeArr objectAtIndex:1] intValue];
        }
        else if (self.scroeArr.count==3)
        {
            scroType1=[[self.scroeArr objectAtIndex:0] intValue];
            scroType2=[[self.scroeArr objectAtIndex:1] intValue];
            scroType3=[[self.scroeArr objectAtIndex:2] intValue];
        }
        
        
        UIImageView * textViewBgImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_input_bg.9.png"]];
        textViewBgImgView.tag=60;
        textViewBgImgView.frame=CGRectMake(8,8+h, self.view.frame.size.width-8*2, 64);
        [_bigScrollView addSubview:textViewBgImgView];
        
        _textView=[[UITextView alloc] init];
        _textView.frame=CGRectMake(10,h+10, self.view.frame.size.width-20, 60);
        _textView.delegate=self;
        _textView.text=self.context;
        _textView.font=[UIFont systemFontOfSize:14];
        [_bigScrollView addSubview:_textView];
        
        UIButton * commentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        commentBtn.frame=CGRectMake(self.view.frame.size.width/2+10, h+10+60+15, self.view.frame.size.width/2-20, 35);
        commentBtn.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:151.0/255.0 blue:48.0/255.0 alpha:1];
        [commentBtn setTitle:@"修改评价" forState:UIControlStateNormal];
        [commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commentBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        commentBtn.tag=100;
        [commentBtn addTarget:self action:@selector(xiugaiBtn) forControlEvents:UIControlEventTouchUpInside];
        [_bigScrollView addSubview:commentBtn];
        
        UIButton * deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame=CGRectMake(10, h+10+60+15, 30, 35);
        [deleteBtn setImage:[UIImage imageNamed:@"delte_comment.png"] forState:UIControlStateNormal];
        deleteBtn.tag=200;
        [deleteBtn addTarget:self action:@selector(deleteBtn) forControlEvents:UIControlEventTouchUpInside];
        [_bigScrollView addSubview:deleteBtn];
        
        NSDictionary * dic=[[NSDictionary alloc] initWithObjectsAndKeys:_textView.font,NSFontAttributeName, nil];
        CGSize autoSize=[_textView.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        if (autoSize.height<60)
        {
            autoSize.height=60;
        }
        _textView.frame=CGRectMake(10,[_typeListArr count]*40+10, self.view.frame.size.width-20, autoSize.height);
        textViewBgImgView.frame=CGRectMake(8, [_typeListArr count]*40+8, self.view.frame.size.width-20+4, autoSize.height+4);
        commentBtn.frame=CGRectMake(self.view.frame.size.width/2+10, [_typeListArr count]*40+10+autoSize.height+15,self.view.frame.size.width/2-20, 35);
        deleteBtn.frame=CGRectMake(10, [_typeListArr count]*40+10+autoSize.height+15, 30, 35);
        _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, [_typeListArr count]*40+10+autoSize.height+50+10);
        
    }
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UIImageView * textViewBgImgView=(UIImageView *)[_bigScrollView viewWithTag:60];
    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, [_typeListArr count]*40+10+textViewBgImgView.frame.size.height+50+10+216+40+30);
}
-(void)textViewDidChange:(UITextView *)textView
{
    UILabel * placeHoderLab=(UILabel *)[textView viewWithTag:40];
    
    if (textView.text.length == 0)
    {
        placeHoderLab.text =@"说说你的感受吧。。";
    }
    else
    {
        placeHoderLab.text = @"";
        NSDictionary * dic=[[NSDictionary alloc] initWithObjectsAndKeys:textView.font,NSFontAttributeName, nil];
        CGSize autoSize=[textView.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        if (autoSize.height<60)
        {
            autoSize.height=60;
        }
        textView.frame=CGRectMake(10,[_typeListArr count]*40+10, self.view.frame.size.width-20, autoSize.height);
        UIImageView * textViewBgImgView=(UIImageView *)[_bigScrollView viewWithTag:60];
        textViewBgImgView.frame=CGRectMake(8, [_typeListArr count]*40+8, self.view.frame.size.width-8*2, autoSize.height+4);
        UIButton * commentBtn=(UIButton *)[_bigScrollView viewWithTag:50];
        commentBtn.frame=CGRectMake(10, [_typeListArr count]*40+10+autoSize.height+15, self.view.frame.size.width-20, 35);
        UIButton *xiugaiBtn=(UIButton *)[_bigScrollView viewWithTag:100];
        xiugaiBtn.frame=CGRectMake(self.view.frame.size.width/2+10, [_typeListArr count]*40+10+autoSize.height+15,self.view.frame.size.width/2-20, 35);
        UIButton *deleteBtn=(UIButton *)[_bigScrollView viewWithTag:200];
        deleteBtn.frame=CGRectMake(10, [_typeListArr count]*40+10+autoSize.height+15, 30, 35);
        _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, [_typeListArr count]*40+10+autoSize.height+50+10+216+40);
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    UIImageView * textViewBgImgView=(UIImageView *)[_bigScrollView viewWithTag:60];
    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, [_typeListArr count]*40+10+textViewBgImgView.frame.size.height+50+10);
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    UIImageView * textViewBgImgView=(UIImageView *)[_bigScrollView viewWithTag:60];
    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, [_typeListArr count]*40+10+textViewBgImgView.frame.size.height+50+10);
}
-(void)commentBtn
{
    [self.view endEditing:YES];
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    NSString * userID=[NSString stringWithFormat:@"%d",appdelegate.appUser.userID];
    
    if (self.typeListIDArr.count==0)
    {
        if ([_textView.text isEqualToString:@""])
        {
            NSString * str=@"评价内容不能为空！";
            [JTAlertViewAnimation startAnimation:str view:self.view];
            return;
        }
    }
    else if (self.typeListIDArr.count==1)
    {
        if (scroType1==0||[_textView.text isEqualToString:@""])
        {
            NSString * str=@"请给以上各项打分并说说你的感受，感谢您的支持~~";
            [JTAlertViewAnimation startAnimation:str view:self.view];
            return;
        }
    }
    else if (self.typeListIDArr.count==2)
    {
        if (scroType1==0||scroType2==0||[_textView.text isEqualToString:@""])
        {
            NSString * str=@"请给以上各项打分并说说你的感受，感谢您的支持~~";
            [JTAlertViewAnimation startAnimation:str view:self.view];
            return;
        }
    }
    else if (self.typeListIDArr.count==3)
    {
        if (scroType1==0||scroType2==0||scroType3==0||[_textView.text isEqualToString:@""])
        {
            NSString * str=@"请给以上各项打分并说说你的感受，感谢您的支持~~";
            [JTAlertViewAnimation startAnimation:str view:self.view];
            return;
        }
    }
    
    if ([SOAPRequest checkNet])
    {
        
        //7.6评论保存（内容评论+分数评论）
//           NSDictionary * dic1=[[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"type",@"4",@"score", nil];
//           NSDictionary * dic2=[[NSDictionary alloc] initWithObjectsAndKeys:@"2",@"type",@"5",@"score", nil];
//           NSArray * arr=[[NSArray alloc] initWithObjects:dic1,dic2, nil];
//           SBJSON * json=[[SBJSON alloc] init];
//           NSString * JSONStr=[json stringWithObject:arr error:nil];
        
        NSArray * scroArr=[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",scroType1],[NSString stringWithFormat:@"%d",scroType2],[NSString stringWithFormat:@"%d",scroType3], nil];
        NSMutableArray * jsonArr=[[NSMutableArray alloc] initWithCapacity:0];
        for (int i=0; i<self.typeListIDArr.count; i++)
        {
            NSMutableDictionary * dic=[[NSMutableDictionary alloc] initWithCapacity:0];
            [dic setObject:[self.typeListIDArr objectAtIndex:i] forKey:@"type"];
            [dic setObject:[scroArr objectAtIndex:i] forKey:@"score"];
            [jsonArr addObject:dic];
        }
        SBJSON * json=[[SBJSON alloc] init];
        NSString * JSONStr=[json stringWithObject:jsonArr error:nil];
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.mappingID,@"mappingId",self.infoID,@"infoId",userID,@"userId",_textView.text,@"context",JSONStr,@"ReviewSubListJSON", nil];
        NSDictionary * zaojiaoEvaluateDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Review_SaveReviewAndReviewScore] jsonDic:jsondic]];

        if ([[NSString stringWithFormat:@"%@",[zaojiaoEvaluateDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"评价成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK,我知道了。。", nil];
            [alertView show];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            
            if ([zaojiaoEvaluateDic objectForKey:@"errorMessage"]!=nil)
            {
                NSString * str=[zaojiaoEvaluateDic objectForKey:@"errorMessage"];
                [JTAlertViewAnimation startAnimation:str view:self.view];
            }
            else
            {
                NSString * str=@"服务器异常，请稍后重试...";
                [JTAlertViewAnimation startAnimation:str view:self.view];
            }
            
        }
        
    }
    
    
}
-(void)xiugaiBtn
{
    [self.view endEditing:YES];
    UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"亲，确定要修改该条评论吗？" message:@"修改评论，相应回复也会自动删除哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertView.tag=1000;
    [alertView show];
    
    
}
-(void)deleteBtn
{
    [self.view endEditing:YES];
    UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，确定要删除该条评论及回复吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertView.tag=2000;
    [alertView show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1000)
    {
        if (buttonIndex==0)
        {
            [self.view endEditing:YES];
            
            
            if ([_textView.text isEqualToString:@""])
            {
                NSString * str=@"评价内容不能为空！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                return;
            }
            
            if ([SOAPRequest checkNet])
            {
                NSArray * scroArr=[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",scroType1],[NSString stringWithFormat:@"%d",scroType2],[NSString stringWithFormat:@"%d",scroType3], nil];
                NSMutableArray * jsonArr=[[NSMutableArray alloc] initWithCapacity:0];
                for (int i=0; i<self.typeListIDArr.count; i++)
                {
                    NSMutableDictionary * dic=[[NSMutableDictionary alloc] initWithCapacity:0];
                    [dic setObject:[self.typeListIDArr objectAtIndex:i] forKey:@"type"];
                    [dic setObject:[scroArr objectAtIndex:i] forKey:@"score"];
                    [jsonArr addObject:dic];
                }
                SBJSON * json=[[SBJSON alloc] init];
                NSString * JSONStr=[json stringWithObject:jsonArr error:nil];
                
                NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.idStr,@"reviewId",_textView.text,@"context",JSONStr,@"ReviewSubListJSON", nil];
                NSDictionary * zaojiaoEvaluateDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Review_SaveMemberCenterReviewEdit] jsonDic:jsondic]];
                
                if ([[NSString stringWithFormat:@"%@",[zaojiaoEvaluateDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
                {
                    UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"评价修改成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK,我知道了。。", nil];
                    [alertView show];
                    JTMycommentViewController * cVC=[self.navigationController.viewControllers objectAtIndex:1];
                    [self.navigationController popToViewController:cVC animated:YES];
                }
                else
                {
                    
                    if ([zaojiaoEvaluateDic objectForKey:@"errorMessage"]!=nil)
                    {
                        NSString * str=[zaojiaoEvaluateDic objectForKey:@"errorMessage"];
                        [JTAlertViewAnimation startAnimation:str view:self.view];
                    }
                    else
                    {
                        NSString * str=@"服务器异常，请稍后重试...";
                        [JTAlertViewAnimation startAnimation:str view:self.view];
                    }
                    
                }
                
            }
        }
        else
        {
        }

    }
    else
    {
        if (buttonIndex==0)
        {
            if ([SOAPRequest checkNet])
            {
                NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.idStr,@"reviewId", nil];
                NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Review_DelMemberCenterReview] jsonDic:jsondic]];
                
                if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
                {
                    UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"删除成功！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK，我知道了。。", nil];
                    [alertView show];
                    JTMycommentViewController * cVC=[self.navigationController.viewControllers objectAtIndex:1];
                    [self.navigationController popToViewController:cVC animated:YES];
                }
                else
                {
                    NSString * str=@"服务器异常，请稍后重试...";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
            }
        }
        else
        {
        }

    
   }
}

-(void)starBtn:(UIButton *)sender
{
    UIButton * btn1=(UIButton *)[_bigScrollView viewWithTag:sender.tag-1];
    UIButton * btn2=(UIButton *)[_bigScrollView viewWithTag:sender.tag-2];
    UIButton * btn3=(UIButton *)[_bigScrollView viewWithTag:sender.tag-3];
    UIButton * btn4=(UIButton *)[_bigScrollView viewWithTag:sender.tag-4];
    UIButton * btn5=(UIButton *)[_bigScrollView viewWithTag:sender.tag+1];
    UIButton * btn6=(UIButton *)[_bigScrollView viewWithTag:sender.tag+2];
    UIButton * btn7=(UIButton *)[_bigScrollView viewWithTag:sender.tag+3];
    UIButton * btn8=(UIButton *)[_bigScrollView viewWithTag:sender.tag+4];
    
    switch ((sender.tag-21)/5)
    {
        case 0:
        {
            switch ((sender.tag-21)%5)
            {
                case 0:
                {
                    [sender setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn5 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    [btn6 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    [btn7 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    [btn8 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    
                    scroType1=1;
                }
                    break;
                case 1:
                {
                    [btn1 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn5 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    [btn6 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    [btn7 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    scroType1=2;
                    
                }
                    break;
                case 2:
                {
                    
                    [btn1 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn2 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn5 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    [btn6 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    scroType1=3;
                    
                }
                    break;
                case 3:
                {
                    
                    [btn1 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn2 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn3 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn5 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    scroType1=4;
                    
                }
                    break;
                case 4:
                {
                    
                    [btn1 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn2 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn3 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn4 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    scroType1=5;
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
        case 1:
        {
            switch ((sender.tag-21)%5)
            {
                case 0:
                {
                    [sender setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn5 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    [btn6 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    [btn7 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    [btn8 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    
                    scroType2=1;
                }
                    break;
                case 1:
                {
                    [btn1 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn5 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    [btn6 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    [btn7 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    scroType2=2;
                    
                }
                    break;
                case 2:
                {
                    
                    [btn1 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn2 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn5 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    [btn6 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    scroType2=3;
                    
                }
                    break;
                case 3:
                {
                    
                    [btn1 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn2 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn3 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn5 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    scroType2=4;
                    
                }
                    break;
                case 4:
                {
                    
                    [btn1 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn2 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn3 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn4 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    scroType2=5;
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch ((sender.tag-21)%5)
            {
                case 0:
                {
                    [sender setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn5 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    [btn6 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    [btn7 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    [btn8 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    
                    scroType3=1;
                }
                    break;
                case 1:
                {
                    [btn1 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn5 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    [btn6 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    [btn7 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    scroType3=2;
                    
                }
                    break;
                case 2:
                {
                    
                    [btn1 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn2 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn5 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    [btn6 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    scroType3=3;
                    
                }
                    break;
                case 3:
                {
                    
                    [btn1 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn2 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn3 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn5 setImage:[UIImage imageNamed:@"comment_star_gray.png"] forState:UIControlStateNormal];
                    scroType3=4;
                    
                }
                    break;
                case 4:
                {
                    
                    [btn1 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn2 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn3 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [btn4 setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"comment_star.png"] forState:UIControlStateNormal];
                    scroType3=5;
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}
-(void)leftBtnCilck
{
    if (self.idStr==nil)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
