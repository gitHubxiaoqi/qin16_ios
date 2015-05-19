//
//  JTLuntanDetailViewController.m
//  清一丽
//
//  Created by 小七 on 15-4-10.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTLuntanDetailViewController.h"
#import "JTLuntanListTableViewCell.h"
#import "JTLuntanPostListTableViewCell.h"

@interface JTLuntanDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView * _tableView;
    int keyBoardHeight;
     UITextField * textFiled;
    UIScrollView* emotionView;
    
    int q;
    int pageNum;
    NSMutableArray * _listModelArr;
}
@property(nonatomic,strong)JTSortModel * yuantieModel;

@end

@implementation JTLuntanDetailViewController
-(void)viewWillDisappear:(BOOL)animated
{
    
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=NO;
    appDelegate.tabBarView2.hidden=NO;
    appDelegate.tabBarView3.hidden=NO;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=YES;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView3.hidden=YES;
    
    [self sendPost];
    //[self readyUIAgain];
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
    
    UIView * view=[self.view viewWithTag:20];
    CGRect rect= view.frame;
    rect.origin.y=self.view.frame.size.height-keyBoardHeight-49;
    view.frame=rect;
    [self.view bringSubviewToFront:view];
    
}
//- (void)keyboardWillHide:(NSNotification *)notification {
//    NSDictionary* userInfo = [notification userInfo];
//    /*
//     Restore the size of the text view (fill self's view).
//     Animate the resize so that it's in sync with the disappearance of the keyboard.
//     */
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//   /// [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    keyBoardHeight=0;

    
    q=3;
    pageNum=1;
    _listModelArr=[[NSMutableArray alloc] initWithCapacity:0];
    _yuantieModel=[[JTSortModel alloc] init];
    
    [self readyUI];
 
}
-(void)readyUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden=YES;
    //自定义导航条
    UIView * navBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    navBarView.userInteractionEnabled=YES;
    navBarView.backgroundColor=NAV_COLOR;
    [self.view addSubview:navBarView];
    
    UILabel * navTitailLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navTitailLab.text=@"详情";
    navTitailLab.textAlignment=NSTextAlignmentCenter;
    navTitailLab.textColor=[UIColor whiteColor];
    navTitailLab.font=[UIFont systemFontOfSize:22];
    [navBarView addSubview:navTitailLab];
    
    UIButton * leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 2, 50, 40);
    [leftBtn addTarget:self action:@selector(leftBtnCilck) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    
    UIImageView * jiantouImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回按钮.png"]];
    jiantouImgView.frame=CGRectMake(20, 15, 10, 14);
    [leftBtn addSubview:jiantouImgView];
    
    
    UIButton * rightBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn2.frame=CGRectMake(SCREEN_WIDTH-40, (NAV_HEIGHT-20)/2, 20, 20);
    [rightBtn2 setBackgroundImage:[UIImage imageNamed:@"分享新.png"] forState:UIControlStateNormal];
    [rightBtn2 addTarget:self action:@selector(rightBtnClick2) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:rightBtn2];

    
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,self.view.frame.size.height-64-TAB_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [_tableView addHeaderWithTarget:self action:@selector(CompanyListHeaderRefreshing)];
    [_tableView addFooterWithTarget:self  action:@selector(footerRefresh)];
    _tableView.headerRefreshingText =@HeaderRefreshingText;
    _tableView.footerRefreshingText=@FooterRefreshingText;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIView * bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49)];
    bottomView.backgroundColor=[UIColor blackColor];
    bottomView.tag=20;
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
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
    NSLog(@"选择输入方式");
    
    UIImageView * imgView=[[UIImageView alloc] initWithFrame:CGRectMake(20,sender.superview.frame.origin.y -40, 60, 40)];
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
        NSLog(@"文字");
        [textFiled becomeFirstResponder];
    }
    else
    {
        UIView * view1=[self.view viewWithTag:30];
        [view1 removeFromSuperview];
        NSLog(@"表情");
        [textFiled resignFirstResponder];
        UIView * view=[self.view viewWithTag:20];
        CGRect rect= view.frame;
        rect.origin.y=self.view.frame.size.height-216-49;
        view.frame=rect;
        
        emotionView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
        emotionView.tag=30;
        emotionView.backgroundColor=[UIColor yellowColor];
        emotionView.panGestureRecognizer.delaysTouchesBegan=YES;
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
        
        
        [self.view bringSubviewToFront:view];
        
    }
    [sender.superview removeFromSuperview];
}
-(void)emotionBtn:(UIButton *)sender
{
    NSLog(@"第%d个",sender.tag-200);
    NSString* path = [[NSBundle mainBundle] pathForResource:@"emotion" ofType:@"plist"];
    NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString * str=[dictionary objectForKey:[NSString stringWithFormat:@"%d",sender.tag-200+1]];
    textFiled.text=[textFiled.text stringByAppendingString:str];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UIView * view1=[self.view viewWithTag:30];
    [view1 removeFromSuperview];
    [textFiled resignFirstResponder];
    UIView * view=[self.view viewWithTag:20];
    CGRect rect= view.frame;
    rect.origin.y=self.view.frame.size.height-49;
    view.frame=rect;
    [self.view bringSubviewToFront:view];
    
}
-(void)commitContent
{
    NSLog(@"提交评价");
    
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
        NSString * str=@"内容不能为空!";
        [JTAlertViewAnimation startAnimation:str view:self.view];
        return;
    }
    JTAppDelegate * appDelegate=[UIApplication sharedApplication].delegate;
    
    NSString * userID=[NSString stringWithFormat:@"%d",appDelegate.appUser.userID];
    
    if ([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:userID,@"userId",textFiled.text,@"content",self.sortModel.idStr,@"topicId",nil];
        NSDictionary * evsluateDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Luntan_SavePostAdd] jsonDic:jsondic]];
        if ([[NSString stringWithFormat:@"%@",[evsluateDic objectForKey:@"resultCode"]] intValue]==1000)
        {
            NSString * str=@"评论成功!";
            [JTAlertViewAnimation startAnimation:str view:self.view];
            [self sendPost];
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
    UIView * view=[self.view viewWithTag:20];
    CGRect rect= view.frame;
    rect.origin.y=self.view.frame.size.height-49;
    view.frame=rect;
    [self.view bringSubviewToFront:view];
    textFiled.text=@"";
    
    
}

