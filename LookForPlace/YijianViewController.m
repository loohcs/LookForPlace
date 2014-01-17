//
//  YijianViewController.m
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-11.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import "YijianViewController.h"
#import "URLEncode.h"
#import "JSON.h"
@implementation YijianViewController
@synthesize zishuLable;
@synthesize textView1;
@synthesize youxianText;


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
    // Do any additional setup after loading the view from its nib.
//    UIColor * aColor  = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"木纹背景.png"]];
//    self.view.backgroundColor = aColor;
//    [aColor release];
    UIImageView *aImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"木纹背景.png"]];
    [aImageView setFrame:self.view.bounds];
    [self.view insertSubview:aImageView atIndex:0];
    [aImageView release];
    UIImageView *bImageView=[[UIImageView alloc] initWithFrame:CGRectMake(25, 101, 273, 132)];
    [bImageView setImage:[UIImage imageNamed:@"意见输入框.png"]];
    [self.view insertSubview:bImageView belowSubview:textView1];
    textView1.backgroundColor = [UIColor clearColor];
//    UIColor * bColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"意见输入框.png"]];
//    
//    self.textView.backgroundColor = bColor;
//    [bColor release];
    //self.textView.returnKeyType = UIReturnKeyDone;
    self.youxianText.returnKeyType = UIReturnKeyDone;
    self.zishuLable.text = @"还可以输入500字";
    
    //放置隐藏键盘的按钮
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,480,320,44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem * hiddenButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jianpan.png"] style:UIBarButtonItemStylePlain target:self action:@selector(HiddenKeyBoard)];
    UIBarButtonItem * spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar.items = [NSArray arrayWithObjects:spaceButtonItem,hiddenButtonItem,nil];
    [self.view addSubview:toolBar];
    [toolBar release];
    //监控键盘消失
    self.youxianText.inputAccessoryView = toolBar;
    self.textView1.inputAccessoryView=toolBar;
//    //监控键盘
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardDidShowNotification object:nil];
//    //监控键盘消失
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
    self.youxianText.frame = CGRectMake(25, 260, 273, 31);
    [dingweilable setTextColor:[UIColor colorWithRed:0.250 green:0.082 blue:0.003 alpha:1]];
}
-(void) HiddenKeyBoard
{
    //[textView1 setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.3];
    [self.textView1 resignFirstResponder];
    [youxianText resignFirstResponder];
    toolBar.frame = CGRectMake(0, 480, 320, 44);
    self.view.frame=CGRectMake(0, 0, 320, 480);
    self.youxianText.frame = CGRectMake(25, 260, 273, 31);
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
//监控键盘的方法
-(void)keyboardWillHide:(NSNotification*)notification{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [textView1 setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    toolBar.frame = CGRectMake(0, 480, 320, 44);
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //        self.view.center = CGPointMake(x,y)
    float width=self.view.frame.size.width;
    float height=self.view.frame.size.height;
    CGRect rect=CGRectMake(0,-120,width,height);//上移80个单位，按实际情况设置
    self.view.frame=rect;
    // self.textView.frame=CGRectMake(25, 20, self.textView.frame.size.width, self.textView.frame.size.height);
    [UIView commitAnimations];
    
    self.youxianText.frame = CGRectMake(25, 260, 273, 31);
    return YES;}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [textView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width=self.view.frame.size.width;
    float height=self.view.frame.size.height;
    CGRect rect=CGRectMake(0,-70,width,height);//上移80个单位，按实际情况设置
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width=self.view.frame.size.width;
    float height=self.view.frame.size.height;
    CGRect rect=CGRectMake(0,0,width,height);//上移80个单位，按实际情况设置
    self.view.frame=rect;
    [UIView commitAnimations];
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //        self.view.center = CGPointMake(x,y)
    float width=self.view.frame.size.width;
    float height=self.view.frame.size.height;
    CGRect rect=CGRectMake(0,0,width,height);//上移80个单位，按实际情况设置
    self.view.frame=rect;
    //self.textView.frame=CGRectMake(25, 101, self.textView.frame.size.width, self.textView.frame.size.height);
    [UIView commitAnimations];
    
    toolBar.frame = CGRectMake(0, 480, 320, 44);
    self.youxianText.frame = CGRectMake(25, 260, 273, 31);
    [self.youxianText resignFirstResponder];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    int a = 500 - self.textView1.text.length;
    NSNumber * aNum = [[NSNumber alloc] initWithInt:a];
    self.zishuLable.text = [NSString stringWithFormat:@"还可以输入%@字",aNum];
    if (a == 0) {
        [self.textView1 resignFirstResponder];
    }
    [aNum release];
}

- (void)viewDidUnload
{
    [self setZishuLable:nil];
    [self setTextView1:nil];
    [self setYouxianText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backButton:(id)sender {
    
        [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)tijiaoButton:(id)sender {
//    NSString * str = [NSString stringWithFormat:@"http://eecod.com/debug/map.php?act=jiepang&dev=ios&ver=1.0&long=116.306270&lat=39.9756380"]; 
//    NSURL *url = [NSURL URLWithString:str];  
//    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];  
//   // [req addValue:@“text/xml; charset=utf-8” forHTTPHeaderField:@“Content-Type”];  
//    //[req addValue:0 forHTTPHeaderField:@“Content-Length”];  
//    [req setHTTPMethod:@"get"];  
//    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];  
//    if (conn) {  
//        webData = [[NSMutableData data] retain];  
//    }  

    //一个判断是否是邮箱的正则表达式 
	NSRegularExpression *regularexpression = [[NSRegularExpression alloc] initWithPattern:@"[a-zA-Z0-9]+@[a-zA-Z0-9]+[\\.[a-zA-Z0-9]+]+" options:NSRegularExpressionCaseInsensitive error:nil]; 
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:self.youxianText.text options:NSMatchingReportProgress range:NSMakeRange(0, self.youxianText.text.length)]; 
//http//eecod.com/debug/map.php?act=advise&dev=ios&ver=1.1&email=lamasery@gmail.com&advise=urlencode(建议的内容)	//urlencode(建议的内容) 需要编码 		  
    if (numberofMatch > 0) {
        NSString *postString =[NSString stringWithFormat:@"act=advise&dev=ios&ver=1.1&email=%@&advise=%@",self.youxianText.text,[URLEncode encodeUrlStr:self.textView1.text]];   
        NSURL *url = [NSURL URLWithString:@"http://www.hylinkad.com/mirror/map/map.php"];    
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];       
        [req setHTTPMethod:@"POST"]; 
        [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];   
        conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];  
        if (conn) {    
            webData = [[NSMutableData data] retain];    
        } 
        UIAlertView *successAlert=[[UIAlertView alloc] initWithTitle:nil message:@"感谢您的宝贵意见！"delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [successAlert show];
        [successAlert release];
    }
    else{
        UIAlertView *successAlert=[[UIAlertView alloc] initWithTitle:nil message:@"您输入的邮箱不正确！"delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [successAlert show];
        [successAlert release];
    }
}

- (IBAction)getBack:(id)sender {
}

- (IBAction)ress:(id)sender {
    
    toolBar.frame = CGRectMake(0, 480, 320, 44);
    self.youxianText.frame = CGRectMake(25, 260, 273, 31);
    [self.textView1 resignFirstResponder];
    [self.youxianText resignFirstResponder];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString * str = [NSString stringWithCString:[webData bytes] encoding:NSASCIIStringEncoding];
    NSLog(@"strqqqqqq = %@",str);

}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}
- (void)dealloc {
    [zishuLable release];
    [textView1 release];
    [youxianText release];
    [super dealloc];
}
@end
