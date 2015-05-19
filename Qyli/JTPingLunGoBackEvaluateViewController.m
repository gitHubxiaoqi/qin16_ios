//
//  JTPingLunGoBackEvaluateViewController.m
//  Qyli
//
//  Created by 小七 on 14-12-4.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTPingLunGoBackEvaluateViewController.h"
#import "JTZaojiaoEvaluateSectionHeaderView.h"
#import "JTZaojiaoEvaluateTableViewCell.h"


@interface JTPingLunGoBackEvaluateViewController ()<UITextFieldDelegate>
{
    UITextField * textFiled;
    UIScrollView * emotionView;
    int keyBoardHeight;
}
@end
@implementation JTPingLunGoBackEvaluateViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView3.hidden=NO;
    appDelegate.tabBarView2.hidden=NO;
    appDelegate.tabBarView.hidden=NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView3.hidden=YES;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView.hidden=YES;
    [super viewDidAppear:animated];
     emotionView.contentSize=CGSizeMake(self.view.frame.size.width *3, 216);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    keyBoardHeight=0;
    [self readyUI];
}
#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    NSDictionary *userInfo = [notification userInfo];
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    ///   [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
    
    keyBoardHeight=keyboardRect.size.height;
    //NSLog(@"￥￥￥￥￥￥￥￥￥￥%d",keyBoardHeight);
    
    UIView * view=[self.view viewWithTag:80];
    CGRect rect= view.frame;
    rect.origin.y=self.view.frame.size.height-keyBoardHeight-49;
    view.frame=rect;
    [self.view bringSubviewToFront:view];
    
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
    navTitailLab.text=@"回复";
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
    
    if (self.state==10000)
    {
        JTZaojiaoEvaluateSectionHeaderView * view1=[[JTZaojiaoEvaluateSectionHeaderView alloc] init];
        view1.bounds=CGRectMake(0, 0, self.view.frame.size.width, 71);
        [view1.headImgView setImageWithURL:[NSURL URLWithString:_evaluateModel.userHeadPortraitURLStr] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
        view1.scroe=[_evaluateModel.scroeAvg intValue];
        view1.dateLab.text=_evaluateModel.reviewDate;
        view1.contentLab.text=[NSString stringWithFormat:@"    %@",_evaluateModel.context];
        view1.userNameLab.text=_evaluateModel.userName;
        view1.backReviewCountLab.text=[NSString stringWithFormat:@"回复(%@)",_evaluateModel.backReviewCount];
        if ([[NSString stringWithFormat:@"%@",_evaluateModel.backReviewCount] intValue]>=4)
        {
            view1.backReviewCountLab.text=[NSString stringWithFormat:@"回复(%@)",self.totalCount];
        }
        [view1.backReViewBtn addTarget:self  action:@selector(backReView) forControlEvents:UIControlEventTouchUpInside];
        view1.openBtn.hidden=YES;
        
        NSDictionary * dic=[[NSDictionary alloc] initWithObjectsAndKeys:view1.contentLab.font,NSFontAttributeName, nil];
        CGSize autoSize=[view1.contentLab.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-90-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        if (autoSize.height<40)
        {
            autoSize.height=40;
        }
        view1.contentLab.frame=CGRectMake(90, 25, self.view.frame.size.width-90-30, autoSize.height+10);
        [view1 refreshStarAndUI];
        view1.frame=CGRectMake(0, 64, self.view.frame.size.width, 71+autoSize.height);
        [self.view addSubview:view1];
        
    }
    else
    {
        JTZaojiaoEvaluateTableViewCell * cell=
        [[JTZaojiaoEvaluateTableViewCell alloc] init];
        [cell.headImgView setImageWithURL:[NSURL URLWithString:_backEvaluateModel.userHeadPortraitURLStr] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
        cell.userNameLab.text=_backEvaluateModel.userName;
        NSDictionary * dic1=[[NSDictionary alloc] initWithObjectsAndKeys: cell.userNameLab.font,NSFontAttributeName, nil];
        CGSize autoSize1=[cell.userNameLab.text boundingRectWithSize:CGSizeMake(120, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil].size;
        cell.userNameLab.frame=CGRectMake(50, 10, autoSize1.width, 20);
        
        cell.receiverNameLab.text=_backEvaluateModel.receiverName;
        NSDictionary * dic2=[[NSDictionary alloc] initWithObjectsAndKeys: cell.receiverNameLab.font,NSFontAttributeName, nil];
        CGSize autoSize2=[cell.receiverNameLab.text boundingRectWithSize:CGSizeMake(120, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic2 context:nil].size;
        cell.receiverNameLab.frame=CGRectMake(50+autoSize1.width+30, 10, autoSize2.width, 20);
        
        cell.contentLab.text=[NSString stringWithFormat:@"    %@",_backEvaluateModel.context];
        NSDictionary * dic=[[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
        CGSize autoSize=[cell.contentLab.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20-50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        cell.contentLab.frame=CGRectMake(50, 30,self.view.frame.size.width-20-50, autoSize.height+10);
        cell.dateLab.text=_backEvaluateModel.backReviewDate;
        [cell.backReViewBtn addTarget:self action:@selector(backBackReview) forControlEvents:UIControlEventTouchUpInside];
        [cell refreshUI];
        cell.frame=CGRectMake(0, 64, self.view.frame.size.width, 81+autoSize.height);
        [self.view addSubview:cell];
    }
    
    UIView * bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49)];
    bottomView.backgroundColor=[UIColor blackColor];
    bottomView.tag=80;
    [self.view addSubview:bottomView];
    
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"up_button_checked.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(chooseEditStyle:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame=CGRectMake(5, 10, 30, 30);
    [bottomView addSubview:btn];
    
    UIImageView * imgView=[[UIImageView alloc] initWithFrame:CGRectMake(40, 8, self.view.frame.size.width-40-50-10, 33)];
    imgView.image=[UIImage imageNamed:@"mine_item_little.png"];
    imgView.userInteractionEnabled=YES;
    [bottomView addSubview:imgView];
    
    textFiled=[[UITextField alloc] initWithFrame:CGRectMake(5, 2, self.view.frame.size.width-40-50-10-5*2, 28)];
    textFiled.placeholder=@"请输入内容...";
    textFiled.delegate=self;
    [imgView addSubview:textFiled];
    
    UIButton * btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"top_btn_bg.png"] forState:UIControlStateNormal];
    [btn2 setTitle:@"评价" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(commitContent) forControlEvents:UIControlEventTouchUpInside];
    btn2.frame=CGRectMake(self.view.frame.size.width-50-5, 8, 50, 33);
    [bottomView addSubview:btn2];
    
}
#pragma mark -textFiled代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    UIView * bottomView=[[textFiled superview] superview];
//    CGRect rect= bottomView.frame;
//    rect.origin.y=self.view.frame.size.height-49-216;
//    bottomView.frame=rect;
//    [self.view bringSubviewToFront:bottomView];
    
    UIView * view1=[self.view viewWithTag:30];
    [view1 removeFromSuperview];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UIView * bottomView=[[textFiled superview] superview];
    CGRect rect= bottomView.frame;
    rect.origin.y=self.view.frame.size.height-49;
    bottomView.frame=rect;
    [self.view bringSubviewToFront:bottomView];
    
    UIView * view1=[self.view viewWithTag:30];
    [view1 removeFromSuperview];
}
-(void)chooseEditStyle:(UIButton *)sender
{
    
    UIImageView * imgView=[[UIImageView alloc] initWithFrame:CGRectMake(20,sender.superview.frame.origin.y -40, 60, 40)];
    imgView.tag=60;
    imgView.image=[UIImage imageNamed:@"black_bg.png"];
    imgView.userInteractionEnabled=YES;
    [self.view addSubview:imgView];
    [self.view bringSubviewToFront:imgView];
    
    for (int i=0; i<2; i++)
    {
        UIButton * btn=[UIButton  buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i+10;
        if (i==0)
        {
            [btn setImage:[UIImage imageNamed:@"writing_icon.png"] forState:UIControlStateNormal];
        }
        else
        {
            [btn setImage:[UIImage imageNamed:@"face_icon.png"] forState:UIControlStateNormal];
        }
        btn.frame=CGRectMake(5+i*25, 5, 25, 30);
        [imgView addSubview:btn];
    }
    
}
-(void)choose:(UIButton *)sender
{
    
    if (sender.tag==10)
    {
        [textFiled becomeFirstResponder];
//        UIView * view=[self.view viewWithTag:80];
//        CGRect rect= view.frame;
//        rect.origin.y=self.view.frame.size.height-216-49;
//        view.frame=rect;
//        [self.view bringSubviewToFront:view];
        
    }
    else
    {
        UIView * view1=[self.view viewWithTag:30];
        [view1 removeFromSuperview];

        [textFiled resignFirstResponder];
        UIView * view=[self.view viewWithTag:80];
        CGRect rect= view.frame;
        rect.origin.y=self.view.frame.size.height-216-49;
        view.frame=rect;
        [self.view bringSubviewToFront:view];
        
        emotionView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
        emotionView.panGestureRecognizer.delaysTouchesBegan = YES;
        emotionView.tag=30;
        emotionView.backgroundColor=[UIColor yellowColor];
        emotionView.contentSize=CGSizeMake(self.view.frame.size.width*3, 216);
        emotionView.pagingEnabled=YES;
        for (int i=0; i<3; i++)
        {
            UIControl* view=[[UIControl alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, 216)];
            [emotionView addSubview:view];
            for (int j=0; j<28; j++)
            {
                UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame=CGRectMake((self.view.frame.size.width-40*7)/8.0+j%7*(40+(self.view.frame.size.width-40*7)/8.0), 11+j/7*(40+11), 40, 40);
                btn.tag=200+j+i*28;
                if (btn.tag<210)
                {
                    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"f00%d.png",btn.tag-200]] forState:UIControlStateNormal];
                }
                else
                {
                    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"f0%d.png",btn.tag-200]] forState:UIControlStateNormal];
                }
                
                [btn addTarget:self action:@selector(emotionBtn:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btn];
            }
        }
        [self.view addSubview:emotionView];
        
    }
    [sender.superview removeFromSuperview];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UIView * view1=[self.view viewWithTag:30];
    [view1 removeFromSuperview];
    UIView * view2=[self.view viewWithTag:60];
    [view2 removeFromSuperview];
    [textFiled resignFirstResponder];
    UIView * view=[self.view viewWithTag:80];
    CGRect rect= view.frame;
    rect.origin.y=self.view.frame.size.height-49;
    view.frame=rect;
    [self.view bringSubviewToFront:view];
    
}
-(void)emotionBtn:(UIButton *)sender
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"emotion" ofType:@"plist"];
    NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString * str=[dictionary objectForKey:[NSString stringWithFormat:@"%d",sender.tag-200+1]];
    textFiled.text=[textFiled.text stringByAppendingString:str];
}
-(void)commitContent
{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"0"])
    {
        UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您尚未登录，请先登录。。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK,我知道了。。", nil];
        [alertView show];
        JTLoginViewController * loginVC=[[JTLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    if ([textFiled.text isEqualToString:@""])
    {
        NSString * str=@"内容不能为空！";
        [JTAlertViewAnimation startAnimation:str view:self.view];
        return;
    }
    
    JTAppDelegate * appDelegate= [UIApplication sharedApplication].delegate;
    NSString * userID=[NSString stringWithFormat:@"%d",appDelegate.appUser.userID];

    
    if ([SOAPRequest checkNet])
    {
        
        //7.5保存回复信息
        NSDictionary * jsondic=[[NSDictionary alloc] init];
        if (self.state==10000)
        {
           jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.evaluateModel.mappingIDStr,@"mappingId",self.evaluateModel.infoIDStr,@"infoId",userID,@"userId",textFiled.text,@"context",self.evaluateModel.idStr,@"parentId",self.evaluateModel.userIDStr,@"receiverId", nil];

        }
        else
        {
          jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.backEvaluateModel.mappingIDStr,@"mappingId",self.backEvaluateModel.infoIDStr,@"infoId",userID,@"userId",textFiled.text,@"context",_backEvaluateModel.parentIDStr,@"parentId",self.backEvaluateModel.userIdStr,@"receiverId", nil];
        }

        NSDictionary * evsluateDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Review_SaveBackReview] jsonDic:jsondic]];

        if ([[NSString stringWithFormat:@"%@",[evsluateDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"回复成功！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK,我知道了。。", nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
        
    }
    
    UIView * view1=[self.view viewWithTag:30];
    [view1 removeFromSuperview];
    [textFiled resignFirstResponder];
    UIView * view=[self.view viewWithTag:80];
    CGRect rect= view.frame;
    rect.origin.y=self.view.frame.size.height-49;
    view.frame=rect;
    [self.view bringSubviewToFront:view];
    textFiled.text=@"";
    
    
}

-(void)backReView
{
//    UIView * bottomView=[[textFiled superview] superview];
//    CGRect rect= bottomView.frame;
//    rect.origin.y=self.view.frame.size.height-49-216;
//    bottomView.frame=rect;
//    [self.view bringSubviewToFront:bottomView];
    
    UIView * view1=[self.view viewWithTag:30];
    [view1 removeFromSuperview];
    [textFiled becomeFirstResponder];
}
-(void)backBackReview
{
//    UIView * bottomView=[[textFiled superview] superview];
//    CGRect rect= bottomView.frame;
//    rect.origin.y=self.view.frame.size.height-49-216;
//    bottomView.frame=rect;
//    [self.view bringSubviewToFront:bottomView];
    
    UIView * view1=[self.view viewWithTag:30];
    [view1 removeFromSuperview];
    [textFiled becomeFirstResponder];
}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
