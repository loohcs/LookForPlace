//
//  JiexiDitie.m
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-18.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import "JiexiDitie.h"
#import "JSON.h"
@implementation JiexiDitie
@synthesize delegate;
-(void) getDitieUrl:(NSURL *) url post:(NSString *)str
{
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];       
    [req setHTTPMethod:@"POST"]; 
    [req setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];   
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];  
    if (conn) {    
        webData = [[NSMutableData data] retain];    
    } 
}
//解析代理
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (conn == connection) {
        [webData appendData:data];
    }	
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (conn == connection) {
        NSString * jsonStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSDictionary * dict = [jsonStr JSONValue];
      
        if ([dict count] > 0) {
            [delegate chuanDitie:dict];
        }
        [webData release];
    }
}

@end
