//
//  DingweiViewController.m
//  FindPlace
//
//  Created by zuo jianjun on 11-11-29.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import "DingweiViewController.h"
#import "JSON.h"
#import "URLEncode.h"
#import "PlaceMark.h"
#import "PlaceNow.h"
#import "XuanzeButton.h"
//#import "JiexiGuanjianzi.h"
//#import "JiexiFujin.h"
//#import "JiexiNowjiwe.h"
#import "PlaceMessageViewController.h"
#import "AppDelegate.h"
#import "MyDanLi.h"
#import "PlaceData.h"

@implementation DingweiViewController
@synthesize xinxiView,data,tablearray,actiIndicator;
@synthesize myTableView,dictableV;
@synthesize mingziTableView;
@synthesize seachBar,coord,aData,bData;
@synthesize mapView,lat,lon,xuanButton,arrayMessage,toolBar,mark,now,nowmark1,nowmark2;
@synthesize request1;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"发送自选位置页面"
                                         withError:&error]) {
        NSLog(@"error in trackPageview");
    }
    
    
    //传值给发送信息页面的初始值
    selectindex=1;
    
    //给搜索tableview添加风货轮
    UIActivityIndicatorView *activ1=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activ1 setFrame:CGRectMake(130, 140, 50, 50)];

    self.actiIndicator=activ1;
    [activ1 release];
    
    

 
    
    

    //从appdelegate得类里获取当前位置经纬度
    appDelegete = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    lat=appDelegete.location.latitude;
    lon=appDelegete.location.longitude;
   
    MyDanLi *danli = [MyDanLi dingWeiVC];
    danli.lat = lat;
    danli.lon = lon;
    danli.dingwei = self;
    NSLog(@"经纬度lat=%f",lat);
    NSLog(@"经纬度lon＝%f",lon);
//    if (lat==0&&lon==0) {
//        NSLog(@"经纬度为0");
//        locationManager = [[CLLocationManager alloc]init];//初始化位置管理器
//        
//        
//        [locationManager setDelegate:self];
//        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];//设置精度
//        locationManager.distanceFilter = 1000.0f;//设置距离筛选器
//        [locationManager startUpdatingLocation];//启动位置管理器
//        [self performSelector:@selector(Delegatedingwei)];
//    }else{
//        NSLog(@"经纬度不为0");
    //调用该方法，插针，然后解析对应数据
    [self performSelector:@selector(Delegatedingwei)];
    //}
    
    
    [[[seachBar subviews] objectAtIndex:0] removeFromSuperview];

    shousuo = YES;
    
    self.arrayMessage = [[NSMutableArray alloc] init];//附近信息
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    muArray = [[NSMutableArray alloc] init];//存联想字的数组
    self.mingziTableView.delegate = self;
    self.mingziTableView.dataSource = self;
    self.dictableV.delegate=self;
    self.dictableV.dataSource=self;
//在根视图上加载tableview 附近信息
    activ = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(130, 50, 50, 50)];
    activ.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    viewTable = [[UIView alloc] initWithFrame:CGRectMake(0, 411, 320, 180)];
    viewTable.backgroundColor = [UIColor clearColor];
//    [self.myTableView addSubview:activ];
    [viewTable addSubview:self.myTableView];
    [viewTable addSubview:activ];
    [self.view addSubview:viewTable];
    [viewTable release];
    [activ release];
//长按手势 获取经纬度
    UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    lpress.minimumPressDuration = 1.0;//按2秒响应longPress方法
    lpress.allowableMovement = 10.0;
    //给MKMapView加上长按事件
    [self.mapView addGestureRecognizer:lpress];//mapView是MKMapView的实例
    [lpress release];
    //放置隐藏键盘的按钮
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,480,320,44)];
    self.toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem * hiddenButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jianpan.png"] style:UIBarButtonItemStylePlain target:self action:@selector(HiddenKeyBoard)];
    UIBarButtonItem * spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolBar.items = [NSArray arrayWithObjects:spaceButtonItem,hiddenButtonItem,nil];
    [self.view addSubview:self.toolBar];
    [self.toolBar release];
