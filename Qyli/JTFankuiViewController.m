//
//  JTFankuiViewController.m
//  清一丽
//
//  Created by 小七 on 15-4-2.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTFankuiViewController.h"

@interface JTFankuiViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIScrollView * _bigScrollView;
    UITextView * _textView;
    UITableView *_tabView;
    UITextField * _textField;
    NSString * _selectType;
    NSArray * _titleArr;
}

@end

@implementation JTFankuiViewController

-(void)viewWillAppear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=YES;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView3.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=NO;
    appDelegate.tabBarView2.hidden=NO;
    appDelegate.tabBarView3.hidden=NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self readyUI];
    _selectType=@"1";
    _titleArr=[[NSArray alloc] initWithObjects:@"账户问题",@"使用问题",@"其他", nil];
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
    navTitailLab.text=@"意见或建议";
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
    
    UIImageView * textViewBgImgView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_box_org.png"]];
    textViewBgImgView1.frame=CGRectMake(8,8, self.view.frame.size.width-8*2, 44);
    textViewBgImgView1.userInteractionEnabled=YES;
    [_bigScrollView addSubview:textViewBgImgView1];
    
    UILabel * lab1=[[UILabel alloc] initWithFrame:CGRectMake(2, 2, 96, 40)];
    lab1.text=@"问题类型";
    lab1.textColor=NAV_COLOR;
    lab1.font=[UIFont systemFontOfSize:15];
    lab1.textAlignment=NSTextAlignmentCenter;
    [textViewBgImgView1 addSubview:lab1];
    
    UILabel * lineLab1=[[UILabel alloc] initWithFrame:CGRectMake(99.5, 7, 0.5, 30)];
    lineLab1.backgroundColor=[UIColor grayColor];
    [textViewBgImgView1 addSubview:lineLab1];
    
    UIButton * typeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    typeBtn.tag=50;
    typeBtn.frame=CGRectMake(100, 2, SCREEN_WIDTH-20-100, 40);
    //[typeBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, 5, 10, SCREEN_WIDTH-20-100-10-100)];
    [typeBtn setTitle:@"账户问题" forState:UIControlStateNormal];
    [typeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    typeBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [typeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [textViewBgImgView1 addSubview:typeBtn];
    
    UIImageView * jiantouImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头.png"]];
    jiantouImgView.frame=CGRectMake(SCREEN_WIDTH-20-100-15, 15, 8, 10);
    [typeBtn addSubview:jiantouImgView];
    
    UIView * shadowView=[[UIView alloc] initWithFrame:self.view.frame];
    shadowView.tag=301;
    shadowView.backgroundColor=[UIColor blackColor];
    shadowView.alpha=0.4;
    shadowView.hidden=YES;
    [self.view addSubview:shadowView];
    
    _tabView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.view.center.y-100,self.view.frame.size.width,172) style:UITableViewStylePlain];
    _tabView.showsVerticalScrollIndicator=NO;
    _tabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tabView.delegate=self;
    _tabView.dataSource=self;
    _tabView.hidden=YES;
    [self.view addSubview:_tabView];
    
    
    //comment_input_bg.9.png
    UIImageView * textViewBgImgView2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_box_org.png"]];
    textViewBgImgView2.frame=CGRectMake(8,66, self.view.frame.size.width-8*2, 164);
    textViewBgImgView2.userInteractionEnabled=YES;
    [_bigScrollView addSubview:textViewBgImgView2];
    
    
    _textView=[[UITextView alloc] init];
    _textView.frame=CGRectMake(2,2, self.view.frame.size.width-20,120);
    _textView.font=[UIFont systemFontOfSize:14];
    _textView.delegate=self;
    [textViewBgImgView2 addSubview:_textView];
    
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
    
    
    UIImageView * lineImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
    lineImgView.frame=CGRectMake(0, 125, self.view.frame.size.width-16, 5);
    [textViewBgImgView2 addSubview:lineImgView];
    
    
    _textField=[[UITextField alloc] initWithFrame:CGRectMake(5, 130,  self.view.frame.size.width-26, 30)];
    _textField.placeholder=@"手机/邮箱";
    _textField.font=[UIFont systemFontOfSize:14];
    _textField.delegate=self;
    [textViewBgImgView2 addSubview:_textField];
    
    
    UIButton * commentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame=CGRectMake(10, 10+CGRectGetHeight(textViewBgImgView1.frame)+10+CGRectGetHeight(textViewBgImgView2.frame)+15, self.view.frame.size.width-20, 35);
    commentBtn.backgroundColor=NAV_COLOR;
    [commentBtn setTitle:@"提  交" forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commentBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [commentBtn addTarget:self action:@selector(commentBtn) forControlEvents:UIControlEventTouchUpInside];
    [_bigScrollView addSubview:commentBtn];
    
    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 240);
}
- (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width,550);
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
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{

    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width,240);
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width,550);
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
   _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width,240);
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width,240);
}
-(void)typeBtnClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    UIView * shadowView=[self.view viewWithTag:301];
    shadowView.hidden=NO;
    _tabView.hidden=NO;
    [self.view bringSubviewToFront:_tabView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, self.view.frame.size.width, 0.5)];
        lineLab.backgroundColor=[UIColor brownColor];
        [cell addSubview:lineLab];
        
    }
    cell.textLabel.text=[_titleArr objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView * shadowView=[self.view viewWithTag:301];
    shadowView.hidden=YES;
    _tabView.hidden=YES;
    
    UIButton * btn=(UIButton *)[self.view viewWithTag:50];
    [btn setTitle:[_titleArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    _selectType=[NSString stringWithFormat:@"%d",indexPath.row+1];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:77.0/255.0 blue:110.0/255.0 alpha:1];
    UILabel * lab=[[UILabel alloc] initWithFrame:view.frame];
    lab.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:77.0/255.0 blue:110.0/255.0 alpha:1];
    lab.text=@"选择问题类型";
    lab.textAlignment=NSTextAlignmentCenter;
    lab.textColor=[UIColor whiteColor];
    lab.font=[UIFont systemFontOfSize:20];
    [view addSubview:lab];
    return view;
    
}
-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(void)commentBtn
{
    [self.view endEditing:YES];
    
    if ([_textView.text isEqualToString:@""])
    {
        NSString * str=@"请填写您要反馈的信息！";
        [JTAlertViewAnimation startAnimation:str view:self.view];
        return;
    }
    else if ([_textField.text isEqualToString:@""])
    {
        NSString * str=@"请填写您的联系方式，以便我们尽快为您做出解答！";
        [JTAlertViewAnimation startAnimation:str view:self.view];
        return;
    }
    else if ([self validateMobile:_textField.text]==0&&[self isValidateEmail:_textField.text]==0)
    {
        NSString * str=@"请输入合法的联系方式，以便我们尽快为您做出解答！";
        [JTAlertViewAnimation startAnimation:str view:self.view];
        return;
    }
    if ([SOAPRequest checkNet])
    {
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_selectType,@"type",_textView.text,@"content",_textField.text,@"linkway", nil];
        NSDictionary * zaojiaoEvaluateDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_SaveFeedBack] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoEvaluateDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"反馈成功，我们将尽快为您做出解答，请耐心等待" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK,我知道了。。", nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
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
