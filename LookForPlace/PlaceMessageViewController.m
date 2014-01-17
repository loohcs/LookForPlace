//
//  PlaceMessageViewController.m
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-2.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import "PlaceMessageViewController.h"
#import "TianjiaViewController.h"
#import "JSON.h"
#import "PlaceMessage.h"
#import "BianjiViewController.h"
#import "PlaceMark.h"
#import "JiexiDitie.h"
@implementation PlaceMessageViewController

@synthesize bacunButton;

@synthesize myTableView,messageDic,messageLable,nameField,lat,lon,dicMessage,nameMess,delegate;
@synthesize cankaolat,cankaolon,nameView,imageData,toolBar,fujiaxinxi;
@synthesize placename,cankaoname,cankaomess,placemess,baocunname,xinxiField;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    self.nameField.inputAccessoryView=NO;
//    
//}
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
   // height=68;
    // Do any additional setup after loading the view from its nib.
    baocun = YES;
    NSLog(@"中：：： %@",self.navigationController.tabBarItem.image);
    //self.myTableView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    
    UIColor * aColor  = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"木纹背景.png"]];
    self.view.backgroundColor = aColor;
    [aColor release];

    JiexiDitie * ditie = [[JiexiDitie alloc] init];
    tianjia = [[TianjiaViewController alloc] init];
    ditie.delegate = tianjia;
    self.delegate = tianjia;
    tianjia.delegate = self;
    tianjia.placelat = lat;
    tianjia.placelon = lon;
  
    
    NSNumber * latNum = [[NSNumber alloc] initWithFloat:lat-0.0016];
    NSNumber * lonNum = [[NSNumber alloc] initWithFloat:lon-0.0062];
    aData = [[NSMutableData alloc] init];
//街旁附近接口  提前解析参照物的数据  
     NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.jiepang.com/v1/locations/search?lat=%@&lon=%@&source=100000&count=50",latNum,lonNum]];
    NSURLRequest * aRequest = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
	fujinconn = [NSURLConnection connectionWithRequest:aRequest delegate:self];
    if (fujinconn) {
        aData = [[NSMutableData alloc] init];
    }
//街旁地铁接口的解析  用JiexiDitie类取解析  用代理传回
    NSString *postString =[NSString stringWithFormat:@"act=jiepang&dev=ios&ver=1.0&long=%@&lat=%@",lonNum,latNum];    
    NSURL *url1 = [NSURL URLWithString:@"http://www.hylinkad.com/mirror/map/map.php"];    
    [ditie getDitieUrl:url1 post:postString];
    [latNum release];
    [lonNum release];
    
//放置隐藏键盘的按钮
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,480,320,44)];
    self.toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem * hiddenButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jianpan.png"] style:UIBarButtonItemStylePlain target:self action:@selector(HiddenKeyBoard)];
    UIBarButtonItem * spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolBar.items = [NSArray arrayWithObjects:spaceButtonItem,hiddenButtonItem,nil];
    [self.view addSubview:self.toolBar];
//    [self.toolBar release];
    
    //self.nameField.inputAccessoryView=NO;
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
    [UIView commitAnimations];}

-(void) HiddenKeyBoard
{
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.3];
    [xinxiField resignFirstResponder];
    [fujiaField resignFirstResponder];
    [nameView resignFirstResponder];
    self.myTableView.frame = CGRectMake(16, 70, 287, 277);
    self.toolBar.frame = CGRectMake(0, 480, 320, 44);
    [UIView commitAnimations];
}
-(void)keyboardWillShow:(NSNotification*)notification{
   
    NSDictionary*info=[notification userInfo];
    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.toolBar.frame = CGRectMake(0, 460-kbSize.height-44, 320, 44);
    [UIView commitAnimations];
}

