//
//  PlaceMessage.h
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-7.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceMessage : NSObject
{
    NSMutableArray *stuArray;
}

@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,retain) NSString * placeName;
@property (nonatomic,assign) double placeLat;
@property (nonatomic,assign) double placeLon;
@property (nonatomic,retain) NSString * placeMess;
@property (nonatomic,retain) NSString * cankaoName;
@property (nonatomic,assign) double cankaoLat;
@property (nonatomic,assign) double cankaoLon;
@property (nonatomic,retain) NSString * cankaoMess;
@property (nonatomic,retain) NSString * baocunName;
@property (nonatomic,retain) NSString * imageData;
@property (nonatomic,retain) NSString * fujiaXinxi;
@property (nonatomic,assign) NSMutableArray *stuArray;
//初始化
-(id) initWhithID:(int) theID andplaceName:(NSString *) theplaceName 
      andplaceLat:(double) theplaceLat andplaceLon:(double) theplaceLon
    andcankaoName:(NSString *) thecankaoName andcankaoLat:(double) thecankaoLat
     andcankaoLon:(double) thecankaoLon andplaceMess:(NSString *) theplaceMess
    andcankaoMess:(NSString *) thecankaoMess andbaocunName:(NSString *) thebaocunName andimageData:(NSString *) theimageData andfujiaXinxi:(NSString *) thefujiaXinxi;
//以下是数据库操作//

//查找表中所有信息
+(NSMutableArray *)findAll;

//判断名字是否一样
//-(void)isEuequelBaocunname:(NSString *)sender;

//判断名字是否正确
+(BOOL) isStudentExistWithName:(NSString *)aName;

//查看标中有多少条信息
+(int) count;

//查找学号为 theID 的学生
//+(PlaceMessage *)findStudentByID:(int) theID;
//
////查找姓名为 theName 的学生
//+(NSMutableArray *) findStudentByName:(NSString *)theName;
//
//添加新的信息 返回值用来标识是否成功
+(int) addPlaceWhithplaceName:(NSString *)theplaceName andplaceLat:(double) theplaceLat andplaceLon:(double) theplacelon andcankaoName:(NSString *) thecankaoName andcankaoLat:(double) thecankaolat andcankaoLon:(double) thecankaoLon andplaceMess:(NSString *) theplaceMess andcankaoMess:(NSString *)thecankaoMess andbaocunName:(NSString *) thebaocunName andimageData:(NSString *) theimageData andfujiaXinxi:(NSString *) thefujiaXinxi;

//修改
+(int) updatetplaceName:(NSString *)theplaceName andplaceLat:(double) theplaceLat andplaceLon:(double) theplaceLon andcankaoName:(NSString *) thecankaoName andcankaoLat:(double) thecankaoLat andcankaoLon:(double) thecankaoLon andplaceMess:(NSString *) theplaceMess andcankaoMess:(NSString *) thecankaoMess andbaocunName:(NSString *) thebaocunName andimageData:(NSString *) theimageData andfujiaXinxi:(NSString *) thefujiaXinxi fromID:(int) ID;
//
//删除
+(int) deletePlaceID:(NSInteger) theID;

@end
