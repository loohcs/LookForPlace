//
//  MyDanLi.m
//  LookForPlace
//
//  Created by ibokan on 12-1-9.
//  Copyright 2012年 ibokanwisdom. All rights reserved.
//

#import "MyDanLi.h"
#import "MSearch.h"
//#import "Head_import.h"
#import "DingweiViewController.h"
#import "PlaceData.h"

@implementation NSString(Uincode)

+(NSString *) stringWithUniCode:(char *) str Length:(int) length;
{
    
    unsigned char temp= 0;
    for (int i =0; i<length/2; i++) {
        if (str[i*2]=='\0') {
            continue;
        }
        
        //取第二个字符与第一个字符交换
        temp = str[i*2];
        str[i*2] = str[i*2+1];
        str[i*2+1] = temp;
        
        
    }
    
    NSData * newData = [NSData dataWithBytes:str length:length];     
    NSString * string = [[[NSString alloc] initWithData:newData encoding:NSUnicodeStringEncoding] autorelease];
    return string;
    
}


@end


@implementation MyDanLi
@synthesize dingwei,array2,lon,lat;
static MyDanLi *danliDingWei=nil;

-(void)searchBarString:(NSString *)searchString
{
   
    MSearch* search = [MSearch MSearchWithKey:_USERKEY delegate:self];
    
    MPOISEARCHOPTIONS options1;
    options1.lRecordsPerPage=20;
    options1.lPageNum=1;
    //options1.lPageNum=2;
    [search PoiSearchByKeywords:searchString City:@"*" Options:options1];

//    MLONLAT poi;
//    poi.X=39.984874;
//    poi.Y=116.304536;
//    MREGEOCODESEARCHOPTIONS options2;
//    [search PoiToAddressByPoi:poi Options:options2];
}



-(void) PoiSearchResponse:(MPOISEARCHRESULT*)info
{
    NSMutableString *caddress = nil;
    NSMutableString *cname = nil;
    NSNumber * x = nil;
    NSNumber * y = nil;
    NSMutableArray *array3=[[NSMutableArray alloc] init];
    self.array2=array3;
    [array3 release];
    
    if(info == NULL)
    {
       
        [self.dingwei.dictableV setFrame:CGRectMake(0, -436, 320, 370)];
        [self.dingwei.actiIndicator stopAnimating];
        [self.dingwei errorWithNoPlace];
        return;
    }
    
   

    MPOI *pPois1=info->pPois;
    for (int i=0; i<info->lNum; i++) 
    {
        NSRegularExpression *regularexpression = [[NSRegularExpression alloc] initWithPattern:@"^[\u4e00-\u9fa5]{1}" options:NSRegularExpressionCaseInsensitive error:nil];
        
        NSRegularExpression *regularexpression1 = [[NSRegularExpression alloc] initWithPattern:@"^[0-9]{1}" options:NSRegularExpressionCaseInsensitive error:nil];
//        NSLog(@"%@%@%@",@"aaaa",pPois1->cAddress,@"aaaa"); ??
//        caddress = [NSString stringWithUniCode:(char *)pPois1->cAddress Length:sizeof(pPois1->cAddress)];
        NSString *caddress1 = [NSString stringWithUniCode:(char *)pPois1->cAddress Length:sizeof(pPois1->cAddress)];

        NSMutableArray * array = [[NSMutableArray alloc] init];
        int length=[caddress1 length];
        for (int i=0; i<length; i++) {
            // NSString * c=[mytimestr characterAtIndex:i];
            NSString *STR  = [caddress1 substringWithRange:NSMakeRange( i, 1)] ;
            //NSLog(@"%@",STR);
            NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:STR options:NSMatchingReportProgress range:NSMakeRange(0, STR.length)];
            NSUInteger numberofMatch1 = [regularexpression1 numberOfMatchesInString:STR options:NSMatchingReportProgress range:NSMakeRange(0, STR.length)];
            if (numberofMatch > 0 || numberofMatch1 > 0) {
                [array addObject:STR];
            }
        }
        caddress = [[NSMutableString alloc] init];
        for (int i = 0; i < [array count]; i++) {
            [caddress insertString:[array objectAtIndex:i] atIndex:i];
        }
        NSLog(@"caddress = %@",caddress);
//        NSLog(@"array = %@",array);
//        NSLog(@"array.count = %d",[array count]);
        
        if ([caddress1 characterAtIndex:0] == '\0') {}
        else
        {
//            cname=[NSString stringWithUniCode:(char *)pPois1->cName Length:sizeof(pPois1->cName)];
           NSString * cname1=[NSString stringWithUniCode:(char *)pPois1->cName Length:sizeof(pPois1->cName)];
//            cname=[NSString stringWithUniCode:(char *)pPois1->cName Length:10];
//            cname = @"博看";
            NSMutableArray * array1 = [[NSMutableArray alloc] init];
            int length1=[cname1 length];
            for (int i=0; i<length1; i++) {
                // NSString * c=[mytimestr characterAtIndex:i];
                NSString *STR  = [cname1 substringWithRange:NSMakeRange( i, 1)] ;
                //NSLog(@"%@",STR);
                NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:STR options:NSMatchingReportProgress range:NSMakeRange(0, STR.length)];
                NSUInteger numberofMatch1 = [regularexpression1 numberOfMatchesInString:STR options:NSMatchingReportProgress range:NSMakeRange(0, STR.length)];
                if (numberofMatch > 0 || numberofMatch1 > 0) {
                    [array1 addObject:STR];
                }
            }
            cname = [[NSMutableString alloc] init];
            for (int i = 0; i < [array1 count]; i++) {
                [cname insertString:[array1 objectAtIndex:i] atIndex:i];
            }
            NSLog(@"caddress = %@",caddress);

           
            y=[NSNumber numberWithFloat:pPois1->X];
            x=[NSNumber numberWithFloat:pPois1->Y];
            
           

            
            NSArray *basePoint = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f",self.lat],[NSString stringWithFormat:@"%f",self.lon], nil];
            if([x floatValue] != 0)
            {
                PlaceData *p = [PlaceData GPSPointWithX:x Y:y basePoint:basePoint cname:cname caddress:caddress];
//                NSLog(@"p.cname = %@",p.cname);
//                NSLog(@",p.caddress = %@",p.caddress);
                [array2 addObject:p];
            }
        }
        pPois1++;
    }
   
    [array2 sortUsingSelector:@selector(compare:)];
   
     PlaceData *place1;
    for (int i = 0; i < [array2 count]; i++) {
       
    
        place1=[array2 objectAtIndex:i];
       
    }
    
    if([array2 count] == 0)
    {
        [self.dingwei.dictableV setFrame:CGRectMake(0, -436, 320, 370)];
        [self.dingwei.actiIndicator stopAnimating];
        [self.dingwei errorWithNoPlace];
    }
    else
    {
        [self.dingwei chuanDGuanjianxinxidic:array2];
    }
}

+(MyDanLi *)dingWeiVC
{
    @synchronized(self)
    {
        if (danliDingWei==nil) 
        {
            danliDingWei=[[MyDanLi alloc] init];
        }
    }
    return danliDingWei;
}
-(void)dealloc
{
    [array2 release];
    [dingwei release];
    //[searchstring release];
    [super release];
}
@end
