//
//  JTPersonalMegViewController.m
//  Qyli
//
//  Created by 小七 on 14-8-4.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTPersonalMegViewController.h"
#import "JTSetNameViewController.h"
#import "JTSetSexViewController.h"
#import "JTGOChangePswViewController.h"
#import "JTGOChangePhoneViewController.h"

@interface JTPersonalMegViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    UITableView * _tabView;
    NSArray * _titleArr;

    UITableView * _provinceTabView;
    UITableView * _cityTableView;
    NSMutableArray * _provinceTitleArr;
    NSMutableArray * _cityTitleArr;
    NSMutableArray * _provinceIDArr;
    NSMutableArray * _cityIDArr;

    int pcount;
    int ccount;
    
    UIImagePickerController * imagePicker;
    UIImageView * photo;
    
    UIScrollView * _bigScrollView;
  
}
@property(nonatomic,strong)NSString * provinceValue;
@property(nonatomic,strong)NSString * cityValue;
@property(nonatomic,strong)NSString * headImgData;
@property(nonatomic,strong)NSString * provinceValue0;
@property(nonatomic,strong)NSString * cityValue0;



@end

@implementation JTPersonalMegViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=YES;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView3.hidden=YES;

    self.myUser=appDelegate.appUser;
    UITableViewCell * cell1=[_tabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell1.detailTextLabel.text=appDelegate.appUser.userName;
    
    UITableViewCell * cell2=[_tabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell2.detailTextLabel.text=(appDelegate.appUser.sex)?@"女":@"男";
    
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

    
     _titleArr=@[@"头像",@"用户名",@"性别",@"手机号码",@"邮箱",@"所在地",@"修改密码",@"手机号码认证"];
    self.headImgData=@"";
    
    
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    self.myUser=[[JTUser alloc] init];
    self.myUser=appDelegate.appUser;
    
    _provinceValue=[NSString stringWithFormat:@"%d",self.myUser.provinceID];
    _cityValue=[NSString stringWithFormat:@"%d",self.myUser.cityID];
    _provinceValue0=self.myUser.provinceValue;
    _cityValue0=self.myUser.cityValue;
    
    _provinceTitleArr=[[NSMutableArray alloc] initWithArray:appDelegate.provinceTitleArr];
    _cityTitleArr=[[NSMutableArray alloc] initWithArray:appDelegate.cityTitleArr];
    _provinceIDArr=[[NSMutableArray alloc] initWithArray:appDelegate.provinceIDArr];
    _cityIDArr=[[NSMutableArray alloc] initWithArray:appDelegate.cityIDArr];
    
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
    navTitailLab.text=@"个人信息";
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
    
    
    _bigScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64+15+35)];
    _bigScrollView.backgroundColor=BG_COLOR;
    _bigScrollView.contentSize=CGSizeMake(SCREEN_WIDTH,500);
    _bigScrollView.scrollEnabled=YES;
    [self.view addSubview:_bigScrollView];
    
    _tabView=[[UITableView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 360) style:UITableViewStylePlain];
    _tabView.tag=60;
    _tabView.dataSource=self;
    _tabView.delegate=self;
    _tabView.sectionHeaderHeight=0;
    _tabView.scrollEnabled=NO;
    [_bigScrollView addSubview:_tabView];
   
    UIButton * exitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame=CGRectMake(10 ,10+360+15, self.view.frame.size.width-20, 35);
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bigScrollView addSubview:exitBtn];
    
}