//监控键盘出现
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
//监控键盘消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
//把定位到的经纬度信息传过来    
   
    
}
//- (void)locationManager:(CLLocationManager *)manager
//	didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation;
//{
//    
//    //当前经纬    
//    location = [newLocation coordinate];
//    //插针的经纬  有偏移量 
//    
//    lat = location.latitude;
//    lon = location.longitude;
//    location.latitude = location.latitude+0.0016;
//    location.longitude = location.longitude+0.0062;
//    MKCoordinateSpan theSpan; 
//    theSpan.latitudeDelta= 0.01f; 
//    theSpan.longitudeDelta=0.01f; 
//    theRegion1.center = location; 
//    theRegion1.span = theSpan; 
//    
//    
//}
//解析获取数据当前经纬度下的地址信息
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSMutableData *d = [[NSMutableData alloc] init];
    self.data = d;
    [d release];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)adata
{
    [self.data appendData:adata];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *jsonString = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSDictionary * jsonDic = [jsonString JSONValue]; 
    NSArray * jsonarr = [jsonDic objectForKey:@"Placemark"];
    NSString * name1 = [[[[[[[[jsonarr objectAtIndex:0] objectForKey:@"AddressDetails"] objectForKey:@"Country"] objectForKey:@"AdministrativeArea"] objectForKey:@"Locality"] objectForKey:@"DependentLocality"] objectForKey:@"Thoroughfare"] objectForKey:@"ThoroughfareName"];
    
    if (name1==nil) {
        mark.name=@"暂无此处精确信息 ";
        mark.subtitle1=@"您可以点击“附近”查看附近位置 ";
    }else{
    now.name = name1;
    now.subtitle1 = [[jsonarr objectAtIndex:0] objectForKey:@"address"];
    }
    
    
    
    [mapView deselectAnnotation:now animated:NO];
    NSLog(@"dingweiconentt=返回数据");
    [mapView selectAnnotation:now animated:NO];
    

    lat = lat - 0.0016;
    lon = lon - 0.0062;
    //解析获得的经纬度附近的建筑物
     [activ startAnimating];
    NSNumber * latNum = [[NSNumber alloc] initWithFloat:lat];
    NSNumber * lonNum = [[NSNumber alloc] initWithFloat:lon];
    NSURL * url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.jiepang.com/v1/locations/search?lat=%@&lon=%@&source=100000&count=50",latNum,lonNum]];
    JiexiFujin * fujin = [[JiexiFujin alloc] init];
    [fujin getUrl:url1];
    fujin.delegate = self;
    [fujin release];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connect error");
    NSLog(@"自选页面重新链接当前位置");
    [NSURLConnection connectionWithRequest:request1 delegate:self];
}

//放置当前位置的大头针
-(void)Delegatedingwei;
{
       
    //插针，弹出气泡
    now = [[PlaceNow alloc] initWithCoords:appDelegete.location];
    now.name=@"数据加载中，请稍后...";
    now.subtitle1=@"数据加载中，请稍后...";
    [self.mapView addAnnotation:now];
    [now release];
     
  
    //地图的范围 越小越精确 
       [self.mapView setRegion:appDelegete.theRegion animated:YES];
       aNum = [[NSNumber alloc] initWithFloat:lat];
        bNum = [[NSNumber alloc] initWithFloat:lon];
        NSURL * aurl = [NSURL URLWithString:[NSString stringWithFormat:
                                             @"http://ditu.google.com/maps/geo?q=%@,%@&output=json&oe=utf8&hl=zh-CN&sensor=false",aNum,bNum]];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:aurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    self.request1=request;
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [request release];
}
#pragma mark-CLLocationManagerDelegate 位置管理器的代理方法

