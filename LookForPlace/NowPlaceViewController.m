//
//  NowPlaceViewController.m
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-9.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import "NowPlaceViewController.h"
#import "PlaceMark.h"
#import "PlaceMessage.h"
#import "PlaceMessageViewController.h"
#import "JSON.h"
#import "URLEncode.h"
#import "PlaceMark.h"
#import "AppDelegate.h"
@implementation NowPlaceViewController
@synthesize mapView,amutabledata;
@synthesize myTableView,lat,lon,arrayMessage;
@synthesize connection1,connection2,connection3,mark;
@synthesize request1,request2,request3;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"发送当前位置页面"
                                         withError:&error]) {
        NSLog(@"error in trackPageview");
    }
    
    //传值给发送信息页面的初始值
    selectindex=2;
    
    self. arrayMessage = [[NSMutableArray alloc] init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    viewTable = [[UIView alloc] initWithFrame:CGRectMake(0, 411, 320, 180)];
    activ = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 50, 50, 50)];
    activ.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    viewTable.backgroundColor = [UIColor clearColor];
    [self.myTableView addSubview:activ];
    [viewTable addSubview:self.myTableView];
    [self.view addSubview:viewTable];
    [viewTable release];

    shousuo = YES;
    
    UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    lpress.minimumPressDuration = 1.0;//按2秒响应longPress方法
    lpress.allowableMovement = 10.0;
    //给MKMapView加上长按事件
    [self.mapView addGestureRecognizer:lpress];//mapView是MKMapView的实例
    [lpress release];
    
    appDelegete = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    lat=appDelegete.location.latitude;
    lon=appDelegete.location.longitude;

       
    [self performSelector:@selector(Delegatedingwei)];
    
    //给mapview上添加touch事件
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelSingleTap:)];
//    [newAnnotation addGestureRecognizer:singleTap];
//    //[singleTap release];
//    [singleTap setNumberOfTouchesRequired:1];//触摸点个数
//    [singleTap setNumberOfTapsRequired:1];
    
   
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"response data");
    NSMutableData *a = [[NSMutableData alloc] init];
    self.amutabledata =a;
    [a release];
    
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)adata
{
    [self.amutabledata appendData:adata];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection==connection1) {
        NSString *jsonString = [[NSString alloc] initWithData:self.amutabledata encoding:NSUTF8StringEncoding];
        NSDictionary * jsonDic = [jsonString JSONValue]; 
        NSArray * jsonarr = [jsonDic objectForKey:@"Placemark"];
        
        NSString * name1 = [[[[[[[[jsonarr objectAtIndex:0] objectForKey:@"AddressDetails"] objectForKey:@"Country"] objectForKey:@"AdministrativeArea"] objectForKey:@"Locality"] objectForKey:@"DependentLocality"] objectForKey:@"Thoroughfare"] objectForKey:@"ThoroughfareName"];
            //给气泡换文字
         [mapView deselectAnnotation:now animated:NO];
        if (name1==nil) {
            mark.name=@"暂无此处精确信息 ";
            mark.subtitle1=@"您可以点击“附近”查看附近位置 ";
        }else{
            NSLog(@"返回有数据的时候");
        now.name=name1;
        now.subtitle1=[[jsonarr objectAtIndex:0] objectForKey:@"address"];
        }
        NSLog(@"now.name=%@",now.name);
        NSLog(@"now.subtitle=%@",now.subtitle1);
        [mapView deselectAnnotation:now animated:NO];
        NSLog(@"connection=12121212121");
        [mapView selectAnnotation:now animated:NO];
        [indicatorV stopAnimating];
       
        
        lat = lat;
        lon = lon;
        //[self jiexiFujinxinxi];
        
                
    }else if(connection==connection2)
    {
        NSString * jsonStr = [[NSString alloc] initWithData:amutabledata encoding:NSUTF8StringEncoding];
            NSDictionary * dicMessage = [jsonStr JSONValue];
           NSArray * array  = [[NSArray alloc] initWithArray:[dicMessage objectForKey:@"items"]]; 
            [self.arrayMessage removeAllObjects];
            [self. arrayMessage addObjectsFromArray:array];
            [self.myTableView reloadData];
            [activ stopAnimating];
        
    }else if(connection==connection3)
    {
        NSString *jsonString=[[NSString alloc] initWithData:amutabledata encoding:NSUTF8StringEncoding];
        NSDictionary * jsonDic = [jsonString JSONValue]; 
        NSArray * jsonarr = [jsonDic objectForKey:@"Placemark"];
        NSString * name1 = [[[[[[[[jsonarr objectAtIndex:0] objectForKey:@"AddressDetails"] objectForKey:@"Country"] objectForKey:@"AdministrativeArea"] objectForKey:@"Locality"] objectForKey:@"DependentLocality"] objectForKey:@"Thoroughfare"] objectForKey:@"ThoroughfareName"];
        if (name1==nil) {
            mark.name=@"暂无此处精确信息 ";
            mark.subtitle1=@"您可以点击“附近”查看附近位置 ";
        }else{
        mark.name = name1;;
       mark.subtitle1 = [[jsonarr objectAtIndex:0] objectForKey:@"address"];
        }
        
        [mapView deselectAnnotation:mark animated:NO];
        [mapView selectAnnotation:mark animated:NO];
        
        //[self jiexiFujinxinxi];
        
    }

}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connect error");
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    	[alert show];
//    	[alert release];
    if (connection==connection1) {
        NSLog(@"重新链接 connection1");
        self.connection1=[NSURLConnection connectionWithRequest:request1 delegate:self];
    }
    if (connection==connection2) {
        NSLog(@"重新链接 connection2");
        self.connection2=[NSURLConnection connectionWithRequest:request2 delegate:self];
    }
    if (connection==connection3) {
        NSLog(@"重新链接 connection3");
        self.connection3=[NSURLConnection connectionWithRequest:request3 delegate:self];
    }

}