#pragma mark - 解析附近建筑物的代理方法
//解析代理
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (fujinconn == connection) {
        [aData appendData:data];
    }
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSDictionary * Message;
    if (fujinconn == connection) {
        NSString * jsonStr = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
        self.dicMessage = [jsonStr JSONValue];
        [delegate chuanshuzu:(NSArray *)[self.dicMessage objectForKey:@"items"]];
        [aData release];
    }
}

#pragma mark  -  tableview的代理方法
//分行
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (!self.nameField.text) {
            return 0;
        }
        else{
        return 40;
        }
    }
    if (indexPath.row == 1) {
        return 160;
    }
    return 40;
}
//行重用
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier0 = @"Cell0";
    static NSString *CellIdentifier1 = @"Cell1";
    static NSString *CellIdentifier2 = @"Cell2";
    static NSString *CellIdentifier3 = @"Cell3";
    UITableViewCell *cell ;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier0];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier0] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        for (UIView * aView in [cell.contentView subviews]) {
            [aView removeFromSuperview];
        }
        nameView = [[UITextField alloc] initWithFrame:CGRectMake(10, 8, 216, 25)];
        nameView.backgroundColor = [UIColor clearColor];
        nameView.font = [UIFont systemFontOfSize:20];
        [nameView setTextColor:[UIColor colorWithRed:0.482 green:0.580 blue:0.392 alpha:1]];
        nameView.text = self.nameField.text;
        if (self.baocunname) {
            nameView.textColor = [UIColor grayColor];
        }
        nameView.delegate = self;
        [cell.contentView addSubview:nameView];
        [nameView release];
        return cell;
    }
   else if (indexPath.row == 1) {
         cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (cell == nil) {
        xinxiField = [[UITextView alloc] initWithFrame:CGRectMake(36, 90, 225+14, 65)];
        //[xinxiField setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        for (UIView * aiew in [cell.contentView subviews]) {
            [aiew removeFromSuperview];
        }
        UIImageView * lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 287, 1)];
       if (!self.nameField.text) {
           lineImageView.image=[UIImage imageNamed:@""];
       }else
       {
           lineImageView.image = [UIImage imageNamed:@"虚线.png"];
       }
        
        [cell.contentView addSubview:lineImageView];
        [lineImageView release];
        mapView = [[MKMapView alloc] initWithFrame:CGRectMake(2, 2, 262, 58+24)];
        UIView * map1 = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 266, 86)];
        map1.backgroundColor = [UIColor colorWithRed:89/255.0 green:141/255.0 blue:93/255.0 alpha:1.0];
        [map1 addSubview:mapView];
        CLLocationCoordinate2D mark2D;
		mark2D.latitude = lat;
		mark2D.longitude = lon;
		PlaceMark * mark = [[PlaceMark alloc]initWithCoords:mark2D];
		[mapView addAnnotation:mark];
        [mark release];
        MKCoordinateSpan theSpan; 
