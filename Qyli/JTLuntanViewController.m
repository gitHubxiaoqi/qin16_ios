//
//  JTLuntanViewController.m
//  清一丽
//
//  Created by 小七 on 15-4-10.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTLuntanViewController.h"
#import "JTLuntanListViewController.h"
#import "JTFatieViewController.h"

@interface JTLuntanViewController ()
{
    int p;
    NSMutableArray * _titleArr;
    NSMutableArray * _typeIdArr;
    NSArray * _colorArr;
}

@end

@implementation JTLuntanViewController

-(void)viewWillAppear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=NO;
    appDelegate.tabBarView2.hidden=NO;
    appDelegate.tabBarView3.hidden=NO;
    
    if (p==1)
    {
        [self sendPost];
    }
    p=2;
    [self readyUI];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    p=1;
    _titleArr=[[NSMutableArray alloc] initWithCapacity:0];
    _typeIdArr=[[NSMutableArray alloc] initWithCapacity:0];

    UIColor * color1=[UIColor colorWithRed:217.0/255.0 green:199.0/255.0 blue:222.0/255.0 alpha:1.0];
    UIColor * color2=[UIColor colorWithRed:187.0/255.0 green:212.0/255.0 blue:198.0/255.0 alpha:1.0];
    UIColor * color3=[UIColor colorWithRed:218.0/255.0 green:222.0/255.0 blue:159.0/255.0 alpha:1.0];
    UIColor * color4=[UIColor colorWithRed:199.0/255.0 green:212.0/255.0 blue:230.0/255.0 alpha:1.0];
    _colorArr=[[NSArray alloc] initWithObjects:color1,color2,color3,color4, nil];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden=YES;
    //自定义导航条
    UIView * navBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    navBarView.backgroundColor=NAV_COLOR;
    [self.view addSubview:navBarView];
    
    UILabel * navTitailLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navTitailLab.text=@"论坛";
    navTitailLab.textAlignment=NSTextAlignmentCenter;
    navTitailLab.textColor=[UIColor whiteColor];
    navTitailLab.font=[UIFont systemFontOfSize:22];
    [navBarView addSubview:navTitailLab];
    

    UIButton * rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(SCREEN_WIDTH-40, (NAV_HEIGHT-20)/2, 20, 20);
    rightBtn.tag=200;
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"加号2.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:rightBtn];
}
-(void)readyUI
{

    for (int i=0; i<_titleArr.count; i++)
    {
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(10+i%2*((SCREEN_WIDTH-30)/2.0+10), 74+i/2*((SCREEN_WIDTH-30)/3.0+10), (SCREEN_WIDTH-30)/2.0, (SCREEN_WIDTH-30)/3.0);
        btn.backgroundColor=[_colorArr objectAtIndex:i%4];
        [btn setTitle:[_titleArr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTintColor:[UIColor whiteColor]];
        btn.titleLabel.font=[UIFont systemFontOfSize:24];
        btn.tag=100+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }

}
-(void)btnClick:(UIButton *)sender
{
    JTLuntanListViewController * listVC=[[JTLuntanListViewController alloc] init];
    listVC.typeId=[_typeIdArr objectAtIndex:sender.tag-100];
    listVC.title=[_titleArr objectAtIndex:sender.tag-100];
    [self.navigationController pushViewController:listVC animated:YES];
}
-(void)rightBtnClick
{
    JTFatieViewController * fatieVC=[[JTFatieViewController alloc] init];
    fatieVC.typeArr=[[NSArray alloc] initWithArray:_titleArr];
    fatieVC.typeIdArr=[[NSArray alloc] initWithArray:_typeIdArr];
    [self.navigationController pushViewController:fatieVC animated:YES];
}
#pragma mark- 发请求
-(void)sendPost
{
    if ([SOAPRequest checkNet])
    {
        
        NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Luntan_GetTopicTypeList] jsonDic:@{}]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            NSArray * modelArr=[[NSArray alloc] initWithArray:[zaojiaoDic objectForKey:@"topicTypeList"]];
            for (int i=0; i<modelArr.count; i++)
            {
                NSString * idstr=[[modelArr objectAtIndex:i] objectForKey:@"id"];
                NSString * titlestr=[[modelArr objectAtIndex:i] objectForKey:@"typeName"];
                [_titleArr addObject:titlestr];
                [_typeIdArr addObject:idstr];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
