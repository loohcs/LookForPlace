    //
//  CustomTabBarController.m
//  TestTabbar]
//
//  Created by zuo jianjun on 11-7-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTabBar.h"


@implementation CustomTabBar
@synthesize buttons;
@synthesize slideView;
@synthesize currentSelectedIndex;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    nameArr = [[NSArray alloc]initWithObjects:@"图标11.png",@"图标12.png",@"图标13.png",@"图标14.png", nil];
//    NSString * str = [nameArr objectAtIndex:self.selectedIndex];
//    slideView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 49)]; //加载滑动视图
//    slideView.image = [UIImage imageNamed:str];
//	[self hidesTabBar];
//	[self customTabBar];
}

-(void) changePick
{
    nameArr = [[NSArray alloc]initWithObjects:@"图标11.png",@"图标12.png",@"图标13.png",@"图标14.png", nil];
    NSString * str = [nameArr objectAtIndex:self.selectedIndex];
    slideView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 49)]; //加载滑动视图
    slideView.image = [UIImage imageNamed:str];
	[self hidesTabBar];
	[self customTabBar];
}
//-(id) init
//{
//    if((self = [super init])) {
//        nameArr = [[NSArray alloc]initWithObjects:@"图标11.png",@"图标12.png",@"图标13.png",@"图标14.png", nil];
//        NSString * str = [nameArr objectAtIndex:self.selectedIndex];
//        slideView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 49)]; //加载滑动视图
//        slideView.image = [UIImage imageNamed:str];
//        [self hidesTabBar];
//        [self customTabBar]; 
//    }
//    return self;
//}
//隐藏TabBar所在的视图
-(void) hidesTabBar
{
	for (UIView * view in self.view.subviews)//便利self.view上的子视图 
	{
		if ([view isKindOfClass:[UITabBar class]] )//判断self.view上的子视图是否是tabbar所在的视图，若是则隐藏tabbar所在的视图
		{
			view.hidden = YES;
			break;
		}
	}
}

-(void) customTabBar
{
	///向TabBar添加背景色或者图片
	UIView * tabBarBackgroundView = [[UIView alloc] 
									 initWithFrame:
									 self.tabBar.frame];
	UIColor * color = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"标题栏背景.png"]];
	[tabBarBackgroundView setBackgroundColor:color];
	[color release];
	//将tabBarBackGroundView加载到self.view上去
	[self.view insertSubview:tabBarBackgroundView atIndex:1];
	
	//将滚动视图加载到tabBarBackGroundView上去

	//创建button
	int viewCount = self.viewControllers.count > 5 ? 5:self.viewControllers.count;
	//button的数量
	self.buttons = [NSMutableArray arrayWithCapacity:viewCount];

	//button的宽
	double width = 320/viewCount;
	//button的高
	double height = self.tabBar.frame.size.height;
	//遍历viewController的视图  并加载button
	for (int i=0; i<viewCount; i++) 
	{
		//UIViewController * viewController = [self.viewControllers objectAtIndex:i];
		UIButton * button = [UIButton buttonWithType:
							 UIButtonTypeCustom];
		button.frame = CGRectMake(width*i, 0, width, height);
		[button addTarget:self action:@selector(selectedTabBarItem:) forControlEvents:UIControlEventTouchUpInside];
		button.tag = i;
		UILabel*label = [[UILabel alloc] initWithFrame:CGRectMake(0,height-22, width, height-22)];
		[label setBackgroundColor:[UIColor clearColor]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"图标%d.png",i+1]];
          NSLog(@"imagView.image111 = %d",button.tag+1);
        [button addSubview:imageView];
        [imageView release];
        if (i == 0) {
            [label setText:@"我的收藏"];
        }
        else if(i == 1) {
            [label setText:@"自选位置"];
        }
        else if(i == 2) {
            [label setText:@"当前位置"];
        }
        else{
            [label setText:@"更多"];
        }
        label.textColor = [UIColor colorWithRed:77/255.0 green:36/255.0 blue:21/255.0 alpha:1.0];
		[label setFont:[UIFont systemFontOfSize:12.0]];//改变字体大小
		[label setTextAlignment:UITextAlignmentCenter];//字体中间对齐
		[button addSubview:label];
		[label release];
		
		[self.buttons addObject:button];
		[tabBarBackgroundView addSubview:button];
//        [tabBarBackgroundView addSubview:slideView];
	}
	[tabBarBackgroundView release];
	[self selectedTabBarItem:[self.buttons objectAtIndex:self.selectedIndex]];
}
-(void) selectedTabBarItem:(UIButton *) button
{
    NSLog(@"imagView.image222 = %d",button.tag+1);
    if ([imagView superview]) {
        [imagView removeFromSuperview];
    }
    if ([lab superview]) {
        [lab removeFromSuperview];
    }
    int i = button.tag; 
    float width = button.frame.size.width;
    float height = button.frame.size.height;
    self.currentSelectedIndex = button.tag;
    self.selectedIndex = self.currentSelectedIndex;
    [self performSelector:@selector(slideTabBarItem:) withObject:imagView];
	if (self.currentSelectedIndex ==i) {
        
        imagView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        
        imagView.image = [UIImage imageNamed:[NSString stringWithFormat:@"图标1%d.png",button.tag+1]];
        
        [button addSubview:imagView];
        [imagView release];
        lab = [[UILabel alloc] initWithFrame:CGRectMake(0,height-22, width, height-22)];
        if (i == 0) {
            [lab setText:@"我的收藏"];
        }
        else if(i == 1) {
            [lab setText:@"自选位置"];
        }
        else if(i == 2) {
            [lab setText:@"当前位置"];
        }
        else{
            [lab setText:@"更多"];
        }
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = [UIColor whiteColor];
		[lab setFont:[UIFont systemFontOfSize:12.0]];//改变字体大小
		[lab setTextAlignment:UITextAlignmentCenter];//字体中间对齐
		[button addSubview:lab];
        [lab release];
	}
    for (int n=0; n<[self.viewControllers count]; n++) {
        if (n != i) {
            [[self.viewControllers objectAtIndex:n] popToRootViewControllerAnimated:NO];
        }
    }

}

-(void) slideTabBarItem:(UIImageView *) button
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:0.2];
	[UIView setAnimationDelegate:self];
//	slideView.frame = button.frame;//将被点击按钮的frame赋值给tabBarView的frame，使滑动视图移到被点击的按钮上
	[UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[slideView release];
	[buttons release];
    [super dealloc];
}


@end
