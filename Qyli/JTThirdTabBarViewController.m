//
//  JTThirdTabBarViewController.m
//  Qyli
//
//  Created by 小七 on 14-11-21.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTThirdTabBarViewController.h"
#import "JTDianpuListViewController.h"
#import "JTShangpinListViewController.h"
#import "JTDianpuHuodongListViewController.h"

@interface JTThirdTabBarViewController()
{
    UIView * _contentView;
    NSArray * _normalBtnImgArr;
    NSArray * _selectedBtnImgArr;
    UIButton * _selectedBtn;
    int p;

}
@property (nonatomic,strong)NSMutableArray * viewControllers;
@end
@implementation JTThirdTabBarViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    p=3;
    
    _normalBtnImgArr=[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"店铺1.png"],[UIImage imageNamed:@"商品1.png"],[UIImage imageNamed:@"活动1.png"], nil];
    _selectedBtnImgArr=[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"店铺2.png"],[UIImage imageNamed:@"商品2.png"],[UIImage imageNamed:@"活动2.png"], nil];


    
    [self readyUI];
}


-(void)readyUI
{
    _contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _contentView.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:_contentView];
    
    JTAppDelegate * appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 49);
    appDelegate.tabBarView3=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-49, self.view.bounds.size.width, 49)];
    appDelegate.tabBarView3.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:appDelegate.tabBarView3];
    
    UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.3)];
    lineLab.backgroundColor=[UIColor lightGrayColor];
    [appDelegate.tabBarView3 addSubview:lineLab];
    
    _viewControllers=[[NSMutableArray alloc] initWithCapacity:4];
    [self putViewController:[JTDianpuListViewController class] inArray:_viewControllers];
    [self putViewController:[JTShangpinListViewController class] inArray:_viewControllers];
    [self putViewController:[JTDianpuHuodongListViewController class] inArray:_viewControllers];
    
    UIButton * defaultSelectedBtn=nil;
    NSInteger count=[_viewControllers count];
    NSInteger width=self.view.frame.size.width/3.0;
    for (int i=0; i<count; i++)
    {
        UIButton * barBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        barBtn.backgroundColor=[UIColor whiteColor];
        barBtn.tag=i+10;
        barBtn.frame=CGRectMake(width*i,0.3, width, 49);
        [barBtn setImage:[_normalBtnImgArr objectAtIndex:i] forState:UIControlStateNormal];
        [barBtn setImage:[_selectedBtnImgArr objectAtIndex:i] forState:UIControlStateSelected];
        [barBtn addTarget:self action:@selector(barBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [appDelegate.tabBarView3 addSubview:barBtn];
        if (i==self.SJLMBigState-1)
        {
            defaultSelectedBtn=barBtn;
        }
    }
    [self barBtnClick:defaultSelectedBtn];
}
-(void)barBtnClick:(UIButton *)sender
{
    if (_selectedBtn==sender)
    {
        
    }else
    {
        
        if (p==6)
        {
            UIViewController * lastContentViewController=[_viewControllers objectAtIndex:_selectedBtn.tag-10];
            [lastContentViewController.view removeFromSuperview];
        }
        if (p==3)
        {
            p=6;
            
        }
        _selectedBtn.selected=NO;
        _selectedBtn=sender;
        _selectedBtn.selected=YES;
        
        UIViewController * contentViewController=[_viewControllers objectAtIndex:sender.tag-10];
        [_contentView addSubview:contentViewController.view];
        
    }
}
- (void)putViewController:(Class)class inArray:(NSMutableArray* )array {
    
    if ([[NSString stringWithFormat:@"%@",class] isEqualToString:@"JTDianpuListViewController"])
    {
        JTDianpuListViewController * viewController=[[JTDianpuListViewController alloc] init];
        switch (self.SJLMState)
        {
            case 0:
            {
                viewController.typeIDStr=@"0";
            }
                break;
            case 1:
            {
                viewController.typeIDStr=@"9";
            }
                break;
            case 2:
            {
                viewController.typeIDStr=@"10";
            }
                break;
            case 3:
            {
                viewController.typeIDStr=@"14";
            }
                break;
            case 4:
            {
                viewController.typeIDStr=@"15";
            }
                break;
            default:
                break;
        }
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        [array addObject:nav];
        
    }
    else
    {
        UIViewController* viewController = [[class alloc] init];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        [array addObject:nav];
    }

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
