//
//  BianjiViewController.m
//  FindPlace
//
//  Created by zuo jianjun on 11-11-29.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import "BianjiViewController.h"
#import "ShoucangViewController.h"
#import "DingweiViewController.h"
#import "PlaceMark.h"
#import "TianjiaViewController.h"
#import "JSON.h"
#import "PlaceMessage.h"
#import "JiexiDitie.h"
@implementation BianjiViewController
@synthesize bianjiButton,dicMessage,delegate,cankaolat,cankaolon;
@synthesize myTableView,nameString,messageString,canzhaoString,fujiaString,lat,lon;
@synthesize placenName,canzhaoName,placeID,xinxiField,xinxiStr,imagedata,fujiaxinxi,aLabel;
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
//- (void)viewWillDisappear:(BOOL)animated
//{
//	[super viewWillDisappear:animated];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"收藏信息编辑页面"
                                         withError:&error]) {
        NSLog(@"error in trackPageview");
    }
    
    // Do any additional setup after loading the view from its nib.
    UIColor * aColor  = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"木纹背景.png"]];
    self.view.backgroundColor = aColor;
    [aColor release];
    
//    self.myTableView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    
    bianji = YES;
    tuisong = YES;
    JiexiDitie * ditie = [[JiexiDitie alloc] init];
    tianjia = [[TianjiaViewController alloc] init];
    self.delegate = tianjia;
    ditie.delegate = tianjia;
    tianjia.delegate = self;
    tianjia.placelat = lat;
    tianjia.placelon = lon;
    
    NSNumber * latNum = [[NSNumber alloc] initWithFloat:lat-0.0016];
    NSNumber * lonNum = [[NSNumber alloc] initWithFloat:lon-0.0062];
    aData = [[[NSMutableData alloc] init] retain];
//街旁附近接口
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.jiepang.com/v1/locations/search?lat=%@&lon=%@&source=100000&count=50",latNum,lonNum]];
    NSURLRequest * aRequest = [NSURLRequest requestWithURL:url];
	[NSURLConnection connectionWithRequest:aRequest delegate:self];
    
//街旁地铁接口
    NSString *postString =[NSString stringWithFormat:@"act=jiepang&dev=ios&ver=1.0&long=%@&lat=%@",lonNum,latNum];    
    NSURL *url1 = [NSURL URLWithString:@"http://www.hylinkad.com/mirror/map/map.php"];    
    [ditie getDitieUrl:url1 post:postString];
    [latNum release];
    [lonNum release];
    
    //放置隐藏键盘的按钮
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,480,320,44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem * hiddenButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jianpan.png"] style:UIBarButtonItemStylePlain target:self action:@selector(HiddenKeyBoard)];
    UIBarButtonItem * spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar.items = [NSArray arrayWithObjects:spaceButtonItem,hiddenButtonItem,nil];
    [self.view addSubview:toolBar];
    [toolBar release];
    //监控键盘
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardDidShowNotification object:nil];
    //监控键盘消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWillHide:(NSNotification*)notification{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [xinxiField setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    toolBar.frame = CGRectMake(0, 480, 320, 44);
    [UIView commitAnimations];

}
-(void) HiddenKeyBoard
{
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.3];
    [xinxiField resignFirstResponder];
    [fujiaField resignFirstResponder];
    [aLabel resignFirstResponder];
    self.myTableView.frame = CGRectMake(16, 70, 287, 277);
    toolBar.frame = CGRectMake(0, 480, 320, 44);
    [UIView commitAnimations];
}
-(void)keyboardWillShow:(NSNotification*)notification{
    
    NSDictionary*info=[notification userInfo];
    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    toolBar.frame = CGRectMake(0, 460-kbSize.height-44, 320, 44);
    [UIView commitAnimations];
}