////地图的范围 越小越精确 
        theSpan.latitudeDelta= 0.005f; 
        theSpan.longitudeDelta=0.005f;         
        MKCoordinateRegion theRegion; 
        CLLocationCoordinate2D cr = mark.coordinate;
        theRegion.center = cr;  
        theRegion.span = theSpan; 
        [mapView setRegion:theRegion];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 108, 16, 25)];
        image.image = [UIImage imageNamed:@"位置.png"];
        //xinxiField = [[UITextView alloc] initWithFrame:CGRectMake(36, 96, 225+14, 68)];
        
       if (self.baocunname) {
           xinxiField.textColor = [UIColor grayColor];
           xinxiField.text = self.placemess;
       }
       else
       {
        
          
           NSRange range=[self.nameMess rangeOfString:@"邮政编码"];
           if (range.length==0) {
//               NSLog(@"self.placename=%@",self.placename);
//               NSLog(@"self.namemess=%@",self.nameMess);
              // NSString * str1 = [[NSString alloc] initWithFormat:@"%@",self.placename];
              // NSString * str2 = [[NSString alloc] initWithFormat:@"%@",self.nameMess];
               
               //NSString * str = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",@"aaaa",str2,@"hhhhh",str1,@"sssss"];
               //NSLog(@"self.placename=%p",self.placename);
//               int length=[self.placename length];
//               for (float i=0; i<length; i++) {
//                   // NSString * c=[mytimestr characterAtIndex:i];
//                   NSString *STR  = [self.placename substringWithRange:NSMakeRange( i, 1)] ;
//                   NSLog(@"%@",STR);
//               }
//               NSLog(@"self.namemess=%p",self.nameMess);

              // NSLog(@"str = %@",str);
               //NSString*stringname=[NSString stringWithFormat:@"%@\n%@",self.placename,self.nameMess];
              // NSLog(@"stringname=%@",stringname);
               //xinxiField.text=stringname;
              xinxiField.text = [NSString stringWithFormat:@"%@\n%@",self.placename,self.nameMess];
//               NSString *string1=self.placename;
//               NSString *string2=self.nameMess;
//               NSLog(@"sting1=%@",string1);
//                NSLog(@"sting2=%@",string2);
//             NSString*  string = [string1 stringByAppendingString:string2];
//               xinxiField.text=string;
               NSLog(@"xinxifield=%@",self.xinxiField.text);
           }else {
               NSString *string1=[self.nameMess substringToIndex:range.location-1];
               xinxiField.text = [NSString stringWithFormat:@"%@\n%@",self.placename,string1];
           }
           
           
       }
       [xinxiField setContentOffset:CGPointMake(0.0, 0.0) animated:YES];

        xinxiField.delegate = self;
        xinxiField.bounces = NO;
//        xinxiField.returnKeyType = UIReturnKeyDone;
        xinxiField.backgroundColor = [UIColor clearColor];
        xinxiField.font = [UIFont systemFontOfSize:15.0];
              //[xinxiField setFont:[UIFont fontWithName:@"Thonburi-Bold" size:15.0]];
//        xinxiField.delegate = self;
        [cell.contentView addSubview:map1];
        [cell.contentView addSubview:image];
        [cell.contentView addSubview:xinxiField];
        [map1 release];
        //[xinxiField release];
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
        messageLable.backgroundColor = [UIColor clearColor];
        messageLable.font = [UIFont systemFontOfSize:15.0];
        //[messageLable setFont:[UIFont fontWithName:@"Thonburi-Bold" size:15.0]];
        if (self.baocunname) {
            messageLable.textColor = [UIColor grayColor];
            messageLable.text = self.cankaomess;
        }
        else
        {   
            messageLable.text = @"添加参照物";//参考的位置
        }
        
        messageLable.numberOfLines = 2;
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
    fujiaField.font = [UIFont systemFontOfSize:15.0];
    //[fujiaField setFont:[UIFont fontWithName:@"Thonburi-Bold" size:15.0]];
    if (self.baocunname) {
        fujiaField.textColor = [UIColor grayColor];
        fujiaField.text = self.fujiaxinxi;
    }
    else
    {
    fujiaField.text = @"添加附加信息";//附加的信息
    }
    fujiaField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    fujiaField.clearsOnBeginEditing = YES;
    fujiaField.delegate = self;
    fujiaField.returnKeyType = UIReturnKeyDone;
    [cell.contentView addSubview:fujiaField];
    [cell.contentView addSubview:image];
    [image release];
    [fujiaField release];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (baocun == YES) {
        if (indexPath.row == 2) {
           // aViewC=[[UIViewController alloc] init];
            [self.navigationController pushViewController:tianjia animated:YES];
        }
       // baocun=NO;
    }
    else
    {
       UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"不在编辑状态" message:@"请选择编辑按钮" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
       // baocun=YES;
    }
}