//放置当前位置的大头针
-(void)Delegatedingwei;
{
       
    
   now = [[PlaceNow alloc] initWithCoords:appDelegete.location];
    
   now.name = @"数据加载中，请稍后...";
   now.subtitle1 = @"数据加载中，请稍后...";
    nowmark1=now.name;
    nowmark2=now.subtitle1;
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
    self.connection1=[NSURLConnection connectionWithRequest:request delegate:self];
    [request release];
    
    }

#pragma mark-CLLocationManagerDelegate 位置管理器的代理//定位当前点的方法
#pragma mark - 长按地图的方法
//长按地图获得地图的经纬度
- (void)longPress:(UIGestureRecognizer*)gestureRecognizer {
    shousuo = NO;
    [self removeTable:nil];
//这个状态判断很重要 判断手势为长按手势    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){  
//坐标转换
        CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
        touchMapCoordinate =
        [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
// 长按时获取的经纬度       
        lat = touchMapCoordinate.latitude;
        lon = touchMapCoordinate.longitude;
//插针 
        if ([mapView.annotations containsObject:mark]) {
            [mapView removeAnnotation:mark];
        }
        CLLocationCoordinate2D coord;
        coord.latitude = lat;
        coord.longitude = lon;
        PlaceMark *placeMark1=[[PlaceMark alloc] initWithCoords:coord] ;
        self.mark = placeMark1;
        mark.name=@"数据加载中，请稍后...";
        mark.subtitle1=@"数据加载中，请稍后...";
        
        [self.mapView addAnnotation:mark];
        [placeMark1 release];
       
//地图的范围 越小越精确 
        MKCoordinateSpan theSpan; 
        theSpan.latitudeDelta= 0.005f; 
        theSpan.longitudeDelta=0.005f; 
        MKCoordinateRegion theRegion; 
        CLLocationCoordinate2D cr  = touchMapCoordinate;
        theRegion.center = cr;  
        theRegion.span = theSpan; 
        [activ startAnimating];
//
        if (viewTable) {
            shousuo = YES;
            //[self removeTable:nil];
        }else{}

        [self jiexiDingdianxinxi];
           
        
        }
}

#pragma mark - 解析接口的方法