//解析代理
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[aData appendData:data];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString * jsonStr = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
    self.dicMessage = [jsonStr JSONValue];
   
    [delegate chuanshuzua:(NSArray *)[self.dicMessage objectForKey:@"items"]];
       [aData release];
}
#pragma mark -UITableViewDataSource UITableViewDelegate
//分行数
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
//cell重用
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier0 = @"Cell0";
    static NSString *CellIdentifier1 = @"Cell1";
    static NSString *CellIdentifier2 = @"Cell2";
    static NSString *CellIdentifier3 = @"Cell3";
    UITableViewCell *cell ;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier0] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for (UIView * aView in [cell.contentView subviews]) {
            [aView removeFromSuperview];
        }
        aLabel = [[UITextField alloc] initWithFrame:CGRectMake(10, 8, 216, 25)];
        aLabel.backgroundColor = [UIColor clearColor];
        aLabel.textColor = [UIColor grayColor];
        aLabel.font = [UIFont systemFontOfSize:20];
        aLabel.text = self.nameString;
        aLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        aLabel.delegate = self;
        aLabel.returnKeyType = UIReturnKeyDone;
        [cell.contentView addSubview:aLabel];
        return cell;
    }
    else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for (UIView * aView in [cell.contentView subviews]) {
            [aView removeFromSuperview];
        }
        UIImageView * lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 287, 1)];
        if (!self.aLabel.text) {
            lineImageView.image=[UIImage imageNamed:@""];
        }else
        {
            lineImageView.image = [UIImage imageNamed:@"虚线.png"];
        }        [cell.contentView addSubview:lineImageView];
        [lineImageView release];
        
        MKMapView * mapView = [[MKMapView alloc] initWithFrame:CGRectMake(2, 2, 262, 58+24)];
        UIView * map = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 266, 86)];
        map.backgroundColor = [UIColor colorWithRed:89/255.0 green:141/255.0 blue:93/255.0 alpha:1.0];
        [map addSubview:mapView];
        CLLocationCoordinate2D mark2D;
		mark2D.latitude = lat;
		mark2D.longitude = lon;
		PlaceMark * mark = [[PlaceMark alloc]initWithCoords:mark2D];
		[mapView addAnnotation:mark];
        [mark release];
        MKCoordinateSpan theSpan; 
        //地图的范围 越小越精确 
        theSpan.latitudeDelta= 0.005f; 
        theSpan.longitudeDelta=0.005f;         
        MKCoordinateRegion theRegion; 
        CLLocationCoordinate2D cr  = mark.coordinate;
        theRegion.center = cr;  
        theRegion.span = theSpan; 
        [mapView setRegion:theRegion];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 108, 16, 25)];
        image.image = [UIImage imageNamed:@"位置.png"];
        xinxiField = [[UITextView alloc] initWithFrame:CGRectMake(36, 90, 225+14, 65)];
        //[xinxiField setContentOffset:CGPointMake(0.0,0.0) animated:YES];
        xinxiField.text = [NSString stringWithFormat:@"%@",self.messageString];//dizhi
        xinxiField.backgroundColor = [UIColor clearColor];
        xinxiField.textColor = [UIColor grayColor];
        xinxiField.font = [UIFont systemFontOfSize:15.0];
        //[xinxiField setFont:[UIFont fontWithName:@"Thonburi-Bold" size:16.0]];
        xinxiField.delegate = self;
        xinxiField.bounces = NO;
        [cell.contentView addSubview:map];
        [cell.contentView addSubview:image];
        [cell.contentView addSubview:xinxiField];
        [xinxiField release];
        [map release];
        [aLable release];
        [image release];
        [mapView release];
        return cell;
    }
    else if (indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        for (UIView * aView in [cell.contentView subviews]) {
            [aView removeFromSuperview];
        }
        UIImageView * lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 287, 1)];
        lineImageView.image = [UIImage imageNamed:@"虚线.png"];
        [cell.contentView addSubview:lineImageView];
        [lineImageView release];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 14, 16)];
        image.image = [UIImage imageNamed:@"店名.png"];
        messageLable = [[UILabel alloc] initWithFrame:CGRectMake(36, 5, 223, 30)];
        messageLable.numberOfLines = 2;
        messageLable.font = [UIFont systemFontOfSize:15.0];
        //[messageLable setFont:[UIFont fontWithName:@"Thonburi-Bold" size:13.0]];
        messageLable.backgroundColor = [UIColor clearColor];
        messageLable.text = self.canzhaoString;//canzhangdizhi
        messageLable.textColor = [UIColor grayColor];
        [cell.contentView addSubview:messageLable];
        [cell.contentView addSubview:image];
        [image release];
        return cell;
    }
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    for (UIView * aView in [cell.contentView subviews]) {
        [aView removeFromSuperview];
    }
    UIImageView * lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 287, 1)];
    lineImageView.image = [UIImage imageNamed:@"虚线.png"];
    [cell.contentView addSubview:lineImageView];
    [lineImageView release];
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 14, 16)];
    image.image = [UIImage imageNamed:@"地址.png"];
    fujiaField = [[UITextField alloc] initWithFrame:CGRectMake(36, 5, 223, 30)];
    fujiaField.backgroundColor = [UIColor clearColor];
    fujiaField.text = self.fujiaxinxi;
    fujiaField.textColor = [UIColor grayColor];
    fujiaField.font = [UIFont systemFontOfSize:15.0];
    //[fujiaField setFont:[UIFont fontWithName:@"Thonburi-Bold" size:13.0]];   
    fujiaField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    fujiaField.delegate = self;
    fujiaField.returnKeyType = UIReturnKeyDone;
    [cell.contentView addSubview:fujiaField];
    [cell.contentView addSubview:image];
    [image release];
    [fujiaField release];
    return cell;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40;
    }
    else if (indexPath.row == 1) {
        return 160;
    }
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        //        tianjia.messArray = [self.dicMessage objectForKey:@"items"];
        if (bianji == YES) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"不在编辑状态" message:@"请选择编辑按钮" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
        else{
            [self.navigationController pushViewController:tianjia animated:YES]; 
        }
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    if ([fujiaField.text isEqualToString:@"添加附加信息"]) {
//        fujiaField.text = @"";
//    }
    if (bianji == YES) {
        [aLabel resignFirstResponder];
        [fujiaField resignFirstResponder];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"不在编辑状态" message:@"请选择编辑按钮" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 100;
        [alertView show];
        [alertView release];
        return NO;
    }
    else{
        if ([textField.text isEqualToString:@"添加附加信息"]) {
            fujiaField.clearsOnBeginEditing = YES;
        }else{
            
        }
        if (fujiaField == textField) {
            self.myTableView.frame = CGRectMake(16, -70, 287, 277);
        }
        return YES;
    }
}
//UIAlertView的代理方法   确定保存的按钮
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        [aLabel resignFirstResponder];
        [fujiaField resignFirstResponder];
    }
    else if (alertView.tag == 101)
    {
        [xinxiField resignFirstResponder];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    aLable.text = [NSString stringWithFormat:@"%@,%@",self.messageString,fujiaField.text];
    self.myTableView.frame = CGRectMake(16, 70, 287, 277);
    toolBar.frame = CGRectMake(0, 480, 320, 44);
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (bianji == YES){
        [xinxiField resignFirstResponder];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"不在编辑状态" message:@"请选择编辑按钮" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 101;
        [alertView show];
        [alertView release];
        return NO;
    }
    else{
        NSTimeInterval animationDuration=0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        //        self.view.center = CGPointMake(x,y)
        float width=self.myTableView.frame.size.width;
        float height=self.myTableView.frame.size.height;
        CGRect rect=CGRectMake(16,1,width,height);//上移80个单位，按实际情况设置
        self.myTableView.frame=rect;
        [UIView commitAnimations];
        //self.myTableView.frame = CGRectMake(16, 70, 287, 277);
        return YES;
    }
    [textView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    self.myTableView.frame = CGRectMake(16, 70, 287, 277);
    toolBar.frame = CGRectMake(0, 480, 320, 44);
    return YES;
}

-(void) dailiChuanMessing:(NSString *)messing Cankaoname:(NSString *)thecankaoName andCankaomess:(NSString *)thecankaoMess andCankaolat:(float)thecankaoLat andCankaolon:(float)thecankaoLon
{
    messageLable.text = messing;
    cankaolat = thecankaoLat;
    cankaolon = thecankaoLon;
    canzhaoName = thecankaoName;
    canzhaoString = thecankaoMess;
}
- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [self setBianjiButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [myTableView release];
    [bianjiButton release];
    [super dealloc];
}
//发送按钮
- (IBAction)fasongButton:(id)sender {
}
//编辑按钮
- (IBAction)bianjiButton:(id)sender {
    if (bianji == YES) {
        [bianjiButton setBackgroundImage:[UIImage imageNamed:@"保存--一般.png"] forState:UIControlStateNormal];
        aLabel.textColor = [UIColor blackColor];
        xinxiField.textColor = [UIColor blackColor];
        fujiaField.textColor = [UIColor blackColor];
        messageLable.textColor = [UIColor blackColor];
        bianji = NO;
    }
    else{
        [bianjiButton setBackgroundImage:[UIImage imageNamed:@"编辑-一般.png"] forState:UIControlStateNormal];
        aLabel.textColor = [UIColor grayColor];
        xinxiField.textColor = [UIColor grayColor];
        fujiaField.textColor = [UIColor grayColor];
        messageLable.textColor = [UIColor grayColor];
//修改数据库中的值      
        if (self.canzhaoName == NULL) {
            self.canzhaoName = @"";
        }else{}
        if (messageLable.text == NULL) {
            messageLable.text = @"";
        }else{}
        
        [PlaceMessage updatetplaceName:placenName andplaceLat:[[[NSNumber alloc] initWithFloat:lat] doubleValue] andplaceLon:[[[NSNumber alloc] initWithFloat:lon] doubleValue] andcankaoName:canzhaoName andcankaoLat:[[[NSNumber alloc] initWithFloat:cankaolat] doubleValue] andcankaoLon:[[[NSNumber alloc] initWithFloat:cankaolon] doubleValue] andplaceMess:xinxiField.text andcankaoMess:messageLable.text andbaocunName:self.aLabel.text andimageData:imagedata andfujiaXinxi:fujiaField.text fromID:placeID];
        bianji = YES;
    }
}
//返回按钮
- (IBAction)backButton:(id)sender {
        [self.navigationController popViewControllerAnimated:YES];
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//添加按钮
- (IBAction)tianjiaButton:(id)sender {
    DingweiViewController * dingwei = [[DingweiViewController alloc] init];
    [self.navigationController pushViewController:dingwei animated:YES];
   
    [dingwei release];
}
//列表按钮
- (IBAction)liebiaoButton:(id)sender {
    ShoucangViewController * shoucangView = [[ShoucangViewController alloc] init];
    [self.navigationController pushViewController:shoucangView animated:YES];
}
#pragma mark-发送短信
//发短信按钮
- (IBAction)showSMSPicker:(id)sender {
    NSString *postString =[NSString stringWithFormat:@"act=position&dev=ios&ver=1.1&p_long=%@&p_lat=%@&p_add=%@&net=wifi&op=00&r_long=%@&r_lat=%@&r_add=%@",[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lat],aLable.text,[[NSNumber alloc] initWithFloat:self.cankaolon],[[NSNumber alloc] initWithFloat:self.cankaolat],self.canzhaoString];    
    NSURL *url = [NSURL URLWithString:@"http://www.hylinkad.com/mirror/map/map.php"];    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];    
    [req setHTTPMethod:@"POST"]; 
    [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];   
//    NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];  
//    if (conn) {    
////                   NSMutableData * webData = [[NSMutableData data] retain];    
//            } 

    //  The MFMessageComposeViewController class is only available in iPhone OS 4.0 or later.   
    //  So, we must verify the existence of the above class and log an error message for devices   
    //      running earlier versions of the iPhone OS. Set feedbackMsg if device doesn't support   
    //      MFMessageComposeViewController API.   
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));   
    if (messageClass != nil) {   
        // Check whether the current device is configured for sending SMS messages   
        if ([messageClass canSendText]) {   
          
            [self displaySMSComposerSheet]; 
//ibokan.gicp.net/ibokan/map/map.php?act=position&p_long=23&p_lat=40&p_add=海淀区左岸公社&net=wifi&op=00&r_long=34&r_lat=43&r_add=海淀区永定路&dev=android
                    }   
        else {   
           
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本设备没有短信功能，您不能发送信息！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"关闭", nil];
            [alertView show];
            [alertView release];

            //            [self.view addSubview:alertView];
        }   
    }   
    else {   
      
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"iOS版本过低,iOS4.0以上才支持程序内发送短信！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"关闭", nil];
        [alertView show];
        [alertView release];   
    }  
}
//发送的内容
-(void)displaySMSComposerSheet   
{   
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];   
    picker.messageComposeDelegate = self;   
    
    //    NSMutableString* absUrl = [[NSMutableString alloc] initWithString:@"aaaaaaa"];   
    //    [absUrl replaceOccurrencesOfString:@"http://i.aizheke.com" withString:@"http://m.aizheke.com" 
    //                               options:NSCaseInsensitiveSearch range:NSMakeRange(0, [absUrl length])];   
    //    
    if ([messageLable.text isEqualToString:@""]) {
        if ([fujiaField.text isEqualToString:@"添加附加信息"]) {
            picker.body=[NSString stringWithFormat:@"我在%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        }else if([fujiaField.text isEqualToString:@""])
        {
            picker.body=[NSString stringWithFormat:@"我在%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        }
        else{
            picker.body=[NSString stringWithFormat:@"我在%@,%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,fujiaField.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        }
    }else if([messageLable.text isEqualToString:@"添加附加信息"])
    {
        if ([fujiaField.text isEqualToString:@"添加附加信息"]) {
            picker.body=[NSString stringWithFormat:@"我在%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        }else if([fujiaField.text isEqualToString:@""])
        {
            picker.body=[NSString stringWithFormat:@"我在%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        }
        else{
            picker.body=[NSString stringWithFormat:@"我在%@,%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,fujiaField.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        }

    }
    else
    {
        if ([fujiaField.text isEqualToString:@"添加附加信息"]) {
            picker.body=[NSString stringWithFormat:@"我在%@【%@】。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,messageLable.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        }else if([fujiaField.text isEqualToString:@""])
        {
            picker.body=[NSString stringWithFormat:@"我在%@【%@】。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,messageLable.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        }
        else{
            picker.body=[NSString stringWithFormat:@"我在%@【%@】,%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,messageLable.text,fujiaField.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        }
        
    }
   
    //    [absUrl release];   
    [self presentModalViewController:picker animated:YES];   
    [picker release];   
}   
//短信的代理 MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller   
                 didFinishWithResult:(MessageComposeResult)result {   
    
        switch (result)   
        {   
            case MessageComposeResultCancelled:   
                //LOG_EXPR(@"Result: SMS sending canceled");   
                break;   
            case MessageComposeResultSent:   
                //LOG_EXPR(@"Result: SMS sent"); 
                
                break;   
            case MessageComposeResultFailed:   
                //[UIAlertView quickAlertWithTitle:@"短信发送失败" messageTitle:nil dismissTitle:@"关闭"]; 
                
                break;   
            default:   
               // LOG_EXPR(@"Result: SMS not sent");   
                break;   
        }   
       [self dismissModalViewControllerAnimated:YES];
}  
@end