#pragma mark-地图的代理方法
//设置Annotation 大头针上的气泡
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == self.mapView.userLocation)
    {
        return nil;
    }
    else if ([annotation isKindOfClass:[PlaceNow class]])
    {
        static NSString* placeNowIdentifier = @"TravellerAnnotationIdentifier"; 
        MKPinAnnotationView* pinView = (MKPinAnnotationView *) 
        [self.mapView dequeueReusableAnnotationViewWithIdentifier:placeNowIdentifier];
        if (!pinView) {
            MKAnnotationView* customPinView = [[[MKAnnotationView alloc] 
                                                initWithAnnotation:annotation reuseIdentifier:placeNowIdentifier] autorelease]; 
            //显示标志提示
            customPinView.canShowCallout = YES;
//            customPinView.animatesDrop = YES;
            
            //加按钮
            
            //右按钮 推出下一页面        
            UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rightBtn.frame = CGRectMake(0, 0, 40, 30);
            UIImage * bimage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithString:@"Arrow-Icon"] ofType:@"png"]];
            [rightBtn setBackgroundImage:bimage forState:UIControlStateNormal];
            [bimage release];
            [rightBtn addTarget:self action:@selector(pushuDangqian:) forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightBtn;
            //左按钮  显示周边信息        
            UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            leftBtn.frame = CGRectMake(0, 0, 53, 30);
            UIImage * aimage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithString:@"附近"] ofType:@"png"]];
            [leftBtn setBackgroundImage:aimage forState:UIControlStateNormal];
            [aimage release];
            [leftBtn addTarget:self action:@selector(removeTable:) forControlEvents:UIControlEventTouchUpInside];
            customPinView.leftCalloutAccessoryView = leftBtn;
            
            UIImage *image = [UIImage imageNamed:@"蓝色圆点151.png"]; 
            customPinView.image = image; 
            
            customPinView.opaque = YES;
            return customPinView;

        }
        else 
        { 
            pinView.annotation = annotation; 
        } 
        return pinView; 
    }
    
    else if ([annotation isKindOfClass:[PlaceMark class]])
    {
        MKPinAnnotationView * newAnnotation =[[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ann"] autorelease];
        newAnnotation.pinColor=MKPinAnnotationColorGreen;
        [newAnnotation setPinColor:MKPinAnnotationColorPurple];
        //显示标志提示
        newAnnotation.canShowCallout = YES;
        newAnnotation.animatesDrop = YES;
        //加按钮
        UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0, 0, 50, 30);
        UIImage * bimage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithString:@"Arrow-Icon30x50"] ofType:@"png"]];
        [rightBtn setBackgroundImage:bimage forState:UIControlStateNormal];
        [bimage release];
        [rightBtn addTarget:self action:@selector(pushuDangqian:) forControlEvents:UIControlEventTouchUpInside];
        newAnnotation.rightCalloutAccessoryView = rightBtn;	
        UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, 0, 53, 30);
        UIImage * aimage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithString:@"附近"] ofType:@"png"]];
        [leftBtn setBackgroundImage:aimage forState:UIControlStateNormal];
        [aimage release];
        [leftBtn addTarget:self action:@selector(removeTable:) forControlEvents:UIControlEventTouchUpInside];
        newAnnotation.leftCalloutAccessoryView = leftBtn;
        return newAnnotation;
    }
    return nil;
}
#pragma mark-异步解析的代理方法
//自动出现气泡
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    
    for (MKAnnotationView *annoView in views) {
               
        PlaceMark *anno = annoView.annotation;
        
        [mv selectAnnotation:anno animated:YES];
        
        self.nowmark2 = anno.name;
        self.nowmark1 = anno.subtitle1;
    }
}
//气泡上右边按钮的方法
-(void)pushuDangqian:(UIButton *)sender
{
    PlaceMessageViewController * placeMessage = [[PlaceMessageViewController alloc] init];
    
    
    placeMessage.lat = self.lat;
    placeMessage.lon = self.lon;
    MKAnnotationView *mk = (MKAnnotationView *)sender.superview.superview;
    
    if([mk.annotation isKindOfClass:[PlaceMark class]])
    {
        placeMessage.lat = self.lat+0.0016;
        placeMessage.lon = self.lon+0.0062;
        PlaceMark *anno = mk.annotation;
        nowmark1 = anno.name;
        nowmark2 = anno.subtitle1;
    }
    else
    {
        placeMessage.lat = appDelegete.location.latitude;
        placeMessage.lon = appDelegete.location.longitude;
        PlaceNow *nowplace = mk.annotation;
        nowmark1 = nowplace.name;
        nowmark2 = nowplace.subtitle1;
    }
    NSString * str1 = self.nowmark1;
    NSString * str2 = self.nowmark2;
    placeMessage.nameMess = str2;
    NSLog(@"placeMessage.nameMess = %@",placeMessage.nameMess);
//    placeMessage.placemess = self.nowmark2;
//    NSLog(@"placeMessage.placemess = %p",placeMessage.placemess);
    placeMessage.placename = str1;
    NSLog(@"placeMessage.placename = %@",placeMessage.placename);
    [placeMessage selectIndex:selectindex];//传值给发送信息页面
    //placeMessage.aViewC=self;
    [self.navigationController pushViewController:placeMessage animated:YES];
    [placeMessage release];

}
#pragma mark-属性列表存取数据 保存搜索过的信息
//返回数据文件的路径名 查找路径
-(NSString *)dataFilePath
{
	NSArray *paths=NSSearchPathForDirectoriesInDomains(
                                                       NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory=[paths objectAtIndex:0];
	return [documentDirectory stringByAppendingPathComponent:dizhi];
	
}
//将数据写到data.plist中
-(void)xieShuju
{
	
    NSString *filePath=[self dataFilePath];//定义filePath为存储数据的文件路径
    NSMutableArray *array=[[NSMutableArray alloc] init];
    [array addObject:self.seachBar.text];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) 
    {
        NSMutableArray *array1 = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        for (NSString * str in array1) {
            if ([seachBar.text isEqualToString:str]) {
               
                [array removeObject:str];
            }
        }
        [array addObjectsFromArray:array1];
    }
   
    [array writeToFile:[self dataFilePath] atomically:YES];
	[array release];
}
//隐藏键盘的按钮的方法
-(void) HiddenKeyBoard
{
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.3];
    [seachBar resignFirstResponder];
    self.mingziTableView.frame = CGRectMake(0, -480, 320, 480);
    self.toolBar.frame = CGRectMake(0, 480, 320, 44);
    [UIView commitAnimations];
}
//监控键盘的方法
-(void)keyboardWillShow:(NSNotification*)notification{
    
    NSDictionary*info=[notification userInfo];
    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.toolBar.frame = CGRectMake(0, 460-kbSize.height-44, 320, 44);
    [UIView commitAnimations];
}
//监控键盘的方法
-(void)keyboardWillHide:(NSNotification*)notification{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.toolBar.frame = CGRectMake(0, 480, 320, 44);
    [UIView commitAnimations];
}
#pragma mark-searchBar的代理方法

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    self.toolBar.frame = CGRectMake(0, 480, 320, 44);
    [self.seachBar resignFirstResponder];
}
//searchBar 开始输入搜索的关键字
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
//searchBar的文本字改变的方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
   
    if ([searchBar.text isEqualToString:@""]) {
        self.mingziTableView.frame = CGRectMake(0, -480, 320, 480);//tableview 收回
        self.dictableV.frame=CGRectMake(0, -436, 320, 370);
    }