#pragma mark  -  传参考信息的代理方法
-(void) dailiChuanMessing:(NSString *)messing Cankaoname:(NSString *)thecankaoName andCankaomess:(NSString *)thecankaoMess andCankaolat:(float)thecankaoLat andCankaolon:(float)thecankaoLon
{
    self.messageLable.text = messing;
    cankaolat = thecankaoLat;
    cankaolon = thecankaoLon;
    cankaoname = thecankaoName;
    cankaomess = thecankaoMess;
}

#pragma mark-UITextFieldDelegate 文本框的代理方法

//附加信息的填写
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (baocun == NO) {
        [nameView resignFirstResponder];
        [fujiaField resignFirstResponder];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"不在编辑状态" message:@"请选择编辑按钮" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        //baocun=YES;
        return NO;
    }
    else
    {
        if (fujiaField == textField) {
            if ([fujiaField.text isEqualToString:@"添加附加信息"]) {
                fujiaField.text = @"";//附加的信息
            }
            self.myTableView.frame = CGRectMake(16, -70, 287, 277);
        }
       // baocun=NO;
        return YES;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (fujiaField == textField) {
        self.myTableView.frame = CGRectMake(16, 70, 287, 277);
        self.toolBar.frame = CGRectMake(0, 480, 320, 44);
    }
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (fujiaField == textField) {
        self.fujiaxinxi = fujiaField.text;
    }
    [textField resignFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
     [textView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
       if (baocun == NO) {
        [xinxiField resignFirstResponder];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"不在编辑状态" message:@"请选择编辑按钮" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        // baocun=YES;
        return NO;
       
    }
    else
    {
        NSTimeInterval animationDuration=0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
//        self.view.center = CGPointMake(x,y)
        float width=self.myTableView.frame.size.width;
        float height=self.myTableView.frame.size.height;
        CGRect rect=CGRectMake(16,1,width,height);//上移80个单位，按实际情况设置
        self.myTableView.frame=rect;
        [UIView commitAnimations];
        
        //baocun=NO;
        return YES;
    }
   
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
   
    return YES;
}
- (void)viewDidUnload
{
    [self setMyTableView:nil];
    
    [self setBacunButton:nil];
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
   
    //[aViewC release];
    [myTableView release];
    [messageLable release];
    [nameField release];
//    [cankaoname release];
//    [placemess release];
//    [cankaomess release];

    [bacunButton release];
    [super dealloc];
}

#pragma mark - 返回按钮、保存按钮
-(void)selectIndex:(NSUInteger)sender
{
    selectindex=sender;
}
//返回按钮
- (IBAction)goBack:(id)sender {
   
    //self.tabBarController.selectedIndex=selectindex;
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [self.navigationController popViewControllerAnimated:NO];
//    //[self.aViewC.navigationController pushViewController:<#(UIViewController *)#> animated:<#(BOOL)#>];
//}
//截图片的方法
-(UIImage*)captureView:(UIView *)theView
{
    CGRect rect = theView.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect rect1 = CGRectMake(90, 0, 82, 82);//创建矩形框 
    UIImage * im = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([img CGImage], rect1)]; 
    return im;
}
//存图片到沙盒路径
-(void) cunTupian:(UIImage *)image mingzi:(NSString *) mz
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",mz]];   // 保存文件的名称
       self.imageData = filePath;
    BOOL result = [UIImagePNGRepresentation(image)writeToFile: filePath atomically:YES]; 
    NSLog(@"result = %d",result);
   
}

//保存按钮 保存当前的信息
- (IBAction)pushMingziView:(id)sender {
    if (baocun == YES) {
        if (!self.baocunname) {
             blertView = [[UIAlertView alloc] initWithTitle:@"输入地址名称：如公司" message:@" " delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            //[alertView setFrame:CGRectMake(200, 80, 280, 250)];
            nameField = [[UITextField alloc] initWithFrame:CGRectMake(12, 42, 260, 35)]; 
            //[nameField becomeFirstResponder];
            nameField.backgroundColor = [UIColor whiteColor]; 
            [blertView addSubview:nameField];
            [blertView setTag:100];
            [blertView show];
            //[blertView release];
            
        }
        else
        {
            int a = 0;
            for (PlaceMessage * place in [PlaceMessage findAll]) {
                if (a < place.ID) {
                    a = place.ID;
                }
            }
            //NSLog(@"self.placemess=%@",self.placemess);
            self.baocunname = self.nameView.text;
            [PlaceMessage updatetplaceName:self.placename andplaceLat:[[[NSNumber alloc] initWithFloat:self.lat] doubleValue] andplaceLon:[[[NSNumber alloc] initWithFloat:self.lon] doubleValue] andcankaoName:self.cankaoname andcankaoLat:[[[NSNumber alloc] initWithFloat:self.cankaolat] doubleValue]  andcankaoLon:[[[NSNumber alloc] initWithFloat:self.cankaolon] doubleValue] andplaceMess:self.placemess andcankaoMess:self.cankaomess andbaocunName:self.baocunname andimageData:self.imageData andfujiaXinxi:fujiaField.text fromID:a];
            nameView.textColor = [UIColor grayColor];
            xinxiField.textColor = [UIColor grayColor];
            fujiaField.textColor = [UIColor grayColor];
            messageLable.textColor = [UIColor grayColor];
            
            NSError *error;
            if (![[GANTracker sharedTracker] trackPageview:@"保存之后的页面"
                                                 withError:&error]) {
                NSLog(@"error in trackPageview");
            }
            
        }
        baocun = NO;
        [self.bacunButton setBackgroundImage:[UIImage imageNamed:@"编辑-一般.png"] forState:UIControlStateNormal];
    }
    else
    {
        nameView.textColor = [UIColor blackColor];
        xinxiField.textColor = [UIColor blackColor];
        fujiaField.textColor = [UIColor blackColor];
        messageLable.textColor = [UIColor blackColor];
        baocun = YES;
        [self.bacunButton setBackgroundImage:[UIImage imageNamed:@"保存--一般.png"] forState:UIControlStateNormal];
    }
}
//改变alerview得大小得方法
-(void)willPresentAlertView:(UIAlertView *)alertView
{
    [blertView setFrame:CGRectMake(20, 150, 280, 160)];
    [blertView release]; 
}


#pragma mark - UIAlertView的代理方法
//UIAlertView的代理方法   确定保存的按钮 保存到数据库
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==101)
    {
        if (buttonIndex==0) {
             [self pushMingziView:nil];
        }
    }
    self.toolBar.frame = CGRectMake(0, 480, 320, 44);
    self.nameField.inputAccessoryView=NO;
    [nameField resignFirstResponder];
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            if (self.nameField.text ==NULL) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"您还没输入名字！" message:@" " delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                [alertView release];
                
            }   
            else{
//往编辑页传数据
                //NSLog(@"self.messagelable.text=%@",xinxiField.text);
                BianjiViewController * bianjiView = [[BianjiViewController alloc] init];
                bianjiView.nameString = self.nameField.text;//baocunname
                bianjiView.canzhaoString = self.messageLable.text;
                bianjiView.messageString = self.xinxiField.text;
                
                bianjiView.lat = self.lat;
                bianjiView.lon = self.lon;
                bianjiView.cankaolon = self.cankaolon;
                bianjiView.cankaolat = self.cankaolat;
                bianjiView.placenName = self.placename;
                bianjiView.canzhaoName = self.cankaoname;
                self.placemess =self.xinxiField.text;
//向数据库中添加信息
                
               self.baocunname = self.nameField.text;//数据库存baocunname
                        UIImage * aimage = [self captureView:mapView];
               
                if ([PlaceMessage isStudentExistWithName:self.baocunname]==YES) {
                   
                    UIAlertView *aAlertView=[[UIAlertView alloc] initWithTitle:@"名字已存在" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [aAlertView show];
                    [aAlertView release];
                    [self.bacunButton setBackgroundImage:[UIImage imageNamed:@"保存--一般.png"] forState:UIControlStateNormal];
                    baocun=YES; 
                    self.baocunname=nil;

                    
                }else{
                   
                        [self cunTupian:aimage mingzi:self.baocunname];
                        if (self.cankaoname == NULL) {
                            self.cankaoname = @"";
                        }else{}
                        if (self.cankaomess == NULL) {
                            self.cankaomess = @"";
                        }else{
                        }
                    NSLog(@"self.placename = %@",self.placename);
                    NSLog(@",self.nameMess = %@%@",(NSString *)self.placename,(NSString *)self.nameMess);
                        [PlaceMessage addPlaceWhithplaceName:self.placename andplaceLat:[[[NSNumber alloc] initWithFloat:self.lat] doubleValue] andplaceLon:[[[NSNumber alloc] initWithFloat:self.lon] doubleValue] andcankaoName:self.cankaoname andcankaoLat:[[[NSNumber alloc] initWithFloat:self.cankaolat] doubleValue] andcankaoLon:[[[NSNumber alloc] initWithFloat:self.cankaolon] doubleValue] andplaceMess:self.placemess andcankaoMess:self.cankaomess andbaocunName:self.baocunname andimageData:self.imageData andfujiaXinxi:fujiaField.text];
                        [self.myTableView reloadData];
                    
                    NSError *error;
                    if (![[GANTracker sharedTracker] trackPageview:@"保存之后的页面"
                                                         withError:&error]) {
                        NSLog(@"error in trackPageview");
                    }
                    
                }          
                
            } 
        }
        else
        {
            [self.bacunButton setBackgroundImage:[UIImage imageNamed:@"保存--一般.png"] forState:UIControlStateNormal];
            baocun=YES;
        }
    }

    
}
#pragma mark - 发送短信
//发短信按钮
- (IBAction)showSMSPicker:(id)sender {
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"短信编辑页面"
                                         withError:&error]) {
        NSLog(@"error in trackPageview");
    }
    
    //UIViewController *viewC=[[UIViewController alloc] init];
    //[self presentModalViewController:viewC animated:YES];
    
   // NSLog(@"self.placemess=%@",self.placename);
    NSLog(@"Result: SMS sent");
    NSString *postString =[NSString stringWithFormat:@"act=position&dev=ios&ver=1.1&p_long=%@&p_lat=%@&p_add=%@&net=wifi&op=00&r_long=%@&r_lat=%@&r_add=%@",[[NSNumber alloc] initWithFloat:self.lon],[[NSNumber alloc] initWithFloat:self.lat],self.placemess,[[NSNumber alloc] initWithFloat:self.cankaolon],[[NSNumber alloc] initWithFloat:self.cankaolat],self.cankaomess];  
        NSURL *url = [NSURL URLWithString:@"http://www.hylinkad.com/mirror/map/map.php"];    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];       
    [req setHTTPMethod:@"POST"]; 
    [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));   
    if (messageClass != nil) {   
        // Check whether the current device is configured for sending SMS messages   
        if ([messageClass canSendText]) {   
                      
            [self displaySMSComposerSheet];   
        }   
        else {   
           
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本设备没有短信功能，您不能发送信息！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"关闭", nil];
            [alertView show];
            [alertView release];
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
    picker = [[MFMessageComposeViewController alloc] init];   
    picker.delegate = self;
    picker.recipients = [NSArray arrayWithObject:@""];
    picker.messageComposeDelegate = self;   
    self.toolBar.frame = CGRectMake(0, 480, 320, 44);
    //self.toolBar.frame = CGRectMake(0, 460-kbSize.height-44, 320, 44);
    if ([self.messageLable.text isEqualToString:@"添加参照物"]) {
        if ([fujiaField.text isEqualToString:@"添加附加信息"]) {
            NSLog(@"xinxifasong=%@",self.xinxiField.text);
            picker.body=[NSString stringWithFormat:@"我在%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        }else if([fujiaField.text isEqualToString:@""])
        {
         picker.body=[NSString stringWithFormat:@"我在%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        } else if(fujiaField.text==NULL)
        {
            NSLog(@"444");
            picker.body=[NSString stringWithFormat:@"我在%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        }else
       
        {
             picker.body=[NSString stringWithFormat:@"我在%@,%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,fujiaField.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        }
    }else if([self.messageLable.text isEqualToString:@""])
    {
        if ([fujiaField.text isEqualToString:@"添加附加信息"]) {
            NSLog(@"111");
            picker.body=[NSString stringWithFormat:@"我在%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        }else if([fujiaField.text isEqualToString:@""])
        {
            NSLog(@"22");
            picker.body=[NSString stringWithFormat:@"我在%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        }
        else if(fujiaField.text==NULL)
        {
            NSLog(@"444");
             picker.body=[NSString stringWithFormat:@"我在%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        }else
        {
            NSLog(@"333");
            picker.body=[NSString stringWithFormat:@"我在%@,%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,fujiaField.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        }

    }
    else
    {
        if ([fujiaField.text isEqualToString:@"添加附加信息"]) {
            picker.body=[NSString stringWithFormat:@"我在%@【%@】。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,self.messageLable.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        }else if([fujiaField.text isEqualToString:@""])
        {
            picker.body=[NSString stringWithFormat:@"我在%@【%@】。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,self.messageLable.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        }
        else if(fujiaField.text==NULL)
        {
            NSLog(@"444");
            picker.body=[NSString stringWithFormat:@"我在%@【%@】。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,self.messageLable.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];

        }else
        {
        picker.body=[NSString stringWithFormat:@"我在%@【%@】,%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,self.messageLable.text,fujiaField.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
        }
        
    } 
//    [self.navigationController pushViewController:[picker.viewControllers objectAtIndex:0] animated:YES];
    [self presentModalViewController:picker animated:YES];   
    [picker release];   
}   
//短信的代理 MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller   
                 didFinishWithResult:(MessageComposeResult)result {   
    
       switch (result)   
        {   
            case MessageComposeResultCancelled:   
                  NSLog(@"Result: SMS sending canceled"); 
                break;   
            case MessageComposeResultSent:   
                
                
                break;   
            case MessageComposeResultFailed:   
            {
                  NSLog(@"Result: SMS sent");
                UIActionSheet * act = [[UIActionSheet alloc] initWithTitle:
                                       @"短信发送失败!" delegate:self cancelButtonTitle:@"关闭" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                [act showFromTabBar:self.tabBarController.tabBar];
                break;   
            }
            default:   
               NSLog(@"Result: SMS not sent"); 
                break;   
        } 
    NSLog(@"短信中111： %@",self.navigationController.tabBarItem.image);
    [self dismissModalViewControllerAnimated:YES];
    NSLog(@"短信中222： %@",self.navigationController.tabBarItem.image);
    self.nameField.inputAccessoryView=NO;
    

    if (baocun==YES) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否保存本信息！" delegate:self cancelButtonTitle:@"保存" otherButtonTitles:@"不保存", nil];
        [alertView setTag:101];
        [alertView show];
        [alertView release];
//        baocun = NO;
//        [self.bacunButton setBackgroundImage:[UIImage imageNamed:@"编辑-一般.png"] forState:UIControlStateNormal];
        
        NSError *error;
        if (![[GANTracker sharedTracker] trackPageview:@"提示保存信息"
                                             withError:&error]) {
            NSLog(@"error in trackPageview");
        }
    }
    
} 
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self dismissModalViewControllerAnimated:YES];
       // self.navigationController.tabBarController.selectedIndex=1;
    }
}

@end