//解析获取经纬度的地址、名字等信息
-(void) jiexiDingdianxinxi
{
   
    //解析的是获取的经纬度的信息    
    NSNumber * mNum = [[NSNumber alloc] initWithFloat:lat];
    NSNumber * nNum = [[NSNumber alloc] initWithFloat:lon];
    NSURL * aurl = [NSURL URLWithString:[NSString stringWithFormat:
                                         @"http://ditu.google.com/maps/geo?q=%@,%@&output=json&oe=utf8&hl=zh-CN&sensor=false",mNum,nNum]];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:aurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    self.request3=request;
    self.connection3=[NSURLConnection connectionWithRequest:request delegate:self];
    [request release];
    [mNum release];
    [nNum release];
    
   
}
//解析获取定点的附近建筑物的信息
-(void) jiexiFujinxinxi
{
  
    [activ startAnimating];
    lat = lat ;
    lon = lon ;
    //解析获得的经纬度附近的建筑物
    NSNumber * latNum = [[NSNumber alloc] initWithFloat:lat];
    NSNumber * lonNum = [[NSNumber alloc] initWithFloat:lon];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.jiepang.com/v1/locations/search?lat=%@&lon=%@&source=100000&count=50",latNum,lonNum]];
   
    NSURLRequest * aRequest = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    self.request2=aRequest;
    self.connection2=[NSURLConnection connectionWithRequest:aRequest delegate:self];
    [aRequest release]; 
    [latNum release];
    [lonNum release];
    


}



#pragma mark-地图的代理方法

//设置Annotation   大头针上的图
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	newAnnotation =[[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ann"] autorelease];
   // UIImage *image = [UIImage imageNamed:@"1.png"]; 
   // newAnnotation.image = image; 
    //newAnnotation.opaque = YES;

//	newAnnotation.pinColor=MKPinAnnotationColorGreen;
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
	
    
    
//    //当前位置大头针换成蓝色圆点
//    if (annotation == self.mapView.userLocation)
//    {
//        return nil;
//    }
//    else if ([annotation isKindOfClass:[PlaceNow class]])
//    {
//        static NSString* placeNowIdentifier = @"TravellerAnnotationIdentifier"; 
//        MKPinAnnotationView* pinView = (MKPinAnnotationView *) 
//        [self.mapView dequeueReusableAnnotationViewWithIdentifier:placeNowIdentifier];
//        if (!pinView) {
//            MKAnnotationView* customPinView = [[[MKAnnotationView alloc] 
//                                                initWithAnnotation:annotation reuseIdentifier:placeNowIdentifier] autorelease]; 
//            //显示标志提示
//            customPinView.canShowCallout = YES;
//            pinView.animatesDrop = YES;
//            
//            //加按钮
//            
//            //右按钮 推出下一页面        
//            UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            rightBtn.frame = CGRectMake(0, 0, 40, 30);
//            UIImage * bimage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithString:@"Arrow-Icon"] ofType:@"png"]];
//            [rightBtn setBackgroundImage:bimage forState:UIControlStateNormal];
//            [bimage release];
//            [rightBtn addTarget:self action:@selector(pushuDangqian:) forControlEvents:UIControlEventTouchUpInside];
//            customPinView.rightCalloutAccessoryView = rightBtn;
//            //左按钮  显示周边信息        
//            UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            leftBtn.frame = CGRectMake(0, 0, 53, 30);
//            UIImage * aimage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithString:@"附近"] ofType:@"png"]];
//            [leftBtn setBackgroundImage:aimage forState:UIControlStateNormal];
//            [aimage release];
//            [leftBtn addTarget:self action:@selector(removeTable:) forControlEvents:UIControlEventTouchUpInside];
//            customPinView.leftCalloutAccessoryView = leftBtn;
//            
//            UIImage *image = [UIImage imageNamed:@"蓝色圆点151.png"]; 
//            customPinView.image = image; 
//            customPinView.opaque = YES;
//            return customPinView;
//        
//        }
//        else 
//        { 
//            pinView.annotation = annotation; 
//        } 
//        return pinView; 
//    }
//    
//    else if ([annotation isKindOfClass:[PlaceMark class]])
//    {
//        newAnnotation =[[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ann"] autorelease];
//        newAnnotation.pinColor=MKPinAnnotationColorGreen;
//        [newAnnotation setPinColor:MKPinAnnotationColorPurple];
//        //显示标志提示
//        newAnnotation.canShowCallout = YES;
//        newAnnotation.animatesDrop = YES;
//        //加按钮
//        UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        rightBtn.frame = CGRectMake(0, 0, 50, 30);
//        UIImage * bimage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithString:@"Arrow-Icon30x50"] ofType:@"png"]];
//        [rightBtn setBackgroundImage:bimage forState:UIControlStateNormal];
//        [bimage release];
//        [rightBtn addTarget:self action:@selector(pushuDangqian:) forControlEvents:UIControlEventTouchUpInside];
//        newAnnotation.rightCalloutAccessoryView = rightBtn;	
//        UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        leftBtn.frame = CGRectMake(0, 0, 53, 30);
//        UIImage * aimage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithString:@"附近"] ofType:@"png"]];
//        [leftBtn setBackgroundImage:aimage forState:UIControlStateNormal];
//        [aimage release];
//        [leftBtn addTarget:self action:@selector(removeTable:) forControlEvents:UIControlEventTouchUpInside];
//        newAnnotation.leftCalloutAccessoryView = leftBtn;
//        return newAnnotation;
//    }
//    return nil;
}

//自动出现气泡
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    
    for (MKAnnotationView *annoView in views) {
        
        PlaceMark *anno = annoView.annotation;
        //anno.name=@"正在搜索中";
        //anno.subtitle1=@"正在搜索中";
        [mv selectAnnotation:anno animated:YES];
        
        nowmark2 = anno.name;
        nowmark1 = anno.subtitle1;
        
       
    }
}