//取出文件中的数据
    NSString *filePath=[self dataFilePath];//定义filePath为存储数据的文件路径
	
	//如果存储路径的文件存在，就执行操作
    [muArray removeAllObjects];
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//建立数组调用存储路径上的内容
		NSArray *array=[[NSArray alloc] initWithContentsOfFile:filePath];
      
		for (int i = 0; i < [array count]; i++) {
            NSString * str = [array objectAtIndex:i];

            if (searchBar.text.length > 0 && seachBar.text.length<=str.length) {
                NSString * str1 = [str substringToIndex:[seachBar.text length]];
                if ([seachBar.text isEqualToString:str1]) {
                    [muArray addObject:str];
                }
            }
           else
           {
               return;
           }
        }
		[array release];
	}
//联想字tableview出现    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    if ([searchBar.text isEqualToString:@""]) {
        self.mingziTableView.frame = CGRectMake(0, -480, 320, 480);//tableview 收回
        self.dictableV.frame=CGRectMake(0, -436, 320, 370);
    }
    else
    {
       
        if([muArray count]==0)
        {
            self.mingziTableView.frame=CGRectMake(0, -480, 320, 480);
        }else if ([muArray count]>0&&[muArray count] <= 5) {
                        
            self.mingziTableView.frame=CGRectMake(0, 45, 320, 480);
            
            
        }
        else
        {
            
            self.mingziTableView.frame=CGRectMake(0, 45, 320, 480);
            
        }
        
    }
    [UIView commitAnimations];
   
    [self.mingziTableView reloadData];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    self.toolBar.frame = CGRectMake(0, 480, 320, 44);
    [searchBar resignFirstResponder];
    return YES;
}
//按搜索键盘的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//联想字tableview收回 
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    self.toolBar.frame = CGRectMake(0, 480, 320, 44);
    self.mingziTableView.frame = CGRectMake(0, -480, 320, 480);//tableview 收回
    [UIView commitAnimations];
    [searchBar resignFirstResponder];
//调搜索的方法
    [self sousuo];
//往文件中写数据    
    [self xieShuju];
}

