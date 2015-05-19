//
//  JTSettingViewController.m
//  Qyli
//
//  Created by 小七 on 14-8-5.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTSettingViewController.h"
#import "JTSettingAboutViewController.h"
#import "JTPushSettingViewController.h"
#import "JTFankuiViewController.h"

@interface JTSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    UITableView * _tabView;
    NSArray * _titleArr;
    int fileCount;
}

@end

@implementation JTSettingViewController

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
    fileCount=0;
    [self readyUI];
}

-(void)readyUI
{
    self.view.backgroundColor=[UIColor colorWithRed:221.0/255.0 green:221.0/255.0  blue:221.0/255.0  alpha:1];
    self.navigationController.navigationBar.hidden=YES;
    //自定义导航条
    
    UIView * navLab=[[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    navLab.userInteractionEnabled=YES;
    navLab.backgroundColor=NAV_COLOR;
    [self.view addSubview:navLab];
    
    UILabel * navTitailLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navTitailLab.text=@"设置";
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
    
    //表
    _tabView=[[UITableView alloc] initWithFrame:CGRectMake(10, 74, self.view.frame.size.width-20, 176) style:UITableViewStylePlain];
    _tabView.dataSource=self;
    _tabView.delegate=self;
    [self.view addSubview:_tabView];
    _titleArr=@[@"推送设置",@"清理缓存",@"用户反馈",@"关于"];
    
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
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.textLabel.text=[_titleArr objectAtIndex:indexPath.row];
        UIImageView *imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头.png"]];
        imgView.frame=CGRectMake(self.view.frame.size.width-20-20, 17, 8, 10);
        [cell addSubview:imgView];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            JTPushSettingViewController * pushVc=[[JTPushSettingViewController alloc] init];
            [self.navigationController pushViewController:pushVc animated:YES];
        }
            break;
        case 1:
        {
            [self clearCache];
        }
            break;
        case 2:
        {
            JTFankuiViewController * fVC=[[JTFankuiViewController alloc] init];
            [self.navigationController pushViewController:fVC animated:YES];
        }
            break;
        case 3:
        {
            JTSettingAboutViewController * pVC=[[JTSettingAboutViewController alloc] init];
            [self presentViewController:pVC  animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }

}
-(void)clearCache
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       fileCount=[files count];
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
}
-(void)clearCacheSuccess
{
    NSString * str=@"";
    if (fileCount!=0)
    {
      str=[NSString stringWithFormat:@"清一丽为您成功清理掉%d个缓存文件",fileCount];
    }
    else
    {
      str=@"没有要清理的文件";
    }
    [JTAlertViewAnimation startAnimation:str view:self.view];
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
