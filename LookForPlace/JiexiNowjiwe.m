//
//  JiexiNowjiwe.m
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-23.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import "JiexiNowjiwe.h"
#import "JSON.h"
@implementation JiexiNowjiwe
@synthesize delegate;
@synthesize request1;
-(void) getUrl:(NSURL *) url
{
    NSURLRequest * aRequest = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    self.request1=aRequest;
    conn = [[NSURLConnection alloc] initWithRequest:aRequest delegate:self];  
    if (conn) {    
        aData = [[NSMutableData data] retain];    
    } 
    [aRequest release];
}

//解析代理
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    aData = [[NSMutableData alloc] init];
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[aData appendData:data];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString * jsonStr = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
    NSDictionary * dicMessage = [jsonStr JSONValue];
    [delegate chuanNowjinwei:dicMessage];
    [aData release];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"自选页面重新链接长按位置");
    conn = [[NSURLConnection alloc] initWithRequest:request1 delegate:self];  
    if (conn) {    
        aData = [[NSMutableData data] retain];    
    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//	[alert show];
//	[alert release];
}
-(void)dealloc
{
    [request1 release];
}
@end