-(void)guandicdingwei
{
  
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"搜索定位页面"
                                         withError:&error]) {
        NSLog(@"error in trackPageview");
    }
    
    PlaceData *dingweiarray=[tablearray objectAtIndex:arrayrow];
    
    NSNumber *xnumber=dingweiarray.x;
    NSNumber *ynumber=dingweiarray.y;
    CLLocationCoordinate2D mark2D;
    mark2D.latitude=[xnumber floatValue];
    mark2D.longitude=[ynumber floatValue];
    
   
    lat = [xnumber floatValue];
    lon = [ynumber floatValue];
    if ([mapView.annotations containsObject:mark]) {
        [mapView removeAnnotation:mark];
    }
    PlaceMark *placemark1=[[PlaceMark alloc]initWithCoords:mark2D] ;
    
    self.mark = placemark1; 
    [placemark1 release];
   
    [self.mapView addAnnotation:mark];
   
  
    
  
    
        mark.name=dingweiarray.cname;
        mark.subtitle1 = dingweiarray.caddress;
        NSString *string1=dingweiarray.caddress;
        NSRange range=[string1 rangeOfString:@"邮政编码"];
        if (range.length==0) {
            mark.subtitle1=dingweiarray.caddress;
        }else 
        {
            NSString *string2=[string1 substringToIndex:range.location-1];
            mark.subtitle1=string2;
        }
    
   
    
    
    MKCoordinateSpan theSpan; 
    //地图的范围 越小越精确 
    theSpan.latitudeDelta= 0.005f; 
    theSpan.longitudeDelta=0.005f; 
    MKCoordinateRegion theRegion; 
    CLLocationCoordinate2D cr  = mark.coordinate;
    theRegion.center = cr;  
    theRegion.span = theSpan; 
   
    [mapView setRegion:theRegion animated:YES];
     [activ startAnimating];
    lat = lat - 0.0016;
    lon = lon - 0.0062;
    NSNumber * latNum = [[NSNumber alloc] initWithFloat:lat];
    NSNumber * lonNum = [[NSNumber alloc] initWithFloat:lon];
    //获取定位点附近的建筑物    
    NSURL * url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.jiepang.com/v1/locations/search?lat=%@&lon=%@&source=100000&count=50",latNum,lonNum]];
    JiexiFujin * fujin = [[JiexiFujin alloc] init];
    [fujin getUrl:url1];
    fujin.delegate = self;
    [fujin release];
    
    
   