#pragma mark - 表代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listModelArr.count+1;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        JTSortModel * model=[[JTSortModel alloc] init];
         model=_yuantieModel;
        
        CGSize topicAutoSize=[model.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        if (topicAutoSize.height<20)
        {
            topicAutoSize.height=20;
        }
        
        CGSize contentAutoSize=[ model.name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        if (contentAutoSize.height<20)
        {
            contentAutoSize.height=20;
        }
        
        if (model.imgUrlArr.count==0)
        {
            return 60+topicAutoSize.height+contentAutoSize.height+10+30+20;
            
        }
        else if (model.imgUrlArr.count==1)
        {
            return 60+topicAutoSize.height+contentAutoSize.height+10+100+10+30+20;
        }
        else if (model.imgUrlArr.count==2)
        {
            return 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+20;
            
        }
        else if (model.imgUrlArr.count==3)
        {
            return 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+20;
            
        }
        else if (model.imgUrlArr.count==4)
        {
            return 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+20;
            
        }
        else
        {
            return 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+20;
        }

    }
    else
    {
        JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row-1];
        
        CGSize contentAutoSize=[ model.name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        if (contentAutoSize.height<20)
        {
            contentAutoSize.height=20;
        }
        return 40+contentAutoSize.height+10;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        JTLuntanListTableViewCell * customCell=[[JTLuntanListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        customCell.selectionStyle=UITableViewCellSelectionStyleNone;
        customCell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
        //[customCell refreshCell:_yuantieModel];

        
        JTSortModel * model=[[JTSortModel alloc] init];
        model=_yuantieModel;
        
        [customCell.photoImgView setImageWithURL:[NSURL URLWithString:model.user.headPortraitImgUrlStr] placeholderImage:[UIImage imageNamed:@"头像.png"]];
        customCell.nameLab.text=model.user.userName;
        customCell.dateLab.text=model.registTime;
        customCell.topicLab.text=model.title;
        CGSize topicAutoSize=[customCell.topicLab.text boundingRectWithSize:CGSizeMake(customCell.bounds.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:customCell.topicLab.font} context:nil].size;
        if (topicAutoSize.height<20)
        {
            topicAutoSize.height=20;
        }
        customCell.topicLab.bounds=CGRectMake(0, 0, customCell.bounds.size.width-20, topicAutoSize.height);
        
        customCell.contentLab.text=model.name;
        CGSize contentAutoSize=[customCell.contentLab.text boundingRectWithSize:CGSizeMake(customCell.bounds.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:customCell.contentLab.font} context:nil].size;
        if (contentAutoSize.height<20)
        {
            contentAutoSize.height=20;
        }
        customCell.contentLab.frame=CGRectMake(10, 60+topicAutoSize.height, customCell.bounds.size.width-20, contentAutoSize.height);
        
        if (model.imgUrlArr.count==0)
        {
            customCell.bigImgView.hidden=YES;
            customCell.imgView1.hidden=YES;
            customCell.imgView2.hidden=YES;
            customCell.imgView3.hidden=YES;
            customCell.imgView4.hidden=YES;
            customCell.bottomView.frame=CGRectMake(0, 60+topicAutoSize.height+contentAutoSize.height+10, SCREEN_WIDTH, 30);
            customCell.bounds=CGRectMake(0, 0, SCREEN_WIDTH,  60+topicAutoSize.height+contentAutoSize.height+10+30+20);
            customCell.bgImgView.frame=CGRectMake(0, 5, SCREEN_WIDTH, 60+topicAutoSize.height+contentAutoSize.height+10+30+10);
        }
        else if (model.imgUrlArr.count==1)
        {
            customCell.bigImgView.hidden=NO;
            [customCell.bigImgView setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
            customCell.imgView1.hidden=YES;
            customCell.imgView2.hidden=YES;
            customCell.imgView3.hidden=YES;
            customCell.imgView4.hidden=YES;
            customCell.bigImgView.frame=CGRectMake(10,  60+topicAutoSize.height+contentAutoSize.height+10, SCREEN_WIDTH-20, 100);
            customCell.bottomView.frame=CGRectMake(0, 60+topicAutoSize.height+contentAutoSize.height+10+100+10, SCREEN_WIDTH, 30);
            customCell.bounds=CGRectMake(0, 0, SCREEN_WIDTH,  60+topicAutoSize.height+contentAutoSize.height+10+100+10+30+20);
            customCell.bgImgView.frame=CGRectMake(0, 5, SCREEN_WIDTH, 60+topicAutoSize.height+contentAutoSize.height+10+100+10+30+10);
        }
        else if (model.imgUrlArr.count==2)
        {
            customCell.bigImgView.hidden=YES;
            customCell.imgView1.hidden=NO;
            [customCell.imgView1 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
            customCell.imgView2.hidden=NO;
            [customCell.imgView2 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
            customCell.imgView3.hidden=YES;
            customCell.imgView4.hidden=YES;
            customCell.imgView1.frame=CGRectMake(10,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
            customCell.imgView2.frame=CGRectMake(10+(SCREEN_WIDTH-20-30)/4.0+10,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
            customCell.bottomView.frame=CGRectMake(0, 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10, SCREEN_WIDTH, 30);
            customCell.bounds=CGRectMake(0, 0, SCREEN_WIDTH,  60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+20);
            customCell.bgImgView.frame=CGRectMake(0, 5, SCREEN_WIDTH, 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+10);
        }
        else if (model.imgUrlArr.count==3)
        {
            customCell.bigImgView.hidden=YES;
            customCell.imgView1.hidden=NO;
            [customCell.imgView1 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
            customCell.imgView2.hidden=NO;
            [customCell.imgView2 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
            customCell.imgView3.hidden=NO;
            [customCell.imgView3 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
            customCell.imgView4.hidden=YES;
            customCell.imgView1.frame=CGRectMake(10,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
            customCell.imgView2.frame=CGRectMake(10+(SCREEN_WIDTH-20-30)/4.0+10,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
            customCell.imgView3.frame=CGRectMake(10+(SCREEN_WIDTH-20-30)/4.0*2+20,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
            customCell.bottomView.frame=CGRectMake(0, 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10, SCREEN_WIDTH, 30);
            customCell.bounds=CGRectMake(0, 0, SCREEN_WIDTH,  60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+20);
            customCell.bgImgView.frame=CGRectMake(0, 5, SCREEN_WIDTH, 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+10);
        }
        else if (model.imgUrlArr.count==4)
        {
            customCell.bigImgView.hidden=YES;
            customCell.imgView1.hidden=NO;
            [customCell.imgView1 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
            customCell.imgView2.hidden=NO;
            [customCell.imgView2 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
            customCell.imgView3.hidden=NO;
            [customCell.imgView3 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
            customCell.imgView4.hidden=NO;
            [customCell.imgView4 setImageWithURL:[NSURL URLWithString:[model.imgUrlArr objectAtIndex:3]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
            customCell.imgView1.frame=CGRectMake(10,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
            customCell.imgView2.frame=CGRectMake(10+(SCREEN_WIDTH-20-30)/4.0+10,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
            customCell.imgView3.frame=CGRectMake(10+(SCREEN_WIDTH-20-30)/4.0*2+20,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
            customCell.imgView3.frame=CGRectMake(10+(SCREEN_WIDTH-20-30)/4.0*3+30,  60+topicAutoSize.height+contentAutoSize.height+10, (SCREEN_WIDTH-20-30)/4.0, (SCREEN_WIDTH-20-30)/5.0);
            customCell.bottomView.frame=CGRectMake(0, 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10, SCREEN_WIDTH, 30);
            customCell.bounds=CGRectMake(0, 0, SCREEN_WIDTH,  60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+20);
            customCell.bgImgView.frame=CGRectMake(0, 5, SCREEN_WIDTH, 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+10);
        }
        customCell.chatImgView.hidden=YES;
        customCell.chatLab.hidden=YES;
        customCell.dingLab.text=model.beginDate;
        customCell.caiLab.text=model.endDate;
        //customCell.chatLab.text=model.commentCount;
        customCell.bgImgView.userInteractionEnabled=YES;
        
        UIButton * dingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        dingBtn.frame=CGRectMake(0, 0, 80, 30);
        dingBtn.tag=1000;
        [dingBtn addTarget:self action:@selector(dingcai:) forControlEvents:UIControlEventTouchUpInside];
        [customCell.bottomView addSubview:dingBtn];
        
        UIButton * caiBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        caiBtn.frame=CGRectMake(80, 0, 80, 30);
        caiBtn.tag=2000;
        [caiBtn addTarget:self action:@selector(dingcai:) forControlEvents:UIControlEventTouchUpInside];
        [customCell.bottomView addSubview:caiBtn];
        
        return customCell;
    }
    else
    {
        JTLuntanPostListTableViewCell * customCell=[tableView dequeueReusableCellWithIdentifier:@"customCell"];
        if (!customCell)
        {
            customCell=[[JTLuntanPostListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell1"];
            customCell.selectionStyle=UITableViewCellSelectionStyleNone;
            customCell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
            UILabel * lineLab=[[UILabel alloc] init];
            lineLab.tag=10000+indexPath.row;
            [customCell addSubview:lineLab];
        }
        JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row-1];
        [customCell.photoImgView setImageWithURL:[NSURL URLWithString:model.user.headPortraitImgUrlStr] placeholderImage:[UIImage imageNamed:@"头像"]];
        customCell.nameLab.text=model.user.userName;
        customCell.dateLab.text=model.registTime;
        customCell.contentLab.text=model.name;
        CGSize contentAutoSize=[ model.name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        if (contentAutoSize.height<20)
        {
            contentAutoSize.height=20;
        }
        customCell.contentLab.frame=CGRectMake(50, 40, SCREEN_WIDTH, contentAutoSize.height);
        UILabel * lineLab=(UILabel *)[customCell viewWithTag:10000+indexPath.row];
        lineLab.frame=CGRectMake(0, 40+contentAutoSize.height+10-1, self.view.frame.size.width, 0.5);
        lineLab.backgroundColor=[UIColor brownColor];
        [customCell addSubview:lineLab];
        
        return customCell;
    
    }
    
}
-(void)dingcai:(UIButton *)sender
{
    [self.view endEditing:YES];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"0"])
    {
        UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您尚未登录，请先登录。。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK,我知道了。。", nil];
        [alertView show];
        JTLoginViewController * loginVC=[[JTLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    NSString * str=@"";
    if (sender.tag==1000)
    {
        str=@"1";
    }
    else
    {
        str=@"2";
    }
    if ([SOAPRequest checkNet])
    {
        JTAppDelegate * appDelegate= [UIApplication sharedApplication].delegate;
        NSString * userID=@"";
        userID=[NSString stringWithFormat:@"%d",appDelegate.appUser.userID];
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.sortModel.idStr,@"topicId",userID,@"userId",str,@"upOrDown", nil];
        
        NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Luntan_SavePostUpAndDown] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            if ([str isEqualToString:@"1"])
            {
                NSString * str=@"顶成功！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
               JTLuntanListTableViewCell * cell=(JTLuntanListTableViewCell *)[_tableView cellForRowAtIndexPath:0];
                _yuantieModel.beginDate=[NSString stringWithFormat:@"%d",[cell.dingLab.text intValue]+1];

            }
            else if ([str isEqualToString:@"2"])
            {
                NSString * str=@"踩成功！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                JTLuntanListTableViewCell * cell=(JTLuntanListTableViewCell *)[_tableView cellForRowAtIndexPath:0];
                _yuantieModel.endDate=[NSString stringWithFormat:@"%d",[cell.caiLab.text intValue]+1];

            }
            [_tableView reloadData];

  

        }
        else if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"2012"])
        {
            NSString * str=@"抱歉，您已经顶/踩过了哦！";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
        else
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
    }
}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtnClick2
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"iTunesArtwork@2x" ofType:@"jpg"];
    
    NSString * shareUrlStr=@"http://www.qin16.com";
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"清一丽儿童网 立志打造南京最全面的儿童门户网站找辅导、买东西。惊喜连连，和你身边朋友一起分享%@",shareUrlStr] defaultContent:@"默认分享内容，没内容时显示" image:[ShareSDK imageWithPath:imagePath] title:@"#清一丽#门户网站特约分享" url:shareUrlStr description:[NSString stringWithFormat:@"我在#清一丽#发现了N条信息：清一丽儿童网 立志打造南京最全面的儿童门户网站找辅导、买东西。惊喜连连，和你身边朋友一起分享，很不错哦！%@",shareUrlStr] mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil shareList:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions: nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
     {
         if (state == SSResponseStateSuccess)
         {
             NSString * str=@"分享成功！";
             UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK，我知道了。。", nil];
             [alertView show];
             JTAppDelegate * appDelegate= [UIApplication sharedApplication].delegate;
             NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appDelegate.appUser.userID],@"userId",nil];
             [SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Share_UserShareAfter] jsonDic:jsondic];
         }
         else if (state == SSResponseStateFail)
         {
             
             NSString * str=[NSString stringWithFormat:@"分享失败！原因为：%@",[error errorDescription]];
             UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK，我知道了。。", nil];
             [alertView show];
         }
         
     }];
    
    
}
-(void)sendPost
{
    pageNum=1;
    [_listModelArr removeAllObjects];
    [_tableView reloadData];
    q=3;
    [_tableView headerBeginRefreshing];
}
-(void)CompanyListHeaderRefreshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 刷新表格
        [self GetCompanyListData];
        [_tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView headerEndRefreshing];
    });
}

-(void)footerRefresh
{
    pageNum++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //请求数据
        [self loadMoreData];
        // 刷新表格
        [_tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView footerEndRefreshing];
    });
}
-(void)GetCompanyListData
{
    if ([SOAPRequest checkNet])
    {
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.sortModel.idStr,@"topicId",@"1",@"currentPageNo",@"20",@"pageSize", nil];
        
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Luntan_GetPostListByTopicId] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            NSDictionary * yuantieDic=[[NSDictionary alloc] initWithDictionary:[zaojiaoListDic objectForKey:@"topic"]];
            _yuantieModel.idStr=[yuantieDic objectForKey:@"id"];
            _yuantieModel.title=[yuantieDic  objectForKey:@"title"];
            _yuantieModel.beginDate=[NSString stringWithFormat:@"%@",[yuantieDic objectForKey:@"up"]];
            _yuantieModel.endDate=[NSString stringWithFormat:@"%@",[yuantieDic objectForKey:@"down"]];
            _yuantieModel.commentCount=[NSString stringWithFormat:@"%@",[yuantieDic  objectForKey:@"subPostSum"]];
            
            _yuantieModel.registTime=[yuantieDic  objectForKey:@"publishTimeValue"];
            _yuantieModel.name=[yuantieDic objectForKey:@"firstPostContent"];
            _yuantieModel.imgUrlArr=[[NSArray alloc] initWithArray:[yuantieDic  objectForKey:@"picList"]];
            _yuantieModel.user=[[JTUser alloc] init];
            _yuantieModel.user.userName=[[yuantieDic  objectForKey:@"publisherUser"] objectForKey:@"userName"];
            _yuantieModel.user.headPortraitImgUrlStr=[[yuantieDic objectForKey:@"publisherUser"] objectForKey:@"imageValue"];
            [_tableView reloadData];
            
            if (q==3)
            {
                if ([[[zaojiaoListDic objectForKey:@"postPage"] objectForKey:@"totalCount"] intValue]==0)
                {
                    NSString * str=@"还没有人评论哦！快来抢沙发吧！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                    return;
                }
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"postPage"] objectForKey:@"list"];
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    JTSortModel * sortModel=[[JTSortModel alloc] init];
                    sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                    
                    sortModel.registTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"publishTimeValue"];
                    sortModel.name=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"content"];
                    sortModel.user=[[JTUser alloc] init];
                    sortModel.user.userName=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"publisherUser"] objectForKey:@"userName"];
                    sortModel.user.headPortraitImgUrlStr=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"publisherUser"] objectForKey:@"imageValue"];
                    
                    [_listModelArr addObject:sortModel];
            
                }
                q=6;
            }
            else
            {
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"postPage"] objectForKey:@"list"];
                ;
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    NSString * idStr=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"]];
                    BOOL isExist=0;
                    for (int j=0; j<[_listModelArr count]; j++)
                    {
                        JTSortModel * aModel=[_listModelArr objectAtIndex:j];
                        if ([[NSString stringWithFormat:@"%@",aModel.idStr] isEqualToString:idStr])
                        {
                            isExist=1;
                            break;
                        }
                    }
                    if (isExist==0)
                    {
                        JTSortModel * sortModel=[[JTSortModel alloc] init];
                        sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                        
                        sortModel.registTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"publishTimeValue"];
                        sortModel.name=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"content"];
                        sortModel.user=[[JTUser alloc] init];
                        sortModel.user.userName=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"publisherUser"] objectForKey:@"userName"];
                        sortModel.user.headPortraitImgUrlStr=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"publisherUser"] objectForKey:@"imageValue"];
                        
                        [_listModelArr insertObject:sortModel atIndex:0];
                     
                        
                    }
                }
                
            }
            
        }
        else
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
        
    }

}
-(void)loadMoreData
{
    if ([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.sortModel.idStr,@"topicId",[NSString stringWithFormat:@"%d",pageNum],@"currentPageNo",@"20",@"pageSize", nil];
        
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Luntan_GetPostListByTopicId] jsonDic:jsondic]];
        
        if ([[zaojiaoListDic objectForKey:@"resultCode"] intValue]==1000)
        {
            if ([[[zaojiaoListDic objectForKey:@"postPage"] objectForKey:@"list"]count]==0)
            {
                NSString * str=@"已全部加载完毕！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                pageNum--;
                return;
            }
            NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"postPage"] objectForKey:@"list"];
            for (int i=0; i<zaojiaoListArr.count; i++)
            {
                JTSortModel * sortModel=[[JTSortModel alloc] init];
                sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                
                sortModel.registTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"publishTimeValue"];
                sortModel.name=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"content"];
                sortModel.user=[[JTUser alloc] init];
                sortModel.user.userName=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"publisherUser"] objectForKey:@"userName"];
                sortModel.user.headPortraitImgUrlStr=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"publisherUser"] objectForKey:@"imageValue"];
                
                [_listModelArr addObject:sortModel];
   
            }
            
        }
        else
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