-(void)exit
{
    UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定注销当前用户吗？" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确定", nil];
    [alertView show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        
    }
    else
    {
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            if (error && error.errorCode != EMErrorServerNotLogin) {
                [self showHint:error.description];
            }
            else{
                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            }
        } onQueue:nil];


        [self.navigationController popViewControllerAnimated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginName"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
        [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
        [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
        [APService setAlias:nil callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
    
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        JTAppDelegate * appdelegate= [UIApplication sharedApplication].delegate;
        appdelegate.tabBarView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.frame.size.width, 49);
        [self presentViewController:imagePickerController animated:YES completion:^{}];

    }
    
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    appdelegate.tabBarView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-49, self.view.frame.size.width, 49);
	[picker dismissViewControllerAnimated:YES completion:^{}];

    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
   // UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    UIImage * savedImage=[NSString  fixOrientation:[[UIImage alloc] initWithContentsOfFile:fullPath]];
    //NSLog(@"^^^^^^^^^^^^^^^^^^^^^^^^^^^^%d",savedImage.imageOrientation);
    [photo setImage:savedImage];
    
   // NSData * data=UIImagePNGRepresentation(savedImage);
    NSData *data=UIImageJPEGRepresentation(savedImage, 0.0001);
    self.headImgData=[data base64EncodedString];
    
    self.headImgData = [self.headImgData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    self.headImgData = [self.headImgData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    self.headImgData = [self.headImgData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    [self xiugai];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}
#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==60)
    {
        if (indexPath.row==0)
    
        {
        return 80;
        }
        else
        {
        return 40;
        }
    }
    else if(tableView.tag==80)
    {
        return 40;
    
    }
    else
    {
    return 40;
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==60)
    {
        return _titleArr.count;
    }
    else if(tableView.tag==80)
    {
        return [_provinceTitleArr count];
    
    }
    else
    {
        return [[_cityTitleArr objectAtIndex:pcount] count];
      
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
        if (tableView.tag==60)
        {
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            UIImageView *imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头.png"]];
            if (indexPath.row==0)
            {
                imgView.frame=CGRectMake(self.view.frame.size.width-20-5-5, 35, 5, 10);
            }
            else if(indexPath.row==3||indexPath.row==4)
            {
                imgView.frame=CGRectZero;
            }
            else
            {
                imgView.frame=CGRectMake(self.view.frame.size.width-20-5-5, 15, 5, 10);
            }
            [cell addSubview:imgView];

            cell.textLabel.text=[_titleArr objectAtIndex:indexPath.row];
            switch (indexPath.row)
            {
                case 0:
                {
                    photo=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-20-70-20, 10, 70, 60)];
                    [photo setImageWithURL:[NSURL URLWithString:self.myUser.headPortraitImgUrlStr] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
                    [cell addSubview:photo];
                }
                    break;
                case 1:
                {
                    cell.detailTextLabel.text=self.myUser.userName;
                }
                    break;
                case 2:
                {
                    if (self.myUser.sex)
                    {
                        cell.detailTextLabel.text=@"女";
                        
                    }
                    else
                    {
                        cell.detailTextLabel.text=@"男";
                    }
                }
                    break;
                case 3:
                {

                    if (self.myUser.phone)
                    {
                        cell.detailTextLabel.text=self.myUser.phone;
                        
                    }
                    else
                    {
                        cell.detailTextLabel.text=@"未认证";
                    }

                    
                }
                    break;
                case 4:
                {

                    if (self.myUser.email)
                    {
                        cell.detailTextLabel.text=self.myUser.email;
                        
                    }
                    else
                    {
                        cell.detailTextLabel.text=@"未认证";
                    }

                }
                    break;
                case 5:
                {

                    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@-%@",self.myUser.provinceValue,self.myUser.cityValue];
                }
                    break;
                    
                default:
                    break;
            }

        }

    }
    if(tableView.tag==80)
    {
        cell.textLabel.text=[_provinceTitleArr objectAtIndex:indexPath.row];
    }
    else if (tableView.tag==100)
    {
        cell.textLabel.text=[[_cityTitleArr objectAtIndex:pcount] objectAtIndex:indexPath.row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==60)
    {

            switch (indexPath.row)
            {
                case 0:
                {
                    UIActionSheet *sheet;
                    
                    // 判断是否支持相机
                    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                    {
                        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
                    }
                    else {
                        
                        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
                    }
                    
                    sheet.tag = 255;
                    
                    [sheet showInView:self.view];

                }
                    break;
                case 1:
                {
                    JTSetNameViewController * sVC=[[JTSetNameViewController alloc] init];
                    sVC.pVC=self;
                    [self.navigationController pushViewController:sVC animated:YES];
                }
                    break;
                case 2:
                {
                    JTSetSexViewController * sVC=[[JTSetSexViewController alloc] init];
                    sVC.pVC=self;
                    [self.navigationController pushViewController:sVC animated:YES];
                }
                     break;
                case 3:
                {
                }
                    break;
                case 4:
                {
                }
                    break;
                case 5:
                {
                    if ([_provinceTitleArr count]!=0)
                    {
                        if (!_provinceTabView)
                        {
                            _provinceTabView=[[UITableView alloc] initWithFrame:CGRectMake(self.view.center.x,self.view.center.y,0,0)];
                            _provinceTabView.tag=80;
                            _provinceTabView.dataSource=self;
                            _provinceTabView.delegate=self;
                            _provinceTabView.sectionHeaderHeight=40;
                            
                        }
                        else
                        {
                        }
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:0.5];
                        _provinceTabView.frame=CGRectMake(0, 40, self.view.frame.size.width, self.view.bounds.size.height-80);
                        [self.view addSubview:_provinceTabView];
                        [UIView commitAnimations];
                    }
                    
                }
                    break;
                case 6:
                {
                    JTGOChangePswViewController * cPsVC=[[JTGOChangePswViewController alloc] init];
                    cPsVC.lastVC=self;
                    [self.navigationController pushViewController:cPsVC animated:YES];
                }
                    break;
                case 7:
                {
                    JTGOChangePhoneViewController * cPhVC=[[JTGOChangePhoneViewController alloc] init];
                    cPhVC.lastVC=self;
                    [self.navigationController pushViewController:cPhVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }

    }
    else if(tableView.tag==80)
    {
        pcount=indexPath.row;
        if (!_cityTableView)
        {
            _cityTableView=[[UITableView alloc] initWithFrame:CGRectMake(self.view.center.x*3/2,self.view.center.y,0,0)];
            _cityTableView.tag=100;
            _cityTableView.dataSource=self;
            _cityTableView.delegate=self;
            _cityTableView.sectionHeaderHeight=40;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            _cityTableView.frame=CGRectMake(self.view.frame.size.width/2.0, 40, self.view.frame.size.width/2.0, self.view.bounds.size.height-80);
            [self.view addSubview:_cityTableView];
            [UIView commitAnimations];
        }
        else
        {
            [_cityTableView removeFromSuperview];
            _cityTableView=[[UITableView alloc] initWithFrame:CGRectMake(self.view.center.x*3/2,self.view.center.y,0,0)];
            _cityTableView.tag=100;
            _cityTableView.dataSource=self;
            _cityTableView.delegate=self;
            _cityTableView.sectionHeaderHeight=40;
            _cityTableView.frame=CGRectMake(self.view.frame.size.width/2.0, 40, self.view.frame.size.width/2.0, self.view.bounds.size.height-80);
            [self.view addSubview:_cityTableView];
        }
        for (int i=0; i<[[_cityTitleArr objectAtIndex:pcount] count]; i++)
        {
            UITableViewCell * cell=[_cityTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.textLabel.text=[[_cityTitleArr objectAtIndex:pcount] objectAtIndex:i];
        }
        
    
    }
    else
    {
        ccount=indexPath.row;
        _provinceTabView.frame=CGRectMake(self.view.center.x, self.view.center.y, 0, 0);
        [_cityTableView removeFromSuperview];
        [_provinceTabView removeFromSuperview];
        
        self.provinceValue0=[_provinceTitleArr objectAtIndex:pcount];
        self.provinceValue=[_provinceIDArr objectAtIndex:pcount];
        self.cityValue0=[[_cityTitleArr objectAtIndex:pcount] objectAtIndex:ccount];
        self.cityValue=[[_cityIDArr objectAtIndex:pcount] objectAtIndex:ccount];
        [_tabView reloadData];
        [self xiugai];
    
    }

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view=[[UIView alloc] init];
    

    
    
    if (tableView.tag==80)
    {
        UIButton * leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame=CGRectMake(0, 0, 80, 40);
        [leftBtn addTarget:self action:@selector(quxiao) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:leftBtn];
        
        UIImageView * backImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回按钮.png"]];
        backImgView.frame=CGRectMake(20, (40-15)/2, 10, 15);
        [leftBtn addSubview:backImgView];
        
        view.backgroundColor=[UIColor colorWithRed:216.0/255.0 green:99.0/255.0 blue:116.0/255.0 alpha:1];
        UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2.0, 40)];
        lab.text=@"请选择省份:";
        lab.textColor=[UIColor whiteColor];
        lab.font=[UIFont systemFontOfSize:18];
        lab.textAlignment=NSTextAlignmentCenter;
        [view addSubview:lab];
       
    }
    else if(tableView.tag==100)
    {
        view.backgroundColor=[UIColor colorWithRed:216.0/255.0 green:99.0/255.0 blue:116.0/255.0 alpha:1];
        UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2.0, 40)];
        lab.text=@"请选择城市:";
        lab.textColor=[UIColor whiteColor];
        lab.font=[UIFont systemFontOfSize:18];
        lab.textAlignment=NSTextAlignmentCenter;
        [view addSubview:lab];
    }
     return view;
}
-(void)quxiao
{
    _provinceTabView.hidden=YES;
    [_provinceTabView removeFromSuperview];
    _provinceTabView=nil;
    _cityTableView.hidden=YES;
    [_cityTableView removeFromSuperview];
    
}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)xiugai
{
    if ([SOAPRequest checkNet])
    {
        NSString * sexStr=@"";
        if (self.myUser.sex==0)
        {
            sexStr=@"MALE";
        }
        else
        {
            sexStr=@"FEMALE";
        }

        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.myUser.userID],@"userId",self.myUser.loginName,@"loginName",self.myUser.userName,@"userName",sexStr,@"sex",_provinceValue,@"province",_cityValue,@"city",@"",@"region",@"",@"street",@"",@"address",_headImgData,@"headPortrait", nil];
        
        NSDictionary * editUserDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_SaveEditUserURL] jsonDic:jsondic]];

        
        if ([[editUserDic objectForKey:@"resultCode"] intValue]!=1000)
        {
            if ([editUserDic objectForKey:@"errorMessage"]!=nil)
            {
                NSString * str=[editUserDic objectForKey:@"errorMessage"];
                [JTAlertViewAnimation startAnimation:str view:self.view];
                
            }
            else
            {
                NSString * str=@"服务器异常，请稍后重试...";
                [JTAlertViewAnimation startAnimation:str view:self.view];
            }
            
        }
        else if ([[editUserDic objectForKey:@"resultCode"] intValue]==1000)
        {
            
            UITableViewCell * cell5=[_tabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
            cell5.detailTextLabel.text=[NSString stringWithFormat:@"%@-%@",_provinceValue0,_cityValue0];
            [_tabView reloadData];
            
            NSDictionary * userDic=[editUserDic objectForKey:@"user"];
            _myUser.userID=[[userDic objectForKey:@"id"] intValue];
            _myUser.loginName=[userDic objectForKey:@"loginName"];
            _myUser.password=[userDic objectForKey:@"password"];
            _myUser.userName=[userDic objectForKey:@"userName"];
            NSString * sexStr=[userDic objectForKey:@"sex"];
            if ([sexStr isEqualToString:@"MALE"])
            {
                _myUser.sex=0;//男
            }
            else if ([sexStr isEqualToString:@"FEMALE"])
            {
                _myUser.sex=1;//女
            }
            _myUser.headPortraitImgUrlStr=[userDic objectForKey:@"imageValue"];
            _myUser.email=[userDic objectForKey:@"email"];
            _myUser.phone=[userDic objectForKey:@"tel"];
            _myUser.provinceID=[[userDic objectForKey:@"provinceId"] intValue];
            _myUser.cityID=[[userDic objectForKey:@"cityId"] intValue];
            _myUser.regionId=[[userDic objectForKey:@"regionId"] intValue];
            _myUser.streetId=[[userDic objectForKey:@"streetId"] intValue];
            _myUser.address=[userDic objectForKey:@"address"];
            _myUser.createTime=[userDic objectForKey:@"createTime"];
            _myUser.lastLoginTime=[userDic objectForKey:@"lastLoginTime"];
            _myUser.isContinuous=[userDic objectForKey:@"continuous"];
            _myUser.points=[userDic objectForKey:@"points"];
            _myUser.availablePoints=[userDic objectForKey:@"availablePoints"];
            _myUser.pointsTitle=[userDic objectForKey:@"pointsTitle"];
            
            _myUser.provinceValue=[userDic objectForKey:@"provinceName"];
            _myUser.cityValue=[userDic objectForKey:@"cityName"];
            _myUser.regionName=[userDic objectForKey:@"regionName"];
            _myUser.streetName=[userDic objectForKey:@"streetName"];
            _myUser.isSignin=[userDic objectForKey:@"signinFlag"];
            _myUser.EMuserLoginName=[userDic objectForKey:@"easemobUsername"];
            
            JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
            appdelegate.appUser=self.myUser;

        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