//    lat = lat + 0.0016;
//    lon = lon + 0.0062;
    

}
//seachBar,返回接口里提取关键字的经纬度，代理方法
-(void) chuanDGuanjianxinxidic:(NSMutableArray *)guanndic
{
    self.tablearray=guanndic;
    if([self.tablearray count] == 1)
    {
        [actiIndicator stopAnimating];
        
        [dictableV setFrame:CGRectMake(0, -436, 320, 370)];
        [seachBar resignFirstResponder];
        self.toolBar.frame = CGRectMake(0, 480, 320, 44);
        arrayrow=0;
     
       [self guandicdingwei];
    }
    else
    {
       
        [seachBar resignFirstResponder];
        self.toolBar.frame = CGRectMake(0, 480, 320, 44);
        dictableV.delegate=self;
        dictableV.dataSource=self; 
        [actiIndicator stopAnimating];
        [dictableV reloadData];
 
    }
}
-(void) chuanFujin:(NSDictionary *)fujin
{
    [self.arrayMessage removeAllObjects];
    NSDictionary * dicMessage = fujin;
    NSArray * array = [[NSArray alloc] initWithArray:[dicMessage objectForKey:@"items"]];
    [self. arrayMessage addObjectsFromArray:array];    
    [self.myTableView reloadData];
    [activ stopAnimating];
}
-(void) chuanNowjinwei:(NSDictionary *)nowDic
{
    NSDictionary * jsonDic = nowDic; 
    NSArray * jsonarr = [jsonDic objectForKey:@"Placemark"];
    NSString * strname = [[jsonarr objectAtIndex:0] objectForKey:@"address"];
   
    NSString * name1 = [[[[[[[[jsonarr objectAtIndex:0] objectForKey:@"AddressDetails"] objectForKey:@"Country"] objectForKey:@"AdministrativeArea"] objectForKey:@"Locality"] objectForKey:@"DependentLocality"] objectForKey:@"Thoroughfare"] objectForKey:@"ThoroughfareName"];
    if (name1==nil) {
        mark.name=@"暂无此处精确信息 ";
        mark.subtitle1=@"您可以点击“附近”查看附近位置 ";
    }else{
        mark.name=name1;
        NSString *string1=strname;
        NSRange range=[string1 rangeOfString:@"邮政编码"];
        if (range.length==0) {
            mark.subtitle1=strname;
        }else 
        {
            NSString *string2=[string1 substringToIndex:range.location-1];
            mark.subtitle1=string2;
        }
    }
    [mapView deselectAnnotation:mark animated:NO];
    [mapView selectAnnotation:mark animated:NO];
    
    [mark release];
    //解析获得的经纬度附近的建筑物
    lat = lat - 0.0016;
    lon = lon - 0.0062;
    [activ startAnimating];
    NSNumber * latNum = [[NSNumber alloc] initWithFloat:lat];
    NSNumber * lonNum = [[NSNumber alloc] initWithFloat:lon];      
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.jiepang.com/v1/locations/search?lat=%@&lon=%@&source=100000&count=50",latNum,lonNum]];
   

    JiexiFujin * fujin = [[JiexiFujin alloc] init];
    fujin.delegate = self;
    [fujin getUrl:url];
    [fujin release];
    //[activ startAnimating];
//    lat = lat + 0.0016;
//    lon = lon + 0.0062;
  
     
}
// 搜索的方法
-(void) sousuo
{
    shousuo = NO;
    [self removeTable:nil];
    if (seachBar.text) {
//解析搜索位置  获取搜索位置的信息 
        
        
        
        [[MyDanLi dingWeiVC] searchBarString:seachBar.text];
    
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        UITableView *tableviewdic=[[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320,370 ) style:UITableViewStylePlain];
        self.dictableV=tableviewdic;
        [self.view addSubview:dictableV];
       
        
        [UIView commitAnimations];
        [dictableV addSubview:actiIndicator];
        [actiIndicator startAnimating];
        [tableviewdic release];
        

    }
}
#pragma mark-长按地图的方法
//长按地图获得地图的经纬度
- (void)longPress:(UIGestureRecognizer*)gestureRecognizer {

   
    shousuo = NO;
    [self removeTable:nil];
    //[self removeTable:nil];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){  
        //坐标转换
        CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate =
        [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
       
        
// 长按时获取的经纬度       
        lat = touchMapCoordinate.latitude;
        lon = touchMapCoordinate.longitude;
//        //插针 
        if ([mapView.annotations containsObject:mark]) {
           
            [mapView removeAnnotation:mark];
        }
        CLLocationCoordinate2D coord1;
        coord1.latitude = lat;
        coord1.longitude = lon;
        PlaceMark *placeMark2=[[PlaceMark alloc] initWithCoords:coord1];
        self.mark = placeMark2;
       
        mark.name=@"数据加载中，请稍后...";
        mark.subtitle1=@"数据加载中，请稍后...";
        [self.mapView addAnnotation:mark];
      
              

//地图的范围 越小越精确 
        MKCoordinateSpan theSpan; 
        theSpan.latitudeDelta= 0.005f; 
        theSpan.longitudeDelta=0.005f; 
        
        MKCoordinateRegion theRegion; 
        CLLocationCoordinate2D cr  = touchMapCoordinate;
        theRegion.center = cr;  
        theRegion.span = theSpan; 
//        [activ startAnimating];
//        
//        if (viewTable) {
//            shousuo = YES;
//            [self removeTable];
//        }else{}

//解析的是获取的经纬度的信息    
        NSNumber * mNum = [[NSNumber alloc] initWithFloat:lat];
        NSNumber * nNum = [[NSNumber alloc] initWithFloat:lon];
        NSURL * aurl = [NSURL URLWithString:[NSString stringWithFormat:
                                             @"http://ditu.google.com/maps/geo?q=%@,%@&output=json&oe=utf8&hl=zh-CN&sensor=false",mNum,nNum]];
               
        JiexiNowjiwe * nowjiwe = [[JiexiNowjiwe alloc] init];
        nowjiwe.delegate = self;
        [nowjiwe getUrl:aurl];
        [nowjiwe release];
    }
}

