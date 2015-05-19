//
//  JTDuihuanViewController.m
//  清一丽
//
//  Created by 小七 on 15-2-13.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTDuihuanViewController.h"

@interface JTDuihuanViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * _listModelArr;
    
    UIScrollView * _bigScrollView;
    UIView * _readyView;
    UIButton * _selectBtn;
    
    UITableView * _provinceTabView;
    UITableView * _cityTableView;
    UITableView * _quTabView;
    UITableView * _streetTableView;
    
    NSMutableArray * _provinceTitleArr;
    NSMutableArray * _cityTitleArr;
    NSMutableArray * _quTitleArr;
    NSMutableArray * _streetTitleArr;
    NSMutableArray * _provinceIDArr;
    NSMutableArray * _cityIDArr;
    NSMutableArray * _quIDArr;
    NSMutableArray * _streetIDArr;
    
    UIView * _bgView;
    UIScrollView * _bgScrollView;
    
    
    int pcount;
    int ccount;
    int qcount;
    int scount;
    
    NSString * _pIDStr;
     NSString * _cIDStr;
     NSString * _qIDStr;
    NSString * _sIDStr;
}

@end

@implementation JTDuihuanViewController
-(void)viewWillAppear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=YES;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView3.hidden=YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self sendPost];
    [self readyUIAgain];
}
-(void)viewWillDisappear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=NO;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView3.hidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    _provinceTitleArr=[[NSMutableArray alloc] initWithArray:appDelegate.provinceTitleArr];
    _cityTitleArr=[[NSMutableArray alloc] initWithArray:appDelegate.cityTitleArr];
    _provinceIDArr=[[NSMutableArray alloc] initWithArray:appDelegate.provinceIDArr];
    _cityIDArr=[[NSMutableArray alloc] initWithArray:appDelegate.cityIDArr];
    _quTitleArr=[[NSMutableArray alloc] initWithArray:appDelegate.quTitleArr];
    _streetTitleArr=[[NSMutableArray alloc] initWithArray:appDelegate.streetTitleArr];
    _quIDArr=[[NSMutableArray alloc] initWithArray:appDelegate.quIDArr];
    _streetIDArr=[[NSMutableArray alloc] initWithArray:appDelegate.streetIDArr];
    
    pcount=0;
    ccount=0;
    qcount=0;
    scount=0;
    
    _pIDStr=@"";
    _cIDStr=@"";
    _qIDStr=@"";
    _sIDStr=@"";
    
    _listModelArr=[[NSMutableArray alloc] initWithCapacity:0];
    _selectBtn=nil;
    [self readyUI];
}
-(void)readyUI
{
    self.view.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    self.navigationController.navigationBar.hidden=YES;
    //自定义导航条
    
    UIView * navLab=[[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    navLab.userInteractionEnabled=YES;
    navLab.backgroundColor=NAV_COLOR;
    [self.view addSubview:navLab];
    
    UILabel * navTitailLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navTitailLab.text=@"兑换";
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
    
    //背景滚动视图
    _bigScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 20+44, self.view.frame.size.width, self.view.frame.size.height-64)];
    [self.view addSubview:_bigScrollView];
    
    _readyView=[[UIView alloc] init];
    _readyView.bounds=CGRectMake(0, 0, SCREEN_WIDTH, 200);
    _readyView.backgroundColor=[UIColor clearColor];
    
     NSArray * arr=[[NSArray alloc] initWithObjects:@"姓名",@"联系电话",@"选择区域",@"具体地址", nil];
    for (int i=0; i<4; i++)
    {
        UIView * view=[[UIView alloc] initWithFrame:CGRectMake(10, 15+i*50, SCREEN_WIDTH-20, 35)];
        view.backgroundColor=[UIColor whiteColor];
        [_readyView addSubview:view];
        
        UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, 35)];
        lab.textAlignment=NSTextAlignmentCenter;
        lab.font=[UIFont systemFontOfSize:15];
        lab.textColor=[UIColor grayColor];
        lab.text=[arr objectAtIndex:i];
        [view addSubview:lab];
        
        UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(70, 10, 1, 15)];
        lineLab.backgroundColor=[UIColor lightGrayColor];
        [view addSubview:lineLab];
        
        if (i!=2)
        {
            UITextField * textField=[[UITextField alloc] initWithFrame:CGRectMake(80, 5, CGRectGetWidth(view.frame)-80-5, 25)];
            textField.font=[UIFont systemFontOfSize:15];
            textField.delegate=self;
            textField.tag=100+i;
            [view addSubview:textField];
        }
        else
        {
            UILabel * quLab=[[UILabel alloc] initWithFrame:CGRectMake(80, 5, CGRectGetWidth(view.frame)-80-20, 25)];
            quLab.userInteractionEnabled=YES;
            quLab.font=[UIFont systemFontOfSize:15];
            quLab.tag=100+i;
            quLab.text=@"请选择区域";
            quLab.textAlignment=NSTextAlignmentCenter;
            quLab.textColor=[UIColor grayColor];
            [view addSubview:quLab];
            
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(80, 0, CGRectGetWidth(view.frame)-80, 35);
            [btn addTarget:self action:@selector(chooseAdress) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
            UIImageView * imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头.png"]];
            imgView.frame=CGRectMake(CGRectGetWidth(view.frame)-15, 12, 8, 10);
            [view addSubview:imgView];
            
        }
    }
    
    
    _bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-80)];
    _bgView.backgroundColor=[UIColor whiteColor];

    _bgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(_bgView.frame)-40)];
    _bgScrollView.scrollEnabled=NO;
    _bgScrollView.contentSize=CGSizeMake(2*SCREEN_WIDTH, CGRectGetHeight(_bgScrollView.frame));
    [_bgView addSubview:_bgScrollView];
    
    UILabel * pcLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bgScrollView.frame), 40)];
    pcLab.backgroundColor=[UIColor colorWithRed:216.0/255.0 green:99.0/255.0 blue:116.0/255.0 alpha:1];
    pcLab.text=@"请选择所在省市";
    pcLab.font=[UIFont systemFontOfSize:18];
    pcLab.textColor=[UIColor whiteColor];
    pcLab.textAlignment=NSTextAlignmentCenter;
    [_bgScrollView addSubview:pcLab];
    
    UILabel * qsLab=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, CGRectGetWidth(_bgScrollView.frame), 40)];
    qsLab.backgroundColor=[UIColor colorWithRed:216.0/255.0 green:99.0/255.0 blue:116.0/255.0 alpha:1];
    qsLab.text=@"请选择所在区和街道";
    qsLab.font=[UIFont systemFontOfSize:18];
    qsLab.textColor=[UIColor whiteColor];
    qsLab.textAlignment=NSTextAlignmentCenter;
    [_bgScrollView addSubview:qsLab];
    
    UIButton * backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(SCREEN_WIDTH, 0, 50, 40);
    [backBtn addTarget:self action:@selector(backPC) forControlEvents:UIControlEventTouchUpInside];
    [_bgScrollView addSubview:backBtn];
    
    UIImageView * backImgView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回按钮.png"]];
    backImgView1.frame=CGRectMake(SCREEN_WIDTH+5, 15, 8, 10);
    [_bgScrollView addSubview:backImgView1];
    
    _provinceTabView=[[UITableView   alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH/2.0, CGRectGetHeight(_bgScrollView.frame)-40) style:UITableViewStylePlain];
    _provinceTabView.tag=301;
    _provinceTabView.delegate=self;
    _provinceTabView.dataSource=self;
    [_bgScrollView addSubview:_provinceTabView];
    
    _cityTableView=[[UITableView   alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, 40, SCREEN_WIDTH/2.0, CGRectGetHeight(_bgScrollView.frame)-40) style:UITableViewStylePlain];
    _cityTableView.hidden=YES;
    _cityTableView.tag=302;
    _cityTableView.delegate=self;
    _cityTableView.dataSource=self;
    [_bgScrollView addSubview:_cityTableView];
    
    _quTabView=[[UITableView   alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 40, SCREEN_WIDTH/2.0, CGRectGetHeight(_bgScrollView.frame)-40) style:UITableViewStylePlain];
    _quTabView.tag=303;
    _quTabView.hidden=YES;
    _quTabView.delegate=self;
    _quTabView.dataSource=self;
    [_bgScrollView addSubview:_quTabView];
    
    _streetTableView=[[UITableView   alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/2.0, 40, SCREEN_WIDTH/2.0, CGRectGetHeight(_bgScrollView.frame)-40) style:UITableViewStylePlain];
    _streetTableView.tag=304;
    _streetTableView.hidden=YES;
    _streetTableView.delegate=self;
    _streetTableView.dataSource=self;
    [_bgScrollView addSubview:_streetTableView];
    
    UIButton * sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setBackgroundColor:[UIColor colorWithRed:216.0/255.0 green:99.0/255.0 blue:116.0/255.0 alpha:1]];
    [sureBtn setTitle:@"确  定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    sureBtn.frame=CGRectMake(0, CGRectGetHeight(_bgView.frame)-40, SCREEN_WIDTH, 40);
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:sureBtn];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag-300)
    {
        case 1:
        {
            return _provinceTitleArr.count;
        }
            break;
        case 2:
        {
            if (pcount!=0)
            {
                return [[_cityTitleArr objectAtIndex:pcount-1] count];
            }
            else
            {
                return 0;
            }
            
        }
            break;
        case 3:
        {
            if (pcount!=0&&ccount!=0)
            {
                 return [[[_quTitleArr objectAtIndex:pcount-1] objectAtIndex:ccount-1] count];
            }
            else
            {
                return 0;
            }
           
        }
            break;
        case 4:
        {
            if (pcount!=0&&ccount!=0&&qcount!=0)
            {
                return [[[[_streetTitleArr objectAtIndex:pcount-1] objectAtIndex:ccount-1] objectAtIndex:qcount-1] count];
            }
            else
            {
                return 0;
            }
            
        }
            break;
            
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(cell.frame)-0.5, CGRectGetWidth(tableView.frame), 0.5)];
        lineLab.backgroundColor=[UIColor brownColor];
        [cell addSubview:lineLab];
        
        UILabel * lineLab2=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(tableView.frame)-0.5, 0, 0.5, CGRectGetHeight(cell.frame))];
        lineLab2.backgroundColor=[UIColor brownColor];
        [cell addSubview:lineLab2];
        
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        
        switch (tableView.tag-300)
        {
            case 1:
            {
                cell.textLabel.text=[_provinceTitleArr objectAtIndex:indexPath.row];
            }
                break;
            case 2:
            {
                if (pcount!=0)
                {
                    cell.textLabel.text=[[_cityTitleArr objectAtIndex:pcount-1] objectAtIndex:indexPath.row];
                }
                
            }
                break;
            case 3:
            {
                if (pcount!=0&&ccount!=0)
                {
                    cell.textLabel.text=[[[_quTitleArr objectAtIndex:pcount-1] objectAtIndex:ccount-1] objectAtIndex:indexPath.row];
                }
                
            }
                break;
            case 4:
            {
                if (pcount!=0&&ccount!=0&&qcount!=0)
                {
                     cell.textLabel.text=[[[[_streetTitleArr objectAtIndex:pcount-1] objectAtIndex:ccount-1] objectAtIndex:qcount-1] objectAtIndex:indexPath.row];
                }
   
            }
                break;
                
            default:
                break;
        }
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (tableView.tag-300)
    {
        case 1:
        {
            _cityTableView.hidden=NO;
            pcount=indexPath.row+1;

        }
            break;
        case 2:
        {
                [_bgScrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(_bgScrollView.frame)) animated:YES];
                _quTabView.hidden=NO;
                ccount=indexPath.row+1;

        }
            break;
        case 3:
        {
            _streetTableView.hidden=NO;
            qcount=indexPath.row+1;

        }
            break;
        case 4:
        {
            scount=indexPath.row+1;
            
            _pIDStr=[_provinceIDArr objectAtIndex:pcount-1];
            _cIDStr=[[_cityIDArr objectAtIndex:pcount-1] objectAtIndex:ccount-1];
            _qIDStr=[[[_quIDArr objectAtIndex:pcount-1] objectAtIndex:ccount-1] objectAtIndex:qcount-1];
            _sIDStr=[[[[_streetIDArr objectAtIndex:pcount-1] objectAtIndex:ccount-1] objectAtIndex:qcount-1] objectAtIndex:scount-1];
            UILabel * lab=(UILabel *)[_bigScrollView viewWithTag:102];
            lab.text=[NSString stringWithFormat:@"%@%@%@%@",[_provinceTitleArr objectAtIndex:pcount-1],[[_cityTitleArr objectAtIndex:pcount-1] objectAtIndex:ccount-1],[[[_quTitleArr objectAtIndex:pcount-1] objectAtIndex:ccount-1] objectAtIndex:qcount-1],[[[[_streetTitleArr objectAtIndex:pcount-1] objectAtIndex:ccount-1] objectAtIndex:qcount-1] objectAtIndex:scount-1]];
              lab.textColor=[UIColor blackColor];
            
            [_bgView removeFromSuperview];

            
        }
            break;
            
        default:
            break;
    }
    [_provinceTabView reloadData];
    [_cityTableView reloadData];
    [_quTabView reloadData];
    [_streetTableView reloadData];
}
-(void)backPC
{
 [_bgScrollView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(_bgScrollView.frame)) animated:YES];
 _quTabView.hidden=YES;
 _streetTableView.hidden=YES;
    qcount=0;
    scount=0;
    ccount=0;
    
}
-(void)sure
{
    UILabel * lab=(UILabel *)[_bigScrollView viewWithTag:102];
    if (pcount==0)
    {
        lab.text=@"请选择区域";
        lab.textColor=[UIColor grayColor];
    }
    else if (pcount!=0&&ccount==0)
    {
        _pIDStr=[_provinceIDArr objectAtIndex:pcount-1];
        lab.text=[_provinceTitleArr objectAtIndex:pcount-1];
        lab.textColor=[UIColor blackColor];
    }
    else if (pcount!=0&&ccount!=0&&qcount==0)
    {
        _pIDStr=[_provinceIDArr objectAtIndex:pcount-1];
        _cIDStr=[[_cityIDArr objectAtIndex:pcount-1] objectAtIndex:ccount-1];
        lab.text=[NSString stringWithFormat:@"%@%@",[_provinceTitleArr objectAtIndex:pcount-1],[[_cityTitleArr objectAtIndex:pcount-1] objectAtIndex:ccount-1]];
          lab.textColor=[UIColor blackColor];
    }
    else if (pcount!=0&&ccount!=0&&qcount!=0&&scount==0)
    {
        _pIDStr=[_provinceIDArr objectAtIndex:pcount-1];
        _cIDStr=[[_cityIDArr objectAtIndex:pcount-1] objectAtIndex:ccount-1];
        _qIDStr=[[[_quIDArr objectAtIndex:pcount-1] objectAtIndex:ccount-1] objectAtIndex:qcount-1];
        lab.text=[NSString stringWithFormat:@"%@%@%@",[_provinceTitleArr objectAtIndex:pcount-1],[[_cityTitleArr objectAtIndex:pcount-1] objectAtIndex:ccount-1],[[[_quTitleArr objectAtIndex:pcount-1] objectAtIndex:ccount-1] objectAtIndex:qcount-1]];
          lab.textColor=[UIColor blackColor];
    }
    else if (pcount!=0&&ccount!=0&&qcount!=0&&scount!=0)
    {
        _pIDStr=[_provinceIDArr objectAtIndex:pcount-1];
        _cIDStr=[[_cityIDArr objectAtIndex:pcount-1] objectAtIndex:ccount-1];
        _qIDStr=[[[_quIDArr objectAtIndex:pcount-1] objectAtIndex:ccount-1] objectAtIndex:qcount-1];
        _sIDStr=[[[[_streetIDArr objectAtIndex:pcount-1] objectAtIndex:ccount-1] objectAtIndex:qcount-1] objectAtIndex:scount-1];
        lab.text=[NSString stringWithFormat:@"%@%@%@%@",[_provinceTitleArr objectAtIndex:pcount-1],[[_cityTitleArr objectAtIndex:pcount-1] objectAtIndex:ccount-1],[[[_quTitleArr objectAtIndex:pcount-1] objectAtIndex:ccount-1] objectAtIndex:qcount-1],[[[[_streetTitleArr objectAtIndex:pcount-1] objectAtIndex:ccount-1] objectAtIndex:qcount-1] objectAtIndex:scount-1]];
          lab.textColor=[UIColor blackColor];
    }
    
    [_bgView removeFromSuperview];

}
-(void)readyUIAgain
{
   
    switch (_listModelArr.count)
    {
        case 0:
        {
            _readyView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 200);
            [_bigScrollView addSubview:_readyView];
            
            UIButton * tijiaoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            tijiaoBtn.frame=CGRectMake(10, CGRectGetHeight(_readyView.frame)+20, self.view.frame.size.width-20, 30);
            tijiaoBtn.tag=200;
            [tijiaoBtn setBackgroundImage:[UIImage imageNamed:@"兑换小背景"] forState:UIControlStateNormal];
            [tijiaoBtn setTitle:@"确认兑换" forState:UIControlStateNormal];
            [tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            tijiaoBtn.titleLabel.font=[UIFont systemFontOfSize:18];
            [tijiaoBtn addTarget:self action:@selector(tijiao) forControlEvents:UIControlEventTouchUpInside];
            [_bigScrollView addSubview:tijiaoBtn];
        }
            break;
        case 1:
        {
            UIView * view1=[[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 49)];
            view1.backgroundColor=[UIColor whiteColor];
            [_bigScrollView addSubview:view1];
            
            UIButton * btn1=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn1 setImage:[UIImage imageNamed:@"checkbox_check_off.png"] forState:UIControlStateNormal];
            [btn1 setImage:[UIImage imageNamed:@"checkbox_check_on.png"] forState:UIControlStateSelected];
            btn1.selected=YES;
            _selectBtn=btn1;
            btn1.tag=51;
            btn1.frame=CGRectMake(8, 15, 22, 20);
            [btn1 addTarget:self action:@selector(gouxuan:) forControlEvents:UIControlEventTouchUpInside];
            [view1 addSubview:btn1];
            
            UILabel *lab1_1=[[UILabel alloc] initWithFrame:CGRectMake(35, 5, CGRectGetWidth(view1.frame)-40, 20)];
            lab1_1.font=[UIFont systemFontOfSize:14];
            lab1_1.textColor=[UIColor grayColor];
            [view1 addSubview:lab1_1];
            
            UILabel *lab1_2=[[UILabel alloc] initWithFrame:CGRectMake(35, 25, CGRectGetWidth(view1.frame)-40, 20)];
            lab1_2.font=[UIFont systemFontOfSize:14];
            lab1_2.textColor=[UIColor grayColor];
            [view1 addSubview:lab1_2];
            
            JTSortModel * model1=[[JTSortModel alloc] init];
            model1=[_listModelArr objectAtIndex:0];
            lab1_1.text=[NSString stringWithFormat:@"%@        %@",model1.name,model1.tel];
            lab1_2.text=model1.infoAddress;
            
            UIButton * newAdressBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            newAdressBtn.frame=CGRectMake((SCREEN_WIDTH-100)/2.0, 10+50+10, 100, 40);
            newAdressBtn.backgroundColor=[UIColor colorWithRed:250.0/255.0 green:225.0/255.0 blue:231.0/255.0 alpha:1];
            [newAdressBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
            [newAdressBtn setTitle:@"使用新地址" forState:UIControlStateNormal];
            newAdressBtn.tag=21;
            [newAdressBtn addTarget:self action:@selector(newAdress:) forControlEvents:UIControlEventTouchUpInside];
            [_bigScrollView addSubview:newAdressBtn];
            
            UIButton * tijiaoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            tijiaoBtn.frame=CGRectMake(10, 10+50+40+20, self.view.frame.size.width-20, 30);
             tijiaoBtn.tag=200;
            [tijiaoBtn setBackgroundImage:[UIImage imageNamed:@"兑换小背景"] forState:UIControlStateNormal];
            [tijiaoBtn setTitle:@"确认兑换" forState:UIControlStateNormal];
            [tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            tijiaoBtn.titleLabel.font=[UIFont systemFontOfSize:18];
            [tijiaoBtn addTarget:self action:@selector(tijiao) forControlEvents:UIControlEventTouchUpInside];
            [_bigScrollView addSubview:tijiaoBtn];
            
        }
            break;
        case 2:
        {
            UIView * view1=[[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 49)];
            view1.backgroundColor=[UIColor whiteColor];
            [_bigScrollView addSubview:view1];
            
            UIButton * btn1=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn1 setImage:[UIImage imageNamed:@"checkbox_check_off.png"] forState:UIControlStateNormal];
            [btn1 setImage:[UIImage imageNamed:@"checkbox_check_on.png"] forState:UIControlStateSelected];
            btn1.selected=YES;
            _selectBtn=btn1;
            btn1.tag=51;
            btn1.frame=CGRectMake(8, 15, 22, 20);
            [btn1 addTarget:self action:@selector(gouxuan:) forControlEvents:UIControlEventTouchUpInside];
            [view1 addSubview:btn1];
            
            UILabel *lab1_1=[[UILabel alloc] initWithFrame:CGRectMake(35, 5, CGRectGetWidth(view1.frame)-40, 20)];
            lab1_1.font=[UIFont systemFontOfSize:14];
            lab1_1.textColor=[UIColor grayColor];
            [view1 addSubview:lab1_1];
            
            UILabel *lab1_2=[[UILabel alloc] initWithFrame:CGRectMake(35, 25, CGRectGetWidth(view1.frame)-40, 20)];
            lab1_2.font=[UIFont systemFontOfSize:14];
            lab1_2.textColor=[UIColor grayColor];
            [view1 addSubview:lab1_2];
            
            UIView * view2=[[UIView alloc] initWithFrame:CGRectMake(0, 10+50, SCREEN_WIDTH, 49)];
            view2.backgroundColor=[UIColor whiteColor];
            [_bigScrollView addSubview:view2];
            
            UIButton * btn2=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn2 setImage:[UIImage imageNamed:@"checkbox_check_off.png"] forState:UIControlStateNormal];
            [btn2 setImage:[UIImage imageNamed:@"checkbox_check_on.png"] forState:UIControlStateSelected];
            btn2.selected=NO;
            btn2.tag=52;
            btn2.frame=CGRectMake(8, 15, 22, 20);
            [btn2 addTarget:self action:@selector(gouxuan:) forControlEvents:UIControlEventTouchUpInside];
            [view2 addSubview:btn2];
            
            UILabel *lab2_1=[[UILabel alloc] initWithFrame:CGRectMake(35, 5, CGRectGetWidth(view1.frame)-40, 20)];
            lab2_1.font=[UIFont systemFontOfSize:14];
            lab2_1.textColor=[UIColor grayColor];
            [view2 addSubview:lab2_1];
            
            UILabel *lab2_2=[[UILabel alloc] initWithFrame:CGRectMake(35, 25, CGRectGetWidth(view1.frame)-40, 20)];
            lab2_2.font=[UIFont systemFontOfSize:14];
            lab2_2.textColor=[UIColor grayColor];
            [view2 addSubview:lab2_2];
            
            JTSortModel * model1=[[JTSortModel alloc] init];
            model1=[_listModelArr objectAtIndex:0];
            lab1_1.text=[NSString stringWithFormat:@"%@        %@",model1.name,model1.tel];
            lab1_2.text=model1.infoAddress;

            
            JTSortModel * model2=[[JTSortModel alloc] init];
            model2=[_listModelArr objectAtIndex:1];
            lab2_1.text=[NSString stringWithFormat:@"%@        %@",model2.name,model2.tel];
            lab2_2.text=model2.infoAddress;
            
            UIButton * newAdressBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            newAdressBtn.frame=CGRectMake((SCREEN_WIDTH-100)/2.0, 10+50+50+10, 100, 40);
            newAdressBtn.backgroundColor=[UIColor colorWithRed:250.0/255.0 green:225.0/255.0 blue:231.0/255.0 alpha:1];
            [newAdressBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
            [newAdressBtn setTitle:@"使用新地址" forState:UIControlStateNormal];
            newAdressBtn.tag=22;
            [newAdressBtn addTarget:self action:@selector(newAdress:) forControlEvents:UIControlEventTouchUpInside];
            [_bigScrollView addSubview:newAdressBtn];
            
            UIButton * tijiaoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            tijiaoBtn.frame=CGRectMake(10, 10+50+50+40+20, self.view.frame.size.width-20, 30);
             tijiaoBtn.tag=200;
            [tijiaoBtn setBackgroundImage:[UIImage imageNamed:@"兑换小背景"] forState:UIControlStateNormal];
            [tijiaoBtn setTitle:@"确认兑换" forState:UIControlStateNormal];
            [tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            tijiaoBtn.titleLabel.font=[UIFont systemFontOfSize:18];
            [tijiaoBtn addTarget:self action:@selector(tijiao) forControlEvents:UIControlEventTouchUpInside];
            [_bigScrollView addSubview:tijiaoBtn];

        }
            break;
        case 3:
        {
            UIView * view1=[[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 49)];
            view1.backgroundColor=[UIColor whiteColor];
            [_bigScrollView addSubview:view1];
            
            UIButton * btn1=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn1 setImage:[UIImage imageNamed:@"checkbox_check_off.png"] forState:UIControlStateNormal];
            [btn1 setImage:[UIImage imageNamed:@"checkbox_check_on.png"] forState:UIControlStateSelected];
            btn1.selected=YES;
            _selectBtn=btn1;
            btn1.tag=51;
            btn1.frame=CGRectMake(8, 15, 22, 20);
            [btn1 addTarget:self action:@selector(gouxuan:) forControlEvents:UIControlEventTouchUpInside];
            [view1 addSubview:btn1];
            
            UILabel *lab1_1=[[UILabel alloc] initWithFrame:CGRectMake(35, 5, CGRectGetWidth(view1.frame)-40, 20)];
            lab1_1.font=[UIFont systemFontOfSize:14];
            lab1_1.textColor=[UIColor grayColor];
            [view1 addSubview:lab1_1];
            
            UILabel *lab1_2=[[UILabel alloc] initWithFrame:CGRectMake(35, 25, CGRectGetWidth(view1.frame)-40, 20)];
            lab1_2.font=[UIFont systemFontOfSize:14];
            lab1_2.textColor=[UIColor grayColor];
            [view1 addSubview:lab1_2];
            
            UIView * view2=[[UIView alloc] initWithFrame:CGRectMake(0, 10+50, SCREEN_WIDTH, 49)];
            view2.backgroundColor=[UIColor whiteColor];
            [_bigScrollView addSubview:view2];
            
            UIButton * btn2=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn2 setImage:[UIImage imageNamed:@"checkbox_check_off.png"] forState:UIControlStateNormal];
            [btn2 setImage:[UIImage imageNamed:@"checkbox_check_on.png"] forState:UIControlStateSelected];
            btn2.selected=NO;
            btn2.tag=52;
            btn2.frame=CGRectMake(8, 15, 22, 20);
            [btn2 addTarget:self action:@selector(gouxuan:) forControlEvents:UIControlEventTouchUpInside];
            [view2 addSubview:btn2];
            
            UILabel *lab2_1=[[UILabel alloc] initWithFrame:CGRectMake(35, 5, CGRectGetWidth(view1.frame)-40, 20)];
            lab2_1.font=[UIFont systemFontOfSize:14];
            lab2_1.textColor=[UIColor grayColor];
            [view2 addSubview:lab2_1];
            
            UILabel *lab2_2=[[UILabel alloc] initWithFrame:CGRectMake(35, 25, CGRectGetWidth(view1.frame)-40, 20)];
            lab2_2.font=[UIFont systemFontOfSize:14];
            lab2_2.textColor=[UIColor grayColor];
            [view2 addSubview:lab2_2];
            
            UIView * view3=[[UIView alloc] initWithFrame:CGRectMake(0, 10+50+50, SCREEN_WIDTH, 49)];
            view3.backgroundColor=[UIColor whiteColor];
            [_bigScrollView addSubview:view3];
            
            UIButton * btn3=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn3 setImage:[UIImage imageNamed:@"checkbox_check_off.png"] forState:UIControlStateNormal];
            [btn3 setImage:[UIImage imageNamed:@"checkbox_check_on.png"] forState:UIControlStateSelected];
            btn3.selected=NO;
            btn3.tag=53;
            btn3.frame=CGRectMake(8, 15, 22, 20);
            [btn3 addTarget:self action:@selector(gouxuan:) forControlEvents:UIControlEventTouchUpInside];
            [view3 addSubview:btn3];
            
            UILabel *lab3_1=[[UILabel alloc] initWithFrame:CGRectMake(35, 5, CGRectGetWidth(view1.frame)-40, 20)];
            lab3_1.font=[UIFont systemFontOfSize:14];
            lab3_1.textColor=[UIColor grayColor];
            [view3 addSubview:lab3_1];
            
            UILabel *lab3_2=[[UILabel alloc] initWithFrame:CGRectMake(35, 25, CGRectGetWidth(view1.frame)-40, 20)];
            lab3_2.font=[UIFont systemFontOfSize:14];
            lab3_2.textColor=[UIColor grayColor];
            [view3 addSubview:lab3_2];

            
            JTSortModel * model1=[[JTSortModel alloc] init];
            model1=[_listModelArr objectAtIndex:0];
            lab1_1.text=[NSString stringWithFormat:@"%@        %@",model1.name,model1.tel];
            lab1_2.text=model1.infoAddress;
            
            
            JTSortModel * model2=[[JTSortModel alloc] init];
            model2=[_listModelArr objectAtIndex:1];
            lab2_1.text=[NSString stringWithFormat:@"%@        %@",model2.name,model2.tel];
            lab2_2.text=model2.infoAddress;
            
            JTSortModel * model3=[[JTSortModel alloc] init];
            model3=[_listModelArr objectAtIndex:2];
            lab3_1.text=[NSString stringWithFormat:@"%@        %@",model3.name,model3.tel];
            lab3_2.text=model3.infoAddress;
            
            UIButton * newAdressBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            newAdressBtn.frame=CGRectMake((SCREEN_WIDTH-100)/2.0, 10+50+50+50+10, 100, 40);
            newAdressBtn.backgroundColor=[UIColor colorWithRed:250.0/255.0 green:225.0/255.0 blue:231.0/255.0 alpha:1];
            [newAdressBtn setTitle:@"使用新地址" forState:UIControlStateNormal];
            [newAdressBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
            newAdressBtn.tag=23;
            [newAdressBtn addTarget:self action:@selector(newAdress:) forControlEvents:UIControlEventTouchUpInside];
            [_bigScrollView addSubview:newAdressBtn];
            
            UIButton * tijiaoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            tijiaoBtn.frame=CGRectMake(10, 10+50+50+50+40+20, self.view.frame.size.width-20, 30);
            tijiaoBtn.tag=200;
            [tijiaoBtn setBackgroundImage:[UIImage imageNamed:@"兑换小背景"] forState:UIControlStateNormal];
            [tijiaoBtn setTitle:@"确认兑换" forState:UIControlStateNormal];
            [tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            tijiaoBtn.titleLabel.font=[UIFont systemFontOfSize:18];
            [tijiaoBtn addTarget:self action:@selector(tijiao) forControlEvents:UIControlEventTouchUpInside];
            [_bigScrollView addSubview:tijiaoBtn];
        }
            break;
            
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _bigScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 10+_listModelArr.count*50+10+40+_readyView.frame.size.height+20+40+253);
    [_bigScrollView scrollRectToVisible:CGRectMake(0, 10+_listModelArr.count*50+10+40, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_HEIGHT-20) animated:NO];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _bigScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 10+_listModelArr.count*50+10+40+_readyView.frame.size.height+20+40);
}
-(void)chooseAdress
{
    [self.view endEditing:YES];

    
    pcount=0;
    ccount=0;
    qcount=0;
    scount=0;
    
    _cityTableView.hidden=YES;
    _quTabView.hidden=YES;
    _streetTableView.hidden=YES;


    [_provinceTabView reloadData];
    [_cityTableView reloadData];
    [_quTabView reloadData];
    [_streetTableView reloadData];
    
    [self.view addSubview:_bgView];
    [_bgScrollView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(_bgScrollView.frame)) animated:NO];
    
}
-(void)gouxuan:(UIButton *)sender
{
    if (_selectBtn!=nil)
    {
        if (sender==_selectBtn)
        {
        }
        else
        {
            _selectBtn.selected=NO;
            sender.selected=YES;
            _selectBtn=sender;
        }
    }
    else
    {
        sender.selected=YES;
        _selectBtn=sender;
    
    }
    [_readyView removeFromSuperview];
    UIButton * tijiaoBtn=(UIButton *)[_bigScrollView viewWithTag:200];
    tijiaoBtn.frame=CGRectMake(10, 10+50*_listModelArr.count+40+20, self.view.frame.size.width-20, 30);
    
}
-(void)newAdress:(UIButton *)sender
{
    
    _bigScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 10+_listModelArr.count*50+10+40+_readyView.frame.size.height+20+40);
    _selectBtn.selected=NO;
    _selectBtn=nil;
    
    switch (sender.tag-20)
    {
        case 1:
        {
            _readyView.frame=CGRectMake(0, 10+50+40+10, SCREEN_WIDTH, 200);
            [_bigScrollView addSubview:_readyView];
            UIButton * tijiaoBtn=(UIButton *)[_bigScrollView viewWithTag:200];
            tijiaoBtn.frame=CGRectMake(10, 10+50+40+10+CGRectGetHeight(_readyView.frame)+20, self.view.frame.size.width-20, 30);
        }
            break;
        case 2:
        {
            _readyView.frame=CGRectMake(0, 10+50+50+40+10, SCREEN_WIDTH, 200);
            [_bigScrollView addSubview:_readyView];
            UIButton * tijiaoBtn=(UIButton *)[_bigScrollView viewWithTag:200];
            tijiaoBtn.frame=CGRectMake(10, 10+50+50+40+10+CGRectGetHeight(_readyView.frame)+20, self.view.frame.size.width-20, 30);
        }
            break;
        case 3:
        {
            _readyView.frame=CGRectMake(0, 10+50+50+50+40+10, SCREEN_WIDTH, 200);
            [_bigScrollView addSubview:_readyView];
            UIButton * tijiaoBtn=(UIButton *)[_bigScrollView viewWithTag:200];
            tijiaoBtn.frame=CGRectMake(10, 10+50+50+50+40+10+CGRectGetHeight(_readyView.frame)+20, self.view.frame.size.width-20, 30);
        }
            break;
            
        default:
            break;
    }

}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sendPost
{
    JTAppDelegate * appDelegate= [UIApplication sharedApplication].delegate;
    NSString * userID=@"";
    userID=[NSString stringWithFormat:@"%d",appDelegate.appUser.userID];
    
    if ([SOAPRequest checkNet])
    {
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:userID,@"userId", nil];
        
        NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_PointsMall_GetLastConsigneeAddress] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            NSArray *resultArr=[[NSArray alloc] initWithArray:[zaojiaoDic objectForKey:@"lastConsigneeAddress"]];
            for (int i=0; i<resultArr.count; i++)
            {
                JTSortModel * model=[[JTSortModel alloc] init];
                model.idStr=[[resultArr objectAtIndex:i] objectForKey:@"id"];
                model.name=[[resultArr objectAtIndex:i] objectForKey:@"name"];
                model.provinceIDStr=[[resultArr objectAtIndex:i] objectForKey:@"provinceId"];
                model.cityIDStr=[[resultArr objectAtIndex:i] objectForKey:@"cityId"];
                model.quIDStr=[[resultArr objectAtIndex:i] objectForKey:@"regionId"];
                model.streetIDStr=[[resultArr objectAtIndex:i] objectForKey:@"streetId"];
                model.street=[[resultArr objectAtIndex:i] objectForKey:@"recipientAddress"];
                model.infoAddress=[[resultArr objectAtIndex:i] objectForKey:@"addressValue"];
                model.tel=[[resultArr objectAtIndex:i] objectForKey:@"phone"];
                
                [_listModelArr addObject:model];

            }
        }

    }
}
-(void)tijiao
{
    [self.view endEditing:YES];
    
    if(_selectBtn!=nil)
    {
        if ([SOAPRequest checkNet])
        {
            JTAppDelegate * appDelegate= [UIApplication sharedApplication].delegate;
            NSString * userID=@"";
            userID=[NSString stringWithFormat:@"%d",appDelegate.appUser.userID];
            
            JTSortModel * model=[_listModelArr objectAtIndex:_selectBtn.tag-51];
            
            NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:userID,@"userId",self.giftIdStr,@"giftId",model.idStr,@"consigneeAddressId",@"",@"name",@"", @"province",@"",@"city",@"",@"region",@"",@"street",@"",@"phone",@"",@"address", nil];
            
            NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_PointsMall_SavePointsorder] jsonDic:jsondic]];
            
            if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
            {
                UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"恭喜，兑换成功！可到兑换历史订单中查询哦！" delegate:nil cancelButtonTitle:nil   otherButtonTitles:@"OK，我知道了。。", nil];
                [alertView show];
                [self getNewUser];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"2011"])
            {
                NSString * str=@"您的积分不够哎，快去挣积分吧。。";
                [JTAlertViewAnimation startAnimation:str view:self.view];
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
        UITextField * textField1=(UITextField *)[self.view viewWithTag:100];
        UITextField * textField2=(UITextField *)[self.view viewWithTag:101];
        UITextField * textField3=(UITextField *)[self.view viewWithTag:103];
        if ([textField1.text isEqualToString:@""]||[textField2.text isEqualToString:@""]||[textField3.text isEqualToString:@""])
        {
            NSString * str=@"请完整填写以上信息";
            [JTAlertViewAnimation startAnimation:str view:self.view];
            return;
        }
        
        NSString * pIdStr=@"";
        NSString * cIdStr=@"";
        NSString * qIdStr=@"";
        NSString * sIdStr=@"";
        if (pcount!=0)
        {
            pIdStr=[_provinceIDArr objectAtIndex:pcount-1];
        }
        if (ccount!=0)
        {
            cIdStr=[[_cityIDArr objectAtIndex:pcount-1] objectAtIndex:ccount-1];
        }
        if (qcount!=0)
        {
            qIdStr=[[[_quIDArr objectAtIndex:pcount-1] objectAtIndex:ccount-1] objectAtIndex:qcount-1];
        }
        if (scount!=0)
        {
            sIdStr=[[[[_streetIDArr objectAtIndex:pcount-1] objectAtIndex:ccount-1] objectAtIndex:qcount-1] objectAtIndex:scount-1];
        }
        
        if ([SOAPRequest checkNet])
        {
            JTAppDelegate * appDelegate= [UIApplication sharedApplication].delegate;
            NSString * userID=@"";
            userID=[NSString stringWithFormat:@"%d",appDelegate.appUser.userID];
            
            NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:userID,@"userId",self.giftIdStr,@"giftId",@"",@"consigneeAddressId",textField1.text,@"name",pIdStr, @"province",cIdStr,@"city",qIdStr,@"region",sIdStr,@"street",textField2.text,@"phone",textField3.text,@"address", nil];
            
            NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_PointsMall_SavePointsorder] jsonDic:jsondic]];
            
            if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
            {
                UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"恭喜，兑换成功！可到兑换历史订单中查询哦！" delegate:nil cancelButtonTitle:nil   otherButtonTitles:@"OK，我知道了。。", nil];
                [alertView show];
                [self getNewUser];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"2011"])
            {
                NSString * str=@"您的积分不够哎，快去看看积分说明，挣点积分去吧。。";
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
-(void)getNewUser
{
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    if ([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appdelegate.appUser.userID],@"userId", nil];
        
        NSDictionary * signDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_GetUserInfoByIdURL] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[signDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            NSDictionary * userDic=[signDic objectForKey:@"user"];
            
            appdelegate.appUser.userID=[[userDic objectForKey:@"id"] intValue];
            appdelegate.appUser.loginName=[userDic objectForKey:@"loginName"];
            appdelegate.appUser.password=[userDic objectForKey:@"password"];
            appdelegate.appUser.userName=[userDic objectForKey:@"userName"];
            NSString * sexStr=[userDic objectForKey:@"sex"];
            if ([sexStr isEqualToString:@"MALE"])
            {
                appdelegate.appUser.sex=0;//男
            }
            else if ([sexStr isEqualToString:@"FEMALE"])
            {
                appdelegate.appUser.sex=1;//女
            }
            appdelegate.appUser.headPortraitImgUrlStr=[userDic objectForKey:@"imageValue"];
            appdelegate.appUser.email=[userDic objectForKey:@"email"];
            appdelegate.appUser.phone=[userDic objectForKey:@"tel"];
            appdelegate.appUser.provinceID=[[userDic objectForKey:@"provinceId"] intValue];
            appdelegate.appUser.cityID=[[userDic objectForKey:@"cityId"] intValue];
            appdelegate.appUser.regionId=[[userDic objectForKey:@"regionId"] intValue];
            appdelegate.appUser.streetId=[[userDic objectForKey:@"streetId"] intValue];
            appdelegate.appUser.address=[userDic objectForKey:@"address"];

            appdelegate.appUser.isContinuous=[userDic objectForKey:@"continuous"];
            appdelegate.appUser.points=[userDic objectForKey:@"points"];
            appdelegate.appUser.availablePoints=[userDic objectForKey:@"availablePoints"];
            appdelegate.appUser.pointsTitle=[userDic objectForKey:@"pointsTitle"];
    
            
            appdelegate.appUser.provinceValue=[userDic objectForKey:@"provinceName"];
            appdelegate.appUser.cityValue=[userDic objectForKey:@"cityName"];
            appdelegate.appUser.regionName=[userDic objectForKey:@"regionName"];
            appdelegate.appUser.streetName=[userDic objectForKey:@"streetName"];
            appdelegate.appUser.isSignin=[userDic objectForKey:@"signinFlag"];
            appdelegate.appUser.EMuserLoginName=[userDic objectForKey:@"easemobUsername"];
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
