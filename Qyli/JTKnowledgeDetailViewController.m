//
//  JTKnowledgeDetailViewController.m
//  清一丽
//
//  Created by 小七 on 14-12-29.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//




#import "JTKnowledgeDetailViewController.h"
#import "JTKnowledgeEvaluateTableViewCell.h"
@interface JTKnowledgeDetailViewController()<UITextFieldDelegate,UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSString * _htmlStr;
    UIScrollView * _bigScrollView;
    UIWebView * _webView;
    UITextField * textFiled;
    UITableView * _tableView;
    NSMutableArray * _subpageIdArr;
    NSMutableArray * _userNameArr;
    NSMutableArray * _dateArr;
    NSMutableArray * _evaluateContentArr;
    NSMutableArray * _picUrlStrArr;
    UIScrollView* emotionView;
    int p;
    int m;
    int q;
    int pageNum;
    int tableViewTotalHeight;
    int rowCount;
    
    int keyBoardHeight;
}
@property(nonatomic,strong)JTSortModel * model;
@end

@implementation JTKnowledgeDetailViewController
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
    appDelegate.tabBarView.hidden=YES;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView3.hidden=YES;
    


    if (p==1)
    {
        [self sendPost];
        if (m==9)
        {
           [self sendPost2];
        }
        m=18;
        [self readyUIAgain];
    }
    p=2;
}
-(void)viewWillDisappear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=NO;
    appDelegate.tabBarView2.hidden=NO;
    appDelegate.tabBarView3.hidden=NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
    p=1;
    q=3;
    _htmlStr=@"";
    tableViewTotalHeight=0;
    rowCount=0;
    m=18;
    _subpageIdArr=[[NSMutableArray alloc] initWithCapacity:0];
    _userNameArr=[[NSMutableArray alloc] initWithCapacity:0];
    _dateArr=[[NSMutableArray alloc] initWithCapacity:0];
    _evaluateContentArr=[[NSMutableArray alloc] initWithCapacity:0];
    _picUrlStrArr=[[NSMutableArray alloc] initWithCapacity:0];
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
-(void)readyUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden=YES;
    //自定义导航条
    
    UIView * navLab=[[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    navLab.userInteractionEnabled=YES;
    navLab.backgroundColor=NAV_COLOR;
    [self.view addSubview:navLab];
    
    UILabel * navTitailLab=[[UILabel alloc] initWithFrame:CGRectMake(70, 0, self.view.bounds.size.width-130, 44)];
    navTitailLab.text=[NSString stringWithFormat:@"%@",self.sortmodel.title];
    navTitailLab.textAlignment=NSTextAlignmentCenter;
    navTitailLab.textColor=[UIColor whiteColor];
    navTitailLab.font=[UIFont systemFontOfSize:14];
    [navLab addSubview:navTitailLab];
    
    UIButton * leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 80, NAV_HEIGHT);
    [leftBtn addTarget:self action:@selector(leftBtnCilck) forControlEvents:UIControlEventTouchUpInside];
    [navLab addSubview:leftBtn];
    
    UIImageView * backImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回按钮.png"]];
    backImgView.frame=CGRectMake(20, (NAV_HEIGHT-15)/2, 10, 15);
    [leftBtn addSubview:backImgView];
    
        UIButton * rightBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn2.frame=CGRectMake(self.view.frame.size.width-50, 12, 20, 20);
        [rightBtn2 setBackgroundImage:[UIImage imageNamed:@"分享新.png"] forState:UIControlStateNormal];
        [rightBtn2 addTarget:self action:@selector(rightBtnClick2) forControlEvents:UIControlEventTouchUpInside];
        [navLab addSubview:rightBtn2];
    
    
    UILabel * deteLab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0-130, 64,140,20)];
    deteLab.tag=10000;
    deteLab.font=[UIFont systemFontOfSize:12];
    deteLab.textColor=[UIColor grayColor];
    deteLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:deteLab];
    
    UILabel * viewsLab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0-130+140+10, 64,50,20)];
      viewsLab.tag=20000;
    viewsLab.font=[UIFont systemFontOfSize:12];
    viewsLab.textColor=[UIColor grayColor];
    viewsLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:viewsLab];
    
    UILabel * commentLab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0-130+140+10+50+10, 64,50,20)];
    commentLab.tag=30000;
    commentLab.font=[UIFont systemFontOfSize:12];
    commentLab.textColor=[UIColor grayColor];
    commentLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:commentLab];
    
    _bigScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 84,self.view.frame.size.width, self.view.frame.size.height-84-49)];
    _bigScrollView.userInteractionEnabled=YES;
    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, _bigScrollView.frame.size.height);
    _bigScrollView.userInteractionEnabled=YES;
    [self.view addSubview:_bigScrollView];
    
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 30)];
    _webView.tag=1111;
    [_webView setScalesPageToFit:NO];
    _webView.scrollView.scrollEnabled=NO;
    _webView.backgroundColor=[UIColor whiteColor];
    //[_webView loadHTMLString:_htmlStr baseURL:nil];
    _webView.delegate=self;
    [_bigScrollView addSubview:_webView];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, _webView.frame.size.height, self.view.frame.size.width,self.view.frame.size.height-84-_webView.frame.size.height-49) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [_tableView addHeaderWithTarget:self action:@selector(CompanyListHeaderRefreshing)];
    [_tableView addFooterWithTarget:self  action:@selector(footerRefresh)];
    _tableView.headerRefreshingText =@HeaderRefreshingText;
    _tableView.footerRefreshingText=@FooterRefreshingText;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.userInteractionEnabled=YES;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.tag=60;
    [_bigScrollView addSubview:_tableView];
    
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
-(void)rightBtnClick2
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"iTunesArtwork@2x" ofType:@"jpg"];
    
    NSString * shareUrlStr=self.model.style;
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"清一丽儿童网 立志打造南京最全面的儿童门户网站找辅导、买东西。惊喜连连，和你身边朋友一起分享%@",shareUrlStr] defaultContent:@"默认分享内容，没内容时显示" image:[ShareSDK imageWithPath:imagePath] title:@"#清一丽#门户网站特约分享" url:shareUrlStr description:[NSString stringWithFormat:@"我在#清一丽#发现了N条信息：清一丽儿童网 立志打造南京最全面的儿童门户网站找辅导、买东西。惊喜连连，和你身边朋友一起分享，很不错哦！%@",shareUrlStr] mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil shareList:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
     {
         if (state == SSResponseStateSuccess)
         {
             NSString * str=@"分享成功！";
             // [JTAlertViewAnimation startAnimation:str view:self.view];
             UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK，我知道了。。", nil];
             [alertView show];
             JTAppDelegate * appDelegate= [UIApplication sharedApplication].delegate;
             NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appDelegate.appUser.userID],@"userId",nil];
             [SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Share_UserShareAfter] jsonDic:jsondic];
         }
         else if (state == SSResponseStateFail)
         {
             
             NSString * str=[NSString stringWithFormat:@"分享失败！原因为：%@",[error errorDescription]];
             //[JTAlertViewAnimation startAnimation:str view:self.view];
             UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK，我知道了。。", nil];
             [alertView show];
         }
         
     }];

}
-(void)readyUIAgain
{
    UILabel * deteLab=(UILabel *)[self.view viewWithTag:10000];
    deteLab.text=self.model.openTime;
    
    UILabel * viewsLab=(UILabel *)[self.view viewWithTag:20000];
    if ([[NSString stringWithFormat:@"%@",self.model.clickTime] isEqualToString:@""]||self.model.clickTime==nil)
    {
        viewsLab.text=[NSString stringWithFormat:@"浏览:%@",@"0"];
    }
    else
    {
       viewsLab.text=[NSString stringWithFormat:@"浏览:%@",self.model.clickTime];
    }
   
    
    UILabel * commentLab=(UILabel *)[self.view viewWithTag:30000];
    if ([[NSString stringWithFormat:@"%@",self.model.commentCount] isEqualToString:@""]||self.model.commentCount==nil)
    {
        commentLab.text=[NSString stringWithFormat:@"评论:%@",@"0"];
    }
    else
    {
        commentLab.text=[NSString stringWithFormat:@"评论:%@",self.model.commentCount];
    }
    
    [_webView loadHTMLString:_htmlStr baseURL:nil];
    while (_webView.tag!=9999)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    _webView.tag=1111;
   
    //NSLog(@"^^^^^^^^^^^^^^^^^%f",_webView.bounds.size.height);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"网页加载完毕");
    //拦截网页图片  并修改图片大小
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth=310;" //缩放系数
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "myimg.height = myimg.height * (maxwidth/oldwidth)*1.5;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    int height = [height_str intValue];
    
    CGRect frame = webView.frame;
    frame.size.height= height+5;
    webView.frame = frame;
    webView.tag=9999;
    
    _tableView.frame=CGRectMake(0, height+5, self.view.frame.size.width,tableViewTotalHeight);
    _tableView.contentSize=CGSizeMake(self.view.frame.size.width, tableViewTotalHeight);
    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, height+5+tableViewTotalHeight);
}
-(void)refreshSubpageUI
{
    _tableView.frame=CGRectMake(0, _webView.frame.size.height, self.view.frame.size.width,tableViewTotalHeight);
    _tableView.contentSize=CGSizeMake(self.view.frame.size.width, tableViewTotalHeight);
    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, _webView.frame.size.height+tableViewTotalHeight);
}
#pragma mark-表代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_evaluateContentArr count];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel * lab=[[UILabel alloc] init];
    lab.text=@"";
    lab.numberOfLines=0;
    lab.text=[_evaluateContentArr objectAtIndex:indexPath.row];
    if (![lab.text isEqualToString:@""])
    {
        NSDictionary * eDic1=[[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil];
        CGSize labelSize1 = [lab.text boundingRectWithSize:CGSizeMake(self.view.bounds.size.width-80-10-10,MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin attributes:eDic1 context:nil].size;
        if (labelSize1.height<20)
        {
            labelSize1.height=20;
        }
        
        if(rowCount<[_evaluateContentArr count])
        {
            tableViewTotalHeight+=40+labelSize1.height;
            rowCount++;
        }
        return 40+labelSize1.height;
        
    }
    else
    {
        if(rowCount<[_evaluateContentArr count])
        {
            tableViewTotalHeight+=60;
            rowCount++;
        }
        return 60;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTKnowledgeEvaluateTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell=[[JTKnowledgeEvaluateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    [cell.imgView setImageWithURL:[NSURL URLWithString:[_picUrlStrArr objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
    cell.titleDateLab.text=[NSString stringWithFormat:@"%@(%@)",[_userNameArr objectAtIndex:indexPath.row],[_dateArr objectAtIndex:indexPath.row]];
    cell.countentLab.text=[_evaluateContentArr objectAtIndex:indexPath.row];
    
    CGSize labelSize1 = [[_evaluateContentArr objectAtIndex:indexPath.row] boundingRectWithSize:CGSizeMake(self.view.bounds.size.width-80-10-10,MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.countentLab.font} context:nil].size;
    if (labelSize1.height<20)
    {
        labelSize1.height=20;
    }
    cell.countentLab.frame=CGRectMake(80, 30, self.view.frame.size.width-80-10, labelSize1.height);
    cell.lineLab.frame=CGRectMake(10, 39+labelSize1.height, self.view.frame.size.width-20, 0.5);

    
    return cell;
    
    
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
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:userID,@"billerId",textFiled.text,@"content",[NSString stringWithFormat:@"%@",self.model.idStr],@"pid",nil];
        NSDictionary * evsluateDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_KnowLedge_subSave] jsonDic:jsondic]];
        if ([[NSString stringWithFormat:@"%@",[evsluateDic objectForKey:@"resultCode"]] intValue]==1000)
        {
            NSString * str=@"评论成功!";
            [JTAlertViewAnimation startAnimation:str view:self.view];
            [self sendPost2];
            [self refreshSubpageUI];
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

-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sendPost
{
    if ([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.sortmodel.idStr,@"id",nil];
        NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_KnowLedge_knowledgeInfo] jsonDic:jsondic]];
        if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            NSDictionary * resultDic=[[NSDictionary alloc] initWithDictionary:[zaojiaoDic objectForKey:@"kDTO"] ];
            _model=[[JTSortModel alloc] init];
            _model=self.sortmodel;
            _model.idStr=[resultDic objectForKey:@"id"];
            _model.openTime=[resultDic objectForKey:@"crDate"];
            _model.commentCount=[resultDic objectForKey:@"subNum"];
            _model.clickTime=[resultDic objectForKey:@"views"];
            
            _model.style=[resultDic objectForKey:@"detailAdd"];
            
            _htmlStr=[resultDic objectForKey:@"content"];
              m=9;
        }
        else
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }

    }
    
}
-(void)sendPost2
{
    pageNum=1;
    tableViewTotalHeight=0;
    rowCount=0;
    [_subpageIdArr removeAllObjects];
    [_userNameArr removeAllObjects];
    [_evaluateContentArr removeAllObjects];
    [_dateArr removeAllObjects];
    [_picUrlStrArr removeAllObjects];
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
        _tableView.frame=CGRectMake(0, _webView.frame.size.height+5, self.view.frame.size.width,tableViewTotalHeight);
        _tableView.contentSize=CGSizeMake(self.view.frame.size.width, tableViewTotalHeight);
        _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, _webView.frame.size.height+5+tableViewTotalHeight);
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
        _tableView.frame=CGRectMake(0, _webView.frame.size.height+5, self.view.frame.size.width,tableViewTotalHeight);
        _tableView.contentSize=CGSizeMake(self.view.frame.size.width, tableViewTotalHeight);
        _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, _webView.frame.size.height+5+tableViewTotalHeight);
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView footerEndRefreshing];
    });
}
-(void)GetCompanyListData
{
    if ([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.sortmodel.idStr,@"pid",@"1",@"pageSize",nil];
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_KnowLedge_knowledgeSubPage] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            if (q==3)
            {
                if ([[[zaojiaoListDic objectForKey:@"knowledgeSubPage"] objectForKey:@"totalCount"] intValue]==0)
                {
                    NSString * str=@"还没有人评论哦！快来抢沙发吧！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                    return;
                }
                NSArray * subListArr=[[NSArray alloc] initWithArray:[[zaojiaoListDic objectForKey:@"knowledgeSubPage"] objectForKey:@"list"]];
                
                for (int i=0; i<subListArr.count; i++)
                {
                    if ([[subListArr objectAtIndex:i] objectForKey:@"id"]==nil)
                    {
                        [_subpageIdArr addObject:@""];
                    }
                    else
                    {
                        [_subpageIdArr addObject:[[subListArr objectAtIndex:i] objectForKey:@"id"]];
                    }
                    
                    if([[subListArr objectAtIndex:i] objectForKey:@"billerName"]==nil)
                    {
                        
                        [_userNameArr addObject:@""];
                    }
                    else
                    {
                        [_userNameArr addObject:[[subListArr objectAtIndex:i] objectForKey:@"billerName"]];
                    }
                    
                    if([[subListArr objectAtIndex:i] objectForKey:@"subDate"]==nil)
                    {
                        [_dateArr addObject:@""];
                    }
                    else
                    {
                        [_dateArr addObject:[[subListArr objectAtIndex:i] objectForKey:@"subDate"]];
                    }
                    
                    
                    if ([[subListArr objectAtIndex:i] objectForKey:@"billerPic"]==nil)
                    {
                        [_picUrlStrArr addObject:@""];
                    }
                    else
                    {
                        [_picUrlStrArr addObject:[[subListArr objectAtIndex:i] objectForKey:@"billerPic"]];
                    }
                    
                    if ([[subListArr objectAtIndex:i] objectForKey:@"content"]==nil)
                    {
                        [_evaluateContentArr addObject:@""];
                    }
                    else
                    {
                        [_evaluateContentArr addObject:[[subListArr objectAtIndex:i] objectForKey:@"content"]];
                    }
                    
                }
    
                q=6;
            }
            else
            {
                NSArray * subListArr=[[NSArray alloc] initWithArray:[[zaojiaoListDic objectForKey:@"knowledgeSubPage"] objectForKey:@"list"]];
                for (int i=0; i<subListArr.count; i++)
                {
                    NSString * idStr=[NSString stringWithFormat:@"%@",[[subListArr objectAtIndex:i] objectForKey:@"id"]];
                    BOOL isExist=0;
                    for (int j=0; j<[_subpageIdArr count]; j++)
                    {
                        NSString * oldIdStr=[_subpageIdArr objectAtIndex:j];
                        if ([[NSString stringWithFormat:@"%@",oldIdStr] isEqualToString:idStr])
                        {
                            isExist=1;
                            break;
                        }
                    }
                    if (isExist==0)
                    {
                        for (int i=0; i<subListArr.count; i++)
                        {
                            if ([[subListArr objectAtIndex:i] objectForKey:@"id"]==nil)
                            {
                                [_subpageIdArr insertObject:@"" atIndex:0];
                            }
                            else
                            {
                                [_subpageIdArr insertObject:[[subListArr objectAtIndex:i] objectForKey:@"id"] atIndex:0];
                            }
                            
                            if([[subListArr objectAtIndex:i] objectForKey:@"billerName"]==nil)
                            {
                                
                                [_userNameArr insertObject:@"" atIndex:0];
                            }
                            else
                            {
                                [_userNameArr insertObject:[[subListArr objectAtIndex:i] objectForKey:@"billerName"] atIndex:0];
                            }
                            
                            if([[subListArr objectAtIndex:i] objectForKey:@"subDate"]==nil)
                            {
                                [_dateArr insertObject:@"" atIndex:0];
                            }
                            else
                            {
                                [_dateArr insertObject:[[subListArr objectAtIndex:i] objectForKey:@"subDate"] atIndex:0];
                            }
                            
                            
                            if ([[subListArr objectAtIndex:i] objectForKey:@"billerPic"]==nil)
                            {
                                [_picUrlStrArr insertObject:@"" atIndex:0];
                            }
                            else
                            {
                                [_picUrlStrArr insertObject:[[subListArr objectAtIndex:i] objectForKey:@"billerPic"] atIndex:0];
                            }
                            
                            if ([[subListArr objectAtIndex:i] objectForKey:@"content"]==nil)
                            {
                                [_evaluateContentArr insertObject:@"" atIndex:0];
                            }
                            else
                            {
                                [_evaluateContentArr insertObject:[[subListArr objectAtIndex:i] objectForKey:@"content"] atIndex:0];
                            }
                        }
                        
                        
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
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.sortmodel.idStr,@"pid",[NSString stringWithFormat:@"%d",pageNum],@"pageSize",nil];
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_KnowLedge_knowledgeSubPage] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            if ([[[zaojiaoListDic objectForKey:@"knowledgeSubPage"] objectForKey:@"list"]count]==0)
            {
                NSString * str=@"已全部加载完毕！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                pageNum--;
                return;
            }
            NSArray * subListArr=[[zaojiaoListDic objectForKey:@"knowledgeSubPage"] objectForKey:@"list"];
            for (int i=0; i<subListArr.count; i++)
            {
                if ([[subListArr objectAtIndex:i] objectForKey:@"id"]==nil)
                {
                    [_subpageIdArr addObject:@""];
                }
                else
                {
                    [_subpageIdArr addObject:[[subListArr objectAtIndex:i] objectForKey:@"id"]];
                }
                
                if([[subListArr objectAtIndex:i] objectForKey:@"billerName"]==nil)
                {
                    
                    [_userNameArr addObject:@""];
                }
                else
                {
                    [_userNameArr addObject:[[subListArr objectAtIndex:i] objectForKey:@"billerName"]];
                }
                
                if([[subListArr objectAtIndex:i] objectForKey:@"subDate"]==nil)
                {
                    [_dateArr addObject:@""];
                }
                else
                {
                    [_dateArr addObject:[[subListArr objectAtIndex:i] objectForKey:@"subDate"]];
                }
                
                
                if ([[subListArr objectAtIndex:i] objectForKey:@"billerPic"]==nil)
                {
                    [_picUrlStrArr addObject:@""];
                }
                else
                {
                    [_picUrlStrArr addObject:[[subListArr objectAtIndex:i] objectForKey:@"billerPic"]];
                }
                
                if ([[subListArr objectAtIndex:i] objectForKey:@"content"]==nil)
                {
                    [_evaluateContentArr addObject:@""];
                }
                else
                {
                    [_evaluateContentArr addObject:[[subListArr objectAtIndex:i] objectForKey:@"content"]];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