#pragma mark-tableView的代理方法
//表 行的代理方法
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (myTableView == tableView) {
        return [self.arrayMessage count];
    }else if(dictableV==tableView)
    {
       
        return [tablearray count];
    }
    else{
        return [muArray count];
    }
}
//表  行重用的代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
     if (myTableView == tableView) {
       
        for (UIView * aView in [cell.contentView subviews]) {
            [aView removeFromSuperview];
        }
      if (indexPath.row%2==0) {
                cell.contentView.backgroundColor=[UIColor colorWithRed:0.929 green:0.929 blue:0.929 alpha:1];
      }else
      {
          cell.contentView.backgroundColor=[UIColor whiteColor];
      }
         
        UILabel * nameLable = [[UILabel alloc] initWithFrame:CGRectMake(18, 3, 250, 30)];
        nameLable.font = [UIFont systemFontOfSize:18];
         [nameLable setBackgroundColor:[UIColor clearColor]];
        nameLable.text  = [[self.arrayMessage objectAtIndex:indexPath.row] objectForKey:@"name"];
        UILabel * addressLable = [[UILabel alloc] initWithFrame:CGRectMake(18, 30, 250, 23)];
        addressLable.font = [UIFont systemFontOfSize:14];
         [addressLable setBackgroundColor:[UIColor clearColor]];
         NSString *string1=[[self.arrayMessage objectAtIndex:indexPath.row] objectForKey:@"addr"];
         NSRange range=[string1 rangeOfString:@"邮政编码"];
         if (range.length==0) {
             addressLable.text=string1;
         }else 
         {
             NSString *string2=[string1 substringToIndex:range.location-1];
             addressLable.text=string2;
         }
       
         UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(290, 15, 10, 15)];
         [aImageView setImage:[UIImage imageNamed:@"透明箭头.png"]];
         [cell.contentView addSubview:aImageView];
        [cell.contentView addSubview:nameLable];
        [cell.contentView addSubview:addressLable];
        [nameLable release];
        [addressLable release];
         }

    else if(dictableV==tableView)
    {
        for (UIView * aView in [cell.contentView subviews]) {
            [aView removeFromSuperview];
        }
        PlaceData *p = [tablearray objectAtIndex:indexPath.row];
       
        UILabel * nameLable = [[UILabel alloc] initWithFrame:CGRectMake(18, 3, 250, 30)];
        nameLable.font = [UIFont systemFontOfSize:18];
        [nameLable setBackgroundColor:[UIColor clearColor]];
        nameLable.text  = p.cname;
        UILabel * addressLable = [[UILabel alloc] initWithFrame:CGRectMake(18, 27, 250, 23)];
        addressLable.font = [UIFont systemFontOfSize:14];
        [addressLable setBackgroundColor:[UIColor clearColor]];
        NSString *string1=p.caddress;
        NSRange range=[string1 rangeOfString:@"邮政编码"];
        if (range.length==0) {
            addressLable.text=string1;
        }else 
        {
            NSString *string2=[string1 substringToIndex:range.location-1];
            addressLable.text=string2;
        }

        UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(290, 15, 10, 15)];
        [aImageView setImage:[UIImage imageNamed:@"透明箭头.png"]];
        [cell.contentView addSubview:aImageView];
        [cell.contentView addSubview:nameLable];
        [cell.contentView addSubview:addressLable];
        [nameLable release];
        [addressLable release];
        
    }
    else{
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = [muArray objectAtIndex:indexPath.row];
    }
     
    return cell;
}
//表 表头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (myTableView == tableView) {
        return 16;
    }else if(dictableV ==tableView)
    {
        return 0;
    }
    else
    {
        return 0;
    }
}
//表  返回表头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (myTableView == tableView) {
        UIControl * aView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 13)];
        [aView addTarget:self action:@selector(removeTable:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView * aImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"绿条.png"]];
        [aView addSubview:aImage];
        [aImage release];
        return aView;
    }
    else
    {
        return nil;
    }
}
//表  行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (myTableView == tableView) {
        return 55;
    }
    else if(dictableV==tableView)
    {
        return 50;
    }
    else
    {
        return 30;
    }
}

