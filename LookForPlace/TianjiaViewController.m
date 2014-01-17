//
//  TianjiaViewController.m
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-2.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import "TianjiaViewController.h"

@implementation TianjiaViewController
@synthesize myTableView,ditieDic;
@synthesize messArray,placeController,bianjiController;
@synthesize  cankaolat,cankaolon,cankaomess,cankaoname,placelat,placelon;
@synthesize delegate,fangwei;
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(float) jisuanJvLi:(float) thelat andlon:(float) thelon andcankaolat:(float) thecankaolat andcankaolon:(float) thecankaolon
{
    //    MATH_ERREXCEPT
    double EARTH_RADIUS = 6378.137*1000;//地球半径 
    double radLat1 = (thelat * M_PI / 180.0);
    double radLat2 = (thecankaolat * M_PI / 180.0);
    double a = radLat1 - radLat2;
    double b = (thelon - thecankaolon) * M_PI / 180.0;
    double s = 2 * asin(sqrt(pow(sin(a / 2), 2)
                             + cos(radLat1) * cos(radLat2)
                             * pow(sin(b / 2), 2)));
    s = s * EARTH_RADIUS;
    s = round(s * 10000) / 10000;
    
    return s;
}
//计算方位
-(NSString *) jisuanFangwei:(float) thelat andlon:(float) thelon andcankaolat:(float) thecankaolat andcnakaolon:(float) thecankaolon
{
    fangwei = [[NSString alloc] init];
    NSString *string;
    
    NSLog(@"thelat=%f",thelat);
    NSLog(@"thelon=%f",thelon);
    NSLog(@"cankaolat=%f",thecankaolat);
    NSLog(@"cankaolon=%f",thecankaolon);
    double d = atan((thecankaolat-thelat)/(thecankaolon-thelon));
    //double d=atan((thelat-thecankaolat)/(thelon-thecankaolon));
    double degree = d/M_PI*180;
    NSLog(@"degree=%f",degree);
     NSLog(@"d=%f",d);
    if(degree>0 && degree<=22.5 && thecankaolat>thelat){
        NSLog(@"正西方向");
        fangwei = @"正西方向";
    }else if(degree>22.5&&degree<=67.5&&thecankaolat>thelat){
         NSLog(@"西南方向");
        fangwei = @"西南方向";
    }else if(degree>67.5&&degree<90&&thecankaolat>thelat){
    
        NSLog(@"正南方向");
        fangwei = @"正南方向";
    }else if(degree>-22.5&&degree<=0&&thecankaolat<thelat){
        NSLog(@"正西方向");
        fangwei = @"正西方向";
    }else if(degree>-67.5&&degree<=-22.5&&thecankaolat<thelat){
        NSLog(@"西北方向");
        fangwei = @"西北方向";
    }else if(degree>-90&&degree<=-67.5&&thecankaolat<thelat){
        NSLog(@"正北方向");
        fangwei = @"正北方向";
    }else if(degree>67.5&&degree<90&&thecankaolat<thelat){
        NSLog(@"正北方向");
        fangwei = @"正北方向";
    }else if(degree>22.5&&degree<=67.5&&thecankaolat<thelat){
        NSLog(@"东北方向");
        fangwei = @"东北方向";
    }else if(degree>0&&degree<=22.5&&thecankaolat<thelat){
        NSLog(@"正东方向");
        fangwei  = @"正东方向";
    }else if(degree>-22.5&&degree<=0&&thecankaolat>thelat){
        NSLog(@"正东方向");
        fangwei = @"正东方向";
    }else if(degree>-67.5&&degree<=-22.5&&thecankaolat>thelat){
        NSLog(@"东南方向");
        fangwei = @"东南方向";
    }else if(degree>-90&&degree<=-67.5&&thecankaolat>thelat){
        NSLog(@"正南方向");
        fangwei = @"正南方向";
    }
    double myDist = [self jisuanJvLi:thelat andlon:thelon andcankaolat:thecankaolat andcankaolon:thecankaolon];
//    if (myDist <= 100) {
//        //direction = direction + myDist;
//    } else if (myDist > 100) {
//        int b = myDist / 10;
//        //			long dist = Math.round(myDist);
//        myDist= b * 10;
//    }

    if(myDist<=100){
        NSLog(@"fangwei 1=%@",fangwei);
        
        NSNumber * a = [[NSNumber alloc] initWithDouble:myDist];
        int b=[a intValue];
        string = [NSString stringWithFormat:@"%@ %d米",fangwei,b];
        [a release];
    }else if(myDist>100){
        long dist = round(myDist);
         NSLog(@"fangwei 2=%@",fangwei);        
        NSNumber * a = [[NSNumber alloc] initWithLong:dist];        
        NSMutableString *numbera=[[NSMutableString alloc] initWithFormat:@"%@",a];
        [numbera insertString:@"0" atIndex:[numbera length]-1];
        NSString *aa=[numbera substringWithRange:NSMakeRange(0,[numbera length]-1)];          
        string = [NSString stringWithFormat:@"%@ %@米",fangwei,aa];
        [a release];
    }
    NSLog(@"stingfangwei=%@",string);
    return string;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    activ = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(130, 180, 50, 50)];
    activ.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:activ];
    if (!self.messArray) {
        [activ startAnimating];
    }
    [activ release];
}
//代理方法
-(void) chuanshuzu:(NSArray *)array//保存界面传值代理
{
    
    NSLog(@"aa11111111111111111111");
    self.messArray = array;
   
    [self.myTableView reloadData];
    [activ stopAnimating];
}
-(void) chuanshuzua:(NSArray *)array//编辑界面传值代理
{
  
    self.messArray = array;
    [self.myTableView reloadData];
    [activ stopAnimating];
}
-(void) chuanDitie:(NSDictionary *)dic
{
    self.ditieDic = dic;
    [self.myTableView reloadData];
}
#pragma mark-UITableViewDataSource  -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}
//分行
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
    
    int num;
    switch (section) {
		case 0:
            if (!self.ditieDic) {
                num = 0;
            }
            else{
              num=1;  
            }
			break;
		case 1:
			num=[self.messArray count];
			break;
        default:
			break;
	}
   
    return num;
}
//重用
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"bb111111111");
    static NSString *CellIdentifier1 = @"Cell1";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    for (UIView * aView in [cell.contentView subviews]) {
        [aView removeFromSuperview];
    }
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16, 25, 30)];
    //显示参照物的名字
    UILabel * nameLable = [[UILabel alloc] initWithFrame:CGRectMake(42, 8, 250, 25)];
    nameLable.font = [UIFont systemFontOfSize:15];
    nameLable.backgroundColor = [UIColor clearColor];
    //显示参照信息
    UILabel * addressLable = [[UILabel alloc] initWithFrame:CGRectMake(42, 30, 209, 30)];
    addressLable.numberOfLines = 2;
    addressLable.font = [UIFont systemFontOfSize:12.0];
    addressLable.backgroundColor = [UIColor clearColor];
    //判断方位
    float a;//纬
    float b;//经
   // NSString * str1;
    //NSString * str2;
    switch (indexPath.section)
    {
        case 0:
        {
            image.image = [UIImage imageNamed:@"店名.png"]; 
            nameLable.text  = [self.ditieDic objectForKey:@"addr"];
            //参考的经纬度 
            cankaolat = [[self.ditieDic objectForKey:@"lat"] floatValue];
            cankaolon = [[self.ditieDic objectForKey:@"lon"] floatValue];
            a = placelat - cankaolat;
            b = placelon - cankaolon;
            
            
            NSString * string = [NSString stringWithFormat:@"%@",[self.ditieDic objectForKey:@"addr"]];
            //if ([string rangeOfString:@"邮政编码"]) {
            // NSRange rang=[string rangeOfString:@"邮政编码"];
            // }
            
            
            //                       NSString * string2 = [self.ditieDic objectForKey:@"dist"];
            //
            //            if (a>0.0&&b>0.0) {
            //                str1=@"东北方";
            //                 addressLable.text  = [NSString stringWithFormat:@"%@ %@%@",string,str1,string2];  
            //            }else if(a>0.0&&b<0.0)
            //            {
            //                str1=@"西北方";
            //                 addressLable.text  = [NSString stringWithFormat:@"%@ %@%@",string,str1,string2];  
            //            }else if(a>0.0&&b==0.0)
            //            {
            //                str1=@"正北方";
            //                 addressLable.text  = [NSString stringWithFormat:@"%@ %@%@",string,str1,string2];  
            //            }else if(a<0.0&&b>0.0)
            //            {
            //                str1=@"东南方";
            //                 addressLable.text  = [NSString stringWithFormat:@"%@ %@%@",string,str1,string2];  
            //            }else if(a<0.0&&b<0.0)
            //            {
            //                str1=@"西南方";
            //                 addressLable.text  = [NSString stringWithFormat:@"%@ %@%@",string,str1,string2];  
            //            }else if(a<0.0&&b==0.0)
            //            {
            //                str1=@"正南方";
            //                 addressLable.text  = [NSString stringWithFormat:@"%@ %@%@",string,str1,string2];  
            //            }else if(a==0.0&&b>0.0)
            //            {
            //                str1=@"正西方";
            //                addressLable.text  = [NSString stringWithFormat:@"%@ %@%@",string,str1,string2];  
            //                
            //            }else if(a==0.0&&b<0.0)
            //            {
            //                str1=@"正东方";
            //                addressLable.text  = [NSString stringWithFormat:@"%@ %@%@",string,str1,string2];  
            //            }
            //            else if(a==0.0&&b==0.0)
            //            {
            //                str1=@"0米";
            //                 addressLable.text  = [NSString stringWithFormat:@"%@ %@",string,str1];  
            //            }
            //            
            
            addressLable.text  = [NSString stringWithFormat:@"%@ %@",string,[self jisuanFangwei:placelat andlon:placelon andcankaolat:cankaolat andcnakaolon:cankaolon]];  
            
            [addressLable setTextColor:[UIColor grayColor]];
            
            //            if (a > 0.0) {
            //                str1 = @"北";
            //            }
            //            else if(a < 0.0){
            //                str1 = @"南";
            //            }
            //            else{
            //                str1 = @"位置";
            //            }
            //            if (b > 0.0) {
            //                str2 = @"东";
            //            }
            //            else if(b < 0.0){
            //                str2 = @"西";
            //            }
            //            else{
            //                str2 = @"";
            //            }
            //            NSString * string = [NSString stringWithFormat:@"%@",[self.ditieDic objectForKey:@"addr"]];
            //            NSString * string2 = [self.ditieDic objectForKey:@"dist"];
            //显示
            //             addressLable.text  = [NSString stringWithFormat:@"%@ %@%@",string,str1,string2];
            //            addressLable.text  = [NSString stringWithFormat:@"%@ %@%@方%@",string,str2,str1,string2];
            break;
        }
        case 1:
        {
            image.image = [UIImage imageNamed:@"店名.png"];
            nameLable.text  = [[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"];
            //参考的经纬度 
            cankaolat = [[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"lat"] floatValue];
            cankaolon = [[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"lon"] floatValue];
            //判断方位
            //    float a;//纬
            //    float b;//经
            //    NSString * str1;
            //    NSString * str2;
            a = placelat - cankaolat;
            b = placelon - cankaolon;
            NSString * string3 = [NSString stringWithFormat:@"%@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
            //            NSString * string4 = [[self.messArray objectAtIndex:indexPath.row] objectForKey:@"dist"];
            //            if (a>0.0&&b>0.0) {
            //                str1=@"东北方";
            //                 addressLable.text  = [NSString stringWithFormat:@"%@ %@%@",string3,str1,string4];  
            //            }else if(a>0.0&&b<0.0)
            //            {
            //                str1=@"西北方";
            //                 addressLable.text  = [NSString stringWithFormat:@"%@ %@%@",string3,str1,string4];  
            //            }else if(a>0.0&&b==0.0)
            //            {
            //                str1=@"正北方";
            //                 addressLable.text  = [NSString stringWithFormat:@"%@ %@%@",string3,str1,string4];  
            //            }else if(a<0.0&&b>0.0)
            //            {
            //                str1=@"东南方";
            //                 addressLable.text  = [NSString stringWithFormat:@"%@ %@%@",string3,str1,string4];  
            //            }else if(a<0.0&&b<0.0)
            //            {
            //                str1=@"西南方";
            //                 addressLable.text  = [NSString stringWithFormat:@"%@ %@%@",string3,str1,string4];  
            //            }else if(a<0.0&&b==0.0)
            //            {
            //                str1=@"正南方";
            //                 addressLable.text  = [NSString stringWithFormat:@"%@ %@%@",string3,str1,string4];  
            //            }else if(a==0.0&&b>0.0)
            //            {
            //                str1=@"正西方";
            //                addressLable.text  = [NSString stringWithFormat:@"%@ %@%@",string3,str1,string4];  
            //                
            //            }else if(a==0.0&&b<0.0)
            //            {
            //                str1=@"正东方";
            //                addressLable.text  = [NSString stringWithFormat:@"%@ %@%@",string3,str1,string4];  
            //            }
            //            else if(a==0.0&&b==0.0)
            //            {
            //                str1=@"0米";
            //                 addressLable.text  = [NSString stringWithFormat:@"%@ %@",string3,str1];  
            //            }
            
            addressLable.text  = [NSString stringWithFormat:@"%@ %@",string3,[self jisuanFangwei:placelat andlon:placelon andcankaolat:cankaolat andcnakaolon:cankaolon]];
            [addressLable setTextColor:[UIColor grayColor]];
            //    if (a > 0.0) {
            //        str1 = @"北";
            //    }
            //    else if(a < 0.0){
            //        str1 = @"南";
            //    }
            //    else{
            //        str1 = @"位置";
            //    }
            //    if (b > 0.0) {
            //        str2 = @"东";
            //    }
            //    else if(b < 0.0){
            //        str2 = @"西";
            //    }
            //    else{
            //        str2 = @"当前";
            //    }
            //    NSString * string3 = [NSString stringWithFormat:@"%@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
            //    NSString * string4 = [[self.messArray objectAtIndex:indexPath.row] objectForKey:@"dist"];
            //显示
            //     addressLable.text  = [NSString stringWithFormat:@"%@ %@%@",string3,str1,string4];       
            //   addressLable.text  = [NSString stringWithFormat:@"%@ %@%@方%@",string3,str2,str1,string4];
            break;
        }
    }
    [cell.contentView addSubview:image];
    [cell.contentView addSubview:nameLable];
    [cell.contentView addSubview:addressLable];
    [image release];
    [nameLable release];
    [addressLable release];
    return cell;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
//点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"hhhhhhhhhhhhh");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    float a;//纬
    float b;//经
   // NSString * str1;
    //NSString * str2;
    switch (indexPath.section)
    {
        case 0:
            cankaoname = [self.ditieDic objectForKey:@"addr"];
            //参考的经纬度 
            cankaolat = [[self.ditieDic objectForKey:@"lat"] floatValue];
            cankaolon = [[self.ditieDic objectForKey:@"lon"] floatValue];
            
            a = placelat - cankaolat;
            b = placelon - cankaolon;
            //            if (a==0.0||b==0.0) {
            //                cankaomess = [NSString stringWithFormat:@"%@ 当前位置",[self.ditieDic objectForKey:@"addr"],str2,str1];
            //            }
            //            if (a>0.0&&b>0.0) {
            //                str1=@"东北方";
            //                cankaomess = [NSString stringWithFormat:@"%@ %@%@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],str1,[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"dist"]];
            //            }
            //            else if(a>0.0&&b<0.0)
            //            {
            //                str1=@"西北方";
            //                cankaomess = [NSString stringWithFormat:@"%@ %@%@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],str1,[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"dist"]];
            //            }
            //            else if(a>0.0&&b==0.0)
            //            {
            //                str1=@"正北方";
            //                cankaomess = [NSString stringWithFormat:@"%@ %@%@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],str1,[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"dist"]];
            //            }
            //            else if(a<0.0&&b>0.0)
            //            {
            //                str1=@"东南方";
            //                cankaomess = [NSString stringWithFormat:@"%@ %@%@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],str1,[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"dist"]];
            //            }
            //            else if(a<0.0&&b<0.0)
            //            {
            //                str1=@"西南方";
            //                cankaomess = [NSString stringWithFormat:@"%@ %@%@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],str1,[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"dist"]];
            //            }
            //            else if(a<0.0&&b==0.0)
            //            {
            //                str1=@"正南方";
            //                cankaomess = [NSString stringWithFormat:@"%@ %@%@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],str1,[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"dist"]];
            //            }
            //            else if(a==0.0&&b>0.0)
            //            {
            //                str1=@"正西方";
            //               cankaomess = [NSString stringWithFormat:@"%@ %@%@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],str1,[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"dist"]];
            //                
            //            }else if(a==0.0&&b<0.0)
            //            {
            //                str1=@"正东方";
            //               cankaomess = [NSString stringWithFormat:@"%@ %@%@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],str1,[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"dist"]];
            //            }
            //            else if(a==0.0&&b==0.0)
            //            {
            //                str1=@"0米";
            //                cankaomess = [NSString stringWithFormat:@"%@ %@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],str1];
            //            }
            //            
            cankaomess = [NSString stringWithFormat:@"%@ %@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],[self jisuanFangwei:placelat andlon:placelon andcankaolat:cankaolat andcnakaolon:cankaolon]];
            //            if (a > 0.0) {
            //                str1 = @"北";
            //            }
            //            else if(a < 0.0){
            //                str1 = @"南";
            //            }
            //            else 
            //                if(a==0.0)
            //            {
            //                str1 = @"位置";
            //            }
            //            if (b > 0.0) {
            //                str2 = @"东";
            //            }
            //            else if(b < 0.0){
            //                str2 = @"西";
            //            }
            //            else if(b==0.0)
            //            {
            //                str2 = @"当前";
            //            }
            //            cankaomess = [NSString stringWithFormat:@"%@ %@%@方%@",[self.ditieDic objectForKey:@"addr"],str2,str1,[self.ditieDic objectForKey:@"dist"]];
            
            break;
            
        case 1:
            cankaoname = [[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"];
            //参考的经纬度 
            cankaolat = [[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"lat"] floatValue];
            cankaolon = [[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"lon"] floatValue];
            
            a = placelat - cankaolat;
            b = placelon - cankaolon;
            //            if (a==0.0||b==0.0) {
            //                cankaomess = [NSString stringWithFormat:@"%@ 当前位置",[self.ditieDic objectForKey:@"addr"],str2,str1];
            //            }
            //            if (a>0.0&&b>0.0) {
            //                str1=@"东北方";
            //                cankaomess = [NSString stringWithFormat:@"%@ %@%@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],str1,[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"dist"]];
            //            }
            //            else if(a>0.0&&b<0.0)
            //            {
            //                str1=@"西北方";
            //                cankaomess = [NSString stringWithFormat:@"%@ %@%@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],str1,[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"dist"]];
            //            }
            //            else if(a>0.0&&b==0.0)
            //            {
            //                str1=@"正北方";
            //                cankaomess = [NSString stringWithFormat:@"%@ %@%@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],str1,[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"dist"]];
            //            }
            //            else if(a<0.0&&b>0.0)
            //            {
            //                str1=@"东南方";
            //                cankaomess = [NSString stringWithFormat:@"%@ %@%@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],str1,[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"dist"]];
            //            }
            //            else if(a<0.0&&b<0.0)
            //            {
            //                str1=@"西南方";
            //                cankaomess = [NSString stringWithFormat:@"%@ %@%@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],str1,[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"dist"]];
            //            }
            //            else if(a<0.0&&b==0.0)
            //            {
            //                str1=@"正南方";
            //                cankaomess = [NSString stringWithFormat:@"%@ %@%@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],str1,[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"dist"]];
            //            }
            //            else if(a==0.0&&b>0.0)
            //            {
            //                str1=@"正西方";
            //                cankaomess = [NSString stringWithFormat:@"%@ %@%@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],str1,[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"dist"]];
            //                
            //            }else if(a==0.0&&b<0.0)
            //            {
            //                str1=@"正东方";
            //                cankaomess = [NSString stringWithFormat:@"%@ %@%@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],str1,[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"dist"]];
            //            }
            //
            //            else if(a==0.0&&b==0.0)
            //            {
            //                str1=@"0米";
            //                cankaomess = [NSString stringWithFormat:@"%@ %@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],str1];
            //            }
            
            cankaomess = [NSString stringWithFormat:@"%@ %@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],[self jisuanFangwei:placelat andlon:placelon andcankaolat:cankaolat andcnakaolon:cankaolon]];
            //            if (a > 0.0) {
            //                str1 = @"北";
            //            }
            //            else if(a < 0.0){
            //                str1 = @"南";
            //            }
            //            else if(a==0.0){
            //            str1 = @"位置";
            //            }
            //            if (b > 0.0) {
            //                str2 = @"东";
            //            }
            //            else if(b < 0.0){
            //                str2 = @"西";
            //            }
            //            else if(b==0.0){
            //                str2 = @"当前";
            //            }
            //            cankaomess = [NSString stringWithFormat:@"%@ %@%@方%@",[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"name"],str2,str1,[[self.messArray objectAtIndex:indexPath.row] objectForKey:@"dist"]];
            
            break;
            
        default:
            break;
    }
    [delegate dailiChuanMessing:cankaomess Cankaoname:cankaoname andCankaomess:cankaomess andCankaolat:cankaolat andCankaolon:cankaolon];
    [self goBack:nil];
}
//计算两经纬度之间的距离

- (void)viewDidUnload
{
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
//返回按钮
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc {
    [fangwei release];
    [myTableView release];
    [super dealloc];
}
//- (void)viewWillDisappear:(BOOL)animated
//{
//	[super viewWillDisappear:animated];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
@end