//气泡上右边按钮的方法
-(void) pushuDangqian:(UIButton *)sender
{
    PlaceMessageViewController * placeMessage = [[PlaceMessageViewController alloc] init];
    
    
    //placeMessage.lat = self.lat;
    //placeMessage.lon = self.lon;
    MKAnnotationView *mk = (MKAnnotationView *)sender.superview.superview;
    
    if([mk.annotation isKindOfClass:[PlaceMark class]])
    {
        placeMessage.lat = touchMapCoordinate.latitude;
        placeMessage.lon = touchMapCoordinate.longitude;
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
    placeMessage.nameMess = nowmark2;
    placeMessage.placemess = nowmark2;
    placeMessage.placename = nowmark1;
    [placeMessage selectIndex:selectindex];//传值给发送信息页面
    [self.navigationController pushViewController:placeMessage animated:YES];
    [placeMessage release];
}


#pragma mark  -  UITableView的代理方法

//表 行的代理方法
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return [self.arrayMessage count];
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
    nameLable.backgroundColor = [UIColor clearColor];
    //[nameLable setFont:[UIFont fontWithName:@"Thonburi-Bold" size:18]];
    [nameLable setFont:[UIFont systemFontOfSize:18]];
    nameLable.text  = [[self.arrayMessage objectAtIndex:indexPath.row] objectForKey:@"name"];
    UILabel * addressLable = [[UILabel alloc] initWithFrame:CGRectMake(18, 30, 250, 23)];
    addressLable.backgroundColor = [UIColor clearColor];
    addressLable.font = [UIFont systemFontOfSize:14];
    //[addressLable setFont:[UIFont fontWithName:@"Thonburi-Bold" size:14]];
    //[addressLable setTextColor:[UIColor grayColor]];
    
    addressLable.numberOfLines = 2;
    NSString *string1=[[self.arrayMessage objectAtIndex:indexPath.row] objectForKey:@"addr"];
    NSRange range=[string1 rangeOfString:@"邮政编码"];
    if (range.length==0) {
        addressLable.text=string1;
    }else 
    {
        NSString *string2=[string1 substringToIndex:range.location-1];
        addressLable.text=string2;
    }

    //addressLable.text  = [[self.arrayMessage objectAtIndex:indexPath.row] objectForKey:@"addr"];
    UIImageView *aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(290, 15, 10, 15)];
    [aImageView setImage:[UIImage imageNamed:@"透明箭头.png"]];
    [cell.contentView addSubview:aImageView];
    [cell.contentView addSubview:nameLable];
    [cell.contentView addSubview:addressLable];
//    [cell.contentView addSubview:distLable];
    [nameLable release];
    [addressLable release];
    
    

    
    return cell;
}
//表 表头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16;
}
//表  返回表头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIControl * aView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 13)];
    UIImageView * aImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"绿条.png"]];
    [aView addSubview:aImage];
    [aImage release];
    [aView addTarget:self action:@selector(removeTable:) forControlEvents:UIControlEventTouchUpInside];
    return aView;
}
//表  行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
//表  点击行cell的代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlaceMessageViewController * placeMessage = [[PlaceMessageViewController alloc] init];
    placeMessage.messageDic = [self.arrayMessage objectAtIndex:indexPath.row];
    placeMessage.lat = [[placeMessage.messageDic objectForKey:@"lat"] floatValue];
    placeMessage.lon = [[placeMessage.messageDic objectForKey:@"lon"] floatValue];
    placeMessage.nameMess = [placeMessage.messageDic objectForKey:@"addr"];
    placeMessage.placename = [placeMessage.messageDic objectForKey:@"name"];
    placeMessage.placemess = [placeMessage.messageDic objectForKey:@"addr"];
    [self.navigationController pushViewController:placeMessage animated:YES];
    [placeMessage release];
}