//表  点击行cell的代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (myTableView == tableView) {
        NSLog(@"运行没？");
        PlaceMessageViewController * placeMessage = [[PlaceMessageViewController alloc] init];
        placeMessage.messageDic = [self.arrayMessage objectAtIndex:indexPath.row];
        placeMessage.lat = [[placeMessage.messageDic objectForKey:@"lat"] floatValue];
        placeMessage.lon = [[placeMessage.messageDic objectForKey:@"lon"] floatValue];
        placeMessage.nameMess = [placeMessage.messageDic objectForKey:@"addr"];
        NSLog(@"placeMessage.nameMess = %@",placeMessage.nameMess);
        placeMessage.placename = [placeMessage.messageDic objectForKey:@"name"];
        NSLog(@"placeMessage.placename = %@",placeMessage.placename);
       //4 placeMessage.placemess = [placeMessage.messageDic objectForKey:@"addr"];
        //placeMessage.aViewC=self;
        [self.navigationController pushViewController:placeMessage animated:YES];
        [placeMessage release];
    }else if(dictableV==tableView)
    {
        

        
        arrayrow=indexPath.row;
        
        [self guandicdingwei];
        self.dictableV.frame=CGRectMake(0, -436, 320, 370);
    }
    else
    {
        [seachBar resignFirstResponder];
        self.toolBar.frame = CGRectMake(0, 480, 320, 44);
        seachBar.text = [muArray objectAtIndex:indexPath.row];
        [self sousuo];
        self.mingziTableView.frame = CGRectMake(0, -480, 320, 480);
    }
}
#pragma mark-其他方法方法
//收缩表 
-(void) removeTable:(id)sender

{
    UIButton *button=(UIButton *)sender;
    if (shousuo == YES) {
        MKAnnotationView *mk = (MKAnnotationView *)button.superview.superview;
        
        if([mk.annotation isKindOfClass:[PlaceNow class]])
        {
            //lat = lat - 0.0016;
            //lon = lon - 0.0062;
            //解析获得的经纬度附近的建筑物
            [activ startAnimating];
            NSNumber * latNum = [[NSNumber alloc] initWithFloat:appDelegete.location.latitude-0.0016];
            NSNumber * lonNum = [[NSNumber alloc] initWithFloat:appDelegete.location.longitude-0.0062];
            NSURL * url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.jiepang.com/v1/locations/search?lat=%@&lon=%@&source=100000&count=50",latNum,lonNum]];
            JiexiFujin * fujin = [[JiexiFujin alloc] init];
            [fujin getUrl:url1];
            fujin.delegate = self;
            [fujin release];
            
            viewTable.frame = CGRectMake(0, 230, 320, 180); //tableview 伸开
            
            self.myTableView.delegate=self;
            self.myTableView.dataSource=self;
            [self.myTableView reloadData];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            [UIView setAnimationDelegate:self];
            self.mapView.frame = CGRectMake(0, 0, 320, 367);
            [UIView commitAnimations];
            shousuo = NO;

        }else{ 
            
            [activ startAnimating];
            NSNumber * latNum = [[NSNumber alloc] initWithFloat:lat];
            NSNumber * lonNum = [[NSNumber alloc] initWithFloat:lon];
            NSURL * url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.jiepang.com/v1/locations/search?lat=%@&lon=%@&source=100000&count=50",latNum,lonNum]];
            JiexiFujin * fujin = [[JiexiFujin alloc] init];
            [fujin getUrl:url1];
            fujin.delegate = self;
            [fujin release];

        viewTable.frame = CGRectMake(0, 230, 320, 180); //tableview 伸开

        self.myTableView.delegate=self;
        self.myTableView.dataSource=self;
        [self.myTableView reloadData];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDelegate:self];
        self.mapView.frame = CGRectMake(0, 0, 320, 367);
        [UIView commitAnimations];
        shousuo = NO;
        }
    }
    else{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        viewTable.frame = CGRectMake(0, 411, 320, 180);//tableview 收回
        [UIView commitAnimations];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDelegate:self];
        self.mapView.frame = CGRectMake(0, 44, 320, 367);
        [UIView commitAnimations];
        shousuo = YES;
    }
}
//返回按钮
- (IBAction)goBack:(id)sender {

        [self dismissModalViewControllerAnimated:YES];


}


- (IBAction)huishouJianpan:(id)sender {
    [seachBar resignFirstResponder];
}


- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setSeachBar:nil];
    [self setMyTableView:nil];
    [self setXinxiView:nil];
    [self setMingziTableView:nil];
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
    [request1 release];
    [actiIndicator release];
    [tablearray release];
    [dictableV release];
    [mark release];
    [now release];
    [data release];
    [mapView release];
    [seachBar release];
    [xuanButton  release];
    [myTableView release];
    [viewTable release];
    [xinxiView release];
    [mingziTableView release];
    [super dealloc];
}

- (void) errorWithNoPlace
{
   
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"没有相关数据，请查证后再次搜索" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

@end
