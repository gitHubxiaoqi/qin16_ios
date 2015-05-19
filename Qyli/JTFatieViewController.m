//
//  JTFatieViewController.m
//  清一丽
//
//  Created by 小七 on 15-4-15.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTFatieViewController.h"

@interface JTFatieViewController ()<UITextFieldDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UIScrollView * _bigScrollView;
    UITextField * _topicTextField;
    UITextView * _contentTextView;
    UILabel * _typeTitleLab;
    UITableView * _typeTabView;
    NSString * _typeID;
    
    UIImagePickerController * imagePicker;
    int p;
    
}
@property(nonatomic,strong)NSString * headImgData1;
@property(nonatomic,strong)NSString * headImgData2;
@property(nonatomic,strong)NSString * headImgData3;
@property(nonatomic,strong)NSString * headImgData4;
@end

@implementation JTFatieViewController
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
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _typeID=@"";
    p=0;
    self.headImgData1=@"";
    self.headImgData2=@"";
    self.headImgData3=@"";
    self.headImgData4=@"";
    for (int i=1; i<5; i++)
    {
        NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"currentImage%d.png",i]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            //从沙盒中删除该文件
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
        
    }

    
    self.view.backgroundColor=BG_COLOR;
    self.navigationController.navigationBar.hidden=YES;
    //自定义导航条
    UIView * navBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    navBarView.backgroundColor=NAV_COLOR;
    [self.view addSubview:navBarView];
    
    UIButton * leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 2, 50, 40);
    [leftBtn addTarget:self action:@selector(leftBtnCilck) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    
    UIImageView * jiantouImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回按钮.png"]];
    jiantouImgView.frame=CGRectMake(20, 15, 10, 14);
    [leftBtn addSubview:jiantouImgView];
    
    UILabel * navTitailLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navTitailLab.text=@"发帖";
    navTitailLab.textAlignment=NSTextAlignmentCenter;
    navTitailLab.textColor=[UIColor whiteColor];
    navTitailLab.font=[UIFont systemFontOfSize:22];
    [navBarView addSubview:navTitailLab];
    
    _bigScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 20+NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-20-NAV_HEIGHT)];
    _bigScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, CGRectGetHeight(_bigScrollView.frame));
    [self.view addSubview:_bigScrollView];
    
    UIView * shadowView=[[UIView alloc] initWithFrame:self.view.frame];
    shadowView.tag=301;
    shadowView.backgroundColor=[UIColor blackColor];
    shadowView.alpha=0.4;
    shadowView.hidden=YES;
    [self.view addSubview:shadowView];
    
    _typeTabView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.view.center.y-150,self.view.frame.size.width,216) style:UITableViewStylePlain];
    _typeTabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _typeTabView.delegate=self;
    _typeTabView.dataSource=self;
    _typeTabView.hidden=YES;
    [self.view addSubview:_typeTabView];
    
    [self readyUI];
    
}
-(void)readyUI
{
    UIView * view1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view1.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view1];
    
    UILabel * lab1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, CGRectGetHeight(view1.frame))];
    lab1.text=@"标    题";
    lab1.textColor=NAV_COLOR;
    lab1.textAlignment=NSTextAlignmentCenter;
    lab1.font=[UIFont systemFontOfSize:16];
    [view1 addSubview:lab1];
    
    UILabel * lineLab1=[[UILabel alloc] initWithFrame:CGRectMake(104, 10, 1, 20)];
    lineLab1.backgroundColor=[UIColor grayColor];
    [view1 addSubview:lineLab1];
    
    _topicTextField=[[UITextField alloc] initWithFrame:CGRectMake(110, 10, SCREEN_WIDTH-110-10,  CGRectGetHeight(view1.frame)-20)];
    _topicTextField.delegate=self;
    _topicTextField.placeholder=@"请填写帖子主题";
    _topicTextField.font=[UIFont systemFontOfSize:15];
    _topicTextField.textColor=[UIColor blackColor];
    [view1 addSubview:_topicTextField];
    
    
    UIView * view2=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(view1.frame)+5, SCREEN_WIDTH, 120)];
    view2.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view2];
    
    UILabel * lab2=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, CGRectGetHeight(view1.frame))];
    lab2.text=@"内    容";
    lab2.textColor=NAV_COLOR;
    lab2.textAlignment=NSTextAlignmentCenter;
    lab2.font=[UIFont systemFontOfSize:16];
    [view2 addSubview:lab2];
    
    UILabel * lineLab2=[[UILabel alloc] initWithFrame:CGRectMake(104,10, 1, 20)];
    lineLab2.backgroundColor=[UIColor grayColor];
    [view2 addSubview:lineLab2];
    
    _contentTextView=[[UITextView alloc] initWithFrame:CGRectMake(110, 5, SCREEN_WIDTH-110-10, CGRectGetHeight(view2.frame)-10)];
    _contentTextView.delegate=self;
    _contentTextView.textColor=[UIColor grayColor];
    _contentTextView.font=[UIFont systemFontOfSize:14];
    [view2 addSubview:_contentTextView];
    
    UILabel * placeHolderLab=[[UILabel alloc] init];
    placeHolderLab.frame=CGRectMake(110, 10,SCREEN_WIDTH-110-10,20);
    placeHolderLab.tag=80;
    placeHolderLab.text = @"请填写帖子内容";
    placeHolderLab.enabled = NO;//lable必须设置为不可用
    placeHolderLab.textColor=[UIColor lightGrayColor];
    placeHolderLab.font=[UIFont systemFontOfSize:14];
    placeHolderLab.backgroundColor = [UIColor clearColor];
    [view2 addSubview:placeHolderLab];
    
    UIView * view3=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(view1.frame)+5+CGRectGetHeight(view2.frame)+5, SCREEN_WIDTH, 40)];
    view3.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view3];
    
    UILabel * lab3=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, CGRectGetHeight(view3.frame))];
    lab3.text=@"帖子类型";
    lab3.textColor=NAV_COLOR;
    lab3.textAlignment=NSTextAlignmentCenter;
    lab3.font=[UIFont systemFontOfSize:16];
    [view3 addSubview:lab3];
    
    UILabel * lineLab3=[[UILabel alloc] initWithFrame:CGRectMake(104, 10, 1, 20)];
    lineLab3.backgroundColor=[UIColor grayColor];
    [view3 addSubview:lineLab3];
    
    UIButton * typeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    typeBtn.frame=CGRectMake(110, 0, SCREEN_WIDTH-110, 40);
    [typeBtn addTarget:self action:@selector(typeChoose) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:typeBtn];
    
    _typeTitleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH-100-20, 20)];
    _typeTitleLab.textColor=[UIColor brownColor];
    _typeTitleLab.textAlignment=NSTextAlignmentCenter;
    _typeTitleLab.font=[UIFont systemFontOfSize:14];
    _typeTitleLab.tag=50;
    _typeTitleLab.text=@"请选择帖子类型";
    [typeBtn addSubview:_typeTitleLab];
    
    UIImageView * typeImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头.png"]];
    typeImgView.frame=CGRectMake( SCREEN_WIDTH-110-18, 14, 8, 12);
    [typeBtn addSubview:typeImgView];
    
    
    for (int i=0; i<4; i++)
    {
        UIButton*  btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(10+i*((self.view.frame.size.width-20-100)/4.0+33.3), CGRectGetHeight(view1.frame)+5+CGRectGetHeight(view2.frame)+5+CGRectGetHeight(view3.frame)+10, (self.view.frame.size.width-20-100)/4.0, 60);
        [btn setImage:[UIImage imageNamed:@"add_image.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(chooseImg:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=11+i;
        [_bigScrollView addSubview:btn];
    }
    
    //发布按钮
    UIButton * fbBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    fbBtn.backgroundColor=NAV_COLOR;
    [fbBtn setTitle:@"立即发布" forState:UIControlStateNormal];
    [fbBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    fbBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    fbBtn.frame=CGRectMake(10,CGRectGetHeight(view1.frame)+5+CGRectGetHeight(view2.frame)+5+CGRectGetHeight(view3.frame)+10+60+15, SCREEN_WIDTH-20, 35);
    [fbBtn addTarget:self action:@selector(fbBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bigScrollView addSubview:fbBtn];

}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-选取图片
-(void)chooseImg:(UIButton *)sender
{
    NSLog(@"选择图片");
    
    switch (sender.tag-11)
    {
        case 0:
        {
            p=1;
        }
            break;
        case 1:
        {
            p=2;
        }
            break;
        case 2:
        {
            p=3;
        }
            break;
        case 3:
        {
            p=4;
        }
            break;
            
        default:
            break;
    }
    
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择",@"删除", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择",@"删除", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}
#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255)
    {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            
            switch (buttonIndex)
            {
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
                case 3:
                    //删除
                { NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"currentImage%d.png",p]];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
                    {
                        //从沙盒中删除该文件
                        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                    }
                    //删除data
                    switch (p)
                    {
                        case 0:
                            
                            break;
                        case 1:
                        {
                            self.headImgData1=@"";
                        }
                            break;
                        case 2:
                        {
                            self.headImgData2=@"";
                        }
                            break;
                        case 3:
                        {
                            self.headImgData3=@"";
                        }
                            break;
                        case 4:
                        {
                            self.headImgData4=@"";
                        }
                            break;
                            
                        default:
                            break;
                    }
                    UIButton * btn=(UIButton *)[self.view viewWithTag:p+10];
                    [btn setImage:[UIImage imageNamed:@"add_image.png"] forState:UIControlStateNormal];
                    return;
                }
                    
                    break;
            }
        }
        else
        {
            if (buttonIndex == 0)
            {
                
                return;
            }
            else if (buttonIndex==2)
            {
                //删除
                { NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"currentImage%d.png",p]];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
                    {
                        //从沙盒中删除该文件
                        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                    }
                    //删除data
                    switch (p)
                    {
                        case 0:
                            
                            break;
                        case 1:
                        {
                            self.headImgData1=@"";
                        }
                            break;
                        case 2:
                        {
                            self.headImgData2=@"";
                        }
                            break;
                        case 3:
                        {
                            self.headImgData3=@"";
                        }
                            break;
                        case 4:
                        {
                            self.headImgData4=@"";
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                UIButton * btn=(UIButton *)[self.view viewWithTag:p+10];
                [btn setImage:[UIImage imageNamed:@"add_image.png"] forState:UIControlStateNormal];
                return;
            }
            else
            {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        
        JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
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
    
    //文件管理器判断是否存在路径为path的文件，存在就从沙盒中删除该文件
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"currentImage%d.png",p]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        //从沙盒中删除该文件
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        
        switch (p) {
            case 0:
                break;
            case 1:
            {
                self.headImgData1=@"";
            }
                break;
            case 2:
            {
                self.headImgData2=@"";
            }
                break;
            case 3:
            {
                self.headImgData3=@"";
            }
                break;
            case 4:
            {
                self.headImgData4=@"";
            }
                break;
                
            default:
                break;
        }
        
    }
    //保存新图片
    [self saveImage:image withName:[NSString stringWithFormat:@"currentImage%d.png",p]];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"currentImage%d.png",p]];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    
    UIButton * btn=(UIButton *)[self.view viewWithTag:p+10];
    [btn setImage:savedImage forState:UIControlStateNormal];
    
    //NSData * data=UIImagePNGRepresentation(savedImage);
    NSData *data=UIImageJPEGRepresentation(savedImage, 0.0001);
    switch (p)
    {
        case 1:
        {
            self.headImgData1=[data base64EncodedString];
            self.headImgData1 = [self.headImgData1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
            self.headImgData1 = [self.headImgData1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            self.headImgData1 = [self.headImgData1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
            break;
        case 2:
        {
            self.headImgData2=[data base64EncodedString];
            self.headImgData2 = [self.headImgData2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
            self.headImgData2 = [self.headImgData2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            self.headImgData2 = [self.headImgData2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
            break;
        case 3:
        {
            self.headImgData3=[data base64EncodedString];
            self.headImgData3 = [self.headImgData3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
            self.headImgData3 = [self.headImgData3 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            self.headImgData3 = [self.headImgData3 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
            break;
        case 4:
        {
            self.headImgData4=[data base64EncodedString];
            self.headImgData4 = [self.headImgData4 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
            self.headImgData4 = [self.headImgData4 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            self.headImgData4 = [self.headImgData4 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
            break;
        default:
            break;
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    appdelegate.tabBarView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-49, self.view.frame.size.width, 49);
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

#pragma mark-touch事件及返回
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    _bigScrollView.contentSize=CGSizeMake(SCREEN_WIDTH,340);
    UIView * shadowView=[self.view viewWithTag:301];
    shadowView.hidden=YES;
    _typeTabView.hidden=YES;
}

#pragma mark-选择类型
-(void)typeChoose
{
    [self.view endEditing:YES];
    UIView * shadowView=[self.view viewWithTag:301];
    shadowView.hidden=NO;
    _typeTabView.hidden=NO;
    [self.view bringSubviewToFront:_typeTabView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _typeArr.count;
    
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
    cell.textLabel.text=[_typeArr objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView * shadowView=[self.view viewWithTag:301];
    shadowView.hidden=YES;
    _typeTabView.hidden=YES;
    
    UILabel * typeLab=(UILabel *)[self.view viewWithTag:50];
    typeLab.text=[_typeArr objectAtIndex:indexPath.row];
    _typeID=[NSString stringWithFormat:@"%@",[_typeIdArr objectAtIndex:indexPath.row]];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:77.0/255.0 blue:110.0/255.0 alpha:1];
    UILabel * lab=[[UILabel alloc] initWithFrame:view.frame];
    lab.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:77.0/255.0 blue:110.0/255.0 alpha:1];
    lab.text=@"选择帖子类型";
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
#pragma mark-输入框代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _bigScrollView.contentSize=CGSizeMake(SCREEN_WIDTH,340+253);
}
-(void)textViewDidChange:(UITextView *)textView
{
    UILabel * placeHoderLab=(UILabel *)[_bigScrollView viewWithTag:80];
    
    if (textView.text.length == 0)
    {
        placeHoderLab.text =@"请填写帖子内容";
    }
    else
    {
        placeHoderLab.text = @"";

    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    _bigScrollView.contentSize=CGSizeMake(SCREEN_WIDTH,340);
}

#pragma mark-textField代理方法

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 340+253);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width,340);
}

#pragma mark-发请求 发布
-(void)fbBtnClick
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
    
    if ([_topicTextField.text isEqualToString:@""]||[_contentTextView.text isEqualToString:@""])
    {
        NSString * str=@"发布标题及内容不能为空！";
        [JTAlertViewAnimation startAnimation:str view:self.view];
        return;
    }
    else if ([_typeID isEqualToString:@""])
    {
        NSString * str=@"请选择帖子类型！";
        [JTAlertViewAnimation startAnimation:str view:self.view];
        return;
    }
    NSArray * picArr=[[NSArray alloc] initWithObjects:self.headImgData1,self.headImgData2,self.headImgData3,self.headImgData4, nil];

    JTAppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
     
    if ([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_typeID,@"type",[NSString stringWithFormat:@"%d",appdelegate.appUser.userID],@"userId",_topicTextField.text,@"title",_contentTextView.text,@"content",picArr,@"topicPic", nil];
        
        NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Luntan_SaveTopicAdd] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"发布成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
        
    }
    
    for (int i=1; i<5; i++)
    {
        NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"currentImage%d.png",i]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            //从沙盒中删除该文件
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
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