#pragma mark  -  其他的方法

//收缩信息表
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
//            [activ startAnimating];
//            NSNumber * latNum = [[NSNumber alloc] initWithFloat:appDelegete.location.latitude-0.0016];
//            NSNumber * lonNum = [[NSNumber alloc] initWithFloat:appDelegete.location.longitude-0.0062];
//            NSURL * url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.jiepang.com/v1/locations/search?lat=%@&lon=%@&source=100000&count=50",latNum,lonNum]];
//            JiexiFujin * fujin = [[JiexiFujin alloc] init];
//            [fujin getUrl:url1];
//            fujin.delegate = self;
//            [fujin release];
            
            lat=appDelegete.location.latitude-0.0016;
            lon=appDelegete.location.longitude-0.0062;

            [self jiexiFujinxinxi];
            //lat=lat+0.0016;
            //lon=lon+0.0062;
            
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
//            
//            [activ startAnimating];
//            NSNumber * latNum = [[NSNumber alloc] initWithFloat:lat];
//            NSNumber * lonNum = [[NSNumber alloc] initWithFloat:lon];
//            NSURL * url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.jiepang.com/v1/locations/search?lat=%@&lon=%@&source=100000&count=50",latNum,lonNum]];
//            JiexiFujin * fujin = [[JiexiFujin alloc] init];
//            [fujin getUrl:url1];
//            fujin.delegate = self;
//            [fujin release];
            lat=touchMapCoordinate.latitude-0.0016;
            lon=touchMapCoordinate.longitude-0.0062;
            [self jiexiFujinxinxi];
            lat=lat+0.0016;
            lon=lon+0.0062;
            
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

- (IBAction)backButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
   
}
//重新定位
- (IBAction)xinDingwei:(id)sender {
    
    //if (viewTable) {
        shousuo = YES;
        //[self removeTable:nil];
    //}else{}
    if ([mapView.annotations containsObject:now]) {
        [self.mapView removeAnnotation:now];
    }
    MKCoordinateSpan theSpan; 
    theSpan.latitudeDelta = 0.01f; 
    theSpan.longitudeDelta = 0.01f; 
    CLLocationCoordinate2D coord;
    lat = appDelegete.location.latitude;
    lon = appDelegete.location.longitude;
    coord.latitude = lat;
    coord.longitude = lon;
   // coord.latitude=lat;
    //coord.longitude=lon;
    PlaceNow *placemarkshuaxin=[[PlaceNow alloc] initWithCoords:coord];
    now =placemarkshuaxin;
    now.name = @"数据加载中，请稍后...";
    now.subtitle1 = @"数据加载中，请稍后...";
    nowmark1=now.name;
    nowmark2=now.subtitle1;
    [self.mapView addAnnotation:now];
    [placemarkshuaxin release];
    MKCoordinateRegion theRegion; 
    theRegion.center = coord; 
    theRegion.span = theSpan; 
   
    [self.mapView setRegion:theRegion animated:YES];
    aNum = [[NSNumber alloc] initWithFloat:lat];
    bNum = [[NSNumber alloc] initWithFloat:lon];
    
    
    NSURL * aurl = [NSURL URLWithString:[NSString stringWithFormat:
                                         @"http://ditu.google.com/maps/geo?q=%@,%@&output=json&oe=utf8&hl=zh-CN&sensor=false",aNum,bNum]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:aurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    self.request1=request;
    self.connection1=[NSURLConnection connectionWithRequest:request delegate:self];
    [request release];

    //[self jiexiDingdianxinxi];
    //[self jiexiFujinxinxi];
}

- (void)viewDidUnload
{

    [self setMapView:nil];
    [self setMyTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) dealloc
{

    [request1 release];
    [request2 release];
    [request3 release];
    [mark release];
    [amutabledata release];
    [mapView release];
    [myTableView release];
    [super dealloc];
}
@end
