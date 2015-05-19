//
//  JTSecondTabBarViewController.m
//  Qyli
//
//  Created by 小七 on 14-11-3.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTSecondTabBarViewController.h"
#import "JTKeChengListViewController.h"
#import "JTJiGouListViewController.h"
#import "JTHuoDongListViewController.h"

@interface JTSecondTabBarViewController(){
    UIView * _contentView;
    NSArray * _normalBtnImgArr;
    NSArray * _selectedBtnImgArr;
    UIButton * _selectedBtn;
    int p;
    
}
@property (nonatomic,strong)NSMutableArray * viewControllers;

@end

@implementation JTSecondTabBarViewController

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
    
    _normalBtnImgArr=[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"培训1.png"],[UIImage imageNamed:@"课程1.png"],[UIImage imageNamed:@"活动1.png"], nil];
    _selectedBtnImgArr=[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"培训2.png"],[UIImage imageNamed:@"课程2.png"],[UIImage imageNamed:@"活动2.png"],nil];
    
        [self readyUI];
}

-(void)readyUI
{
    _contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _contentView.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:_contentView];
    
    JTAppDelegate * appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 49);
    appDelegate.tabBarView2=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-49, self.view.bounds.size.width, 49)];
    appDelegate.tabBarView2.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:appDelegate.tabBarView2];
    
    UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.3)];
    lineLab.backgroundColor=[UIColor lightGrayColor];
    [appDelegate.tabBarView2 addSubview:lineLab];
 
    
    _viewControllers=[[NSMutableArray alloc] initWithCapacity:3];
    [self putViewController:[JTJiGouListViewController class] inArray:_viewControllers];
    [self putViewController:[JTKeChengListViewController class] inArray:_viewControllers];
    [self putViewController:[JTHuoDongListViewController class] inArray:_viewControllers];
    
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
        [appDelegate.tabBarView2 addSubview:barBtn];
        if (i==self.KCJGBigState-1)
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
    
    if ([[NSString stringWithFormat:@"%@",class] isEqualToString:@"JTJiGouListViewController"])
    {
       JTJiGouListViewController * viewController=[[JTJiGouListViewController alloc] init];
        switch (self.KCJGState)
        {
            case 0:
            {
              viewController.typeIDStr=@"";
            }
                break;
            case 1:
            {
                viewController.typeIDStr=@"早教";
            }
                break;
            case 2:
            {
                viewController.typeIDStr=@"课外辅导";
            }
                break;
            case 3:
            {
                viewController.typeIDStr=@"运动";
            }
                break;
            case 4:
            {
                viewController.typeIDStr=@"才艺";
            }
                break;
            case 5:
            {
                viewController.typeIDStr=@"音乐";
            }
                break;
            case 6:
            {
                viewController.typeIDStr=@"舞蹈";
            }
                break;
                
            default:
                break;
        }
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        [array addObject:nav];

    }
    else if([[NSString stringWithFormat:@"%@",class] isEqualToString:@"JTKeChengListViewController"])
    {
        JTKeChengListViewController * viewController=[[JTKeChengListViewController alloc] init];
        switch (self.KCJGState)
        {
            case 1:
            {
                viewController.typeIDStr=@"8,9,10,11,12,13";
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
