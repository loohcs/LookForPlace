//
//  PlaceMessage.m
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-7.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import "PlaceMessage.h"
#import "DataBase.h"
@implementation PlaceMessage
@synthesize ID,placeName,placeLat,placeLon,placeMess,cankaoName,cankaoLat,cankaoLon,cankaoMess,baocunName,imageData,fujiaXinxi,stuArray;

-(void) dealloc
{
    
    [stuArray release];
    [placeMess release];
    [placeName release];
    [cankaoMess release];
    [cankaoName release];
    [baocunName release];
    [imageData release];
    [fujiaXinxi release];
    [super dealloc];
}
//初始化
-(id) initWhithID:(int) theID andplaceName:(NSString *) theplaceName 
      andplaceLat:(double) theplaceLat andplaceLon:(double) theplaceLon
    andcankaoName:(NSString *) thecankaoName andcankaoLat:(double) thecankaoLat
     andcankaoLon:(double) thecankaoLon andplaceMess:(NSString *) theplaceMess
    andcankaoMess:(NSString *) thecankaoMess andbaocunName:(NSString *) thebaocunName andimageData:(NSString *) theimageData andfujiaXinxi:(NSString *) thefujiaXinxi
{
    if (self == [super init]) {
        ID = theID;
       self.placeName = theplaceName;
        placeLat = theplaceLat;
        placeLon = theplaceLon;
        self.cankaoName = thecankaoName;
        cankaoLat = thecankaoLat;
        cankaoLon = thecankaoLon;
        self.placeMess = theplaceMess;
        self.cankaoMess = thecankaoMess;
        self.baocunName = thebaocunName;
        self.imageData = theimageData;
        self.fujiaXinxi = thefujiaXinxi;
    }
    return self;
}
//查找所有数据 存放到数组中
+(NSMutableArray *)findAll
{
    
    //打开数据库
	sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
        

	//编译sql语句，编译成功的话才能继续进行
	int result = sqlite3_prepare_v2(db, "select * from lookforPlace order by ID desc", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
	{
		//创建一个数组，存放所有的学生
        NSMutableArray *stuArray=[[NSMutableArray alloc] init];
		//stuArray = [[NSMutableArray alloc] init];
		while(SQLITE_ROW == sqlite3_step(stmt))//只要学生表中有数据
		{
			//注意列是从0开始的。
            int placeID = sqlite3_column_int(stmt, 0);
			const unsigned char *placeName = sqlite3_column_text(stmt, 1);
            float placeLat = sqlite3_column_double(stmt, 2);
            float placeLon = sqlite3_column_double(stmt, 3);
			const unsigned char *cankaoName = sqlite3_column_text(stmt, 4);
            float cankaoLat = sqlite3_column_double(stmt, 5);
            float cankaoLon = sqlite3_column_double(stmt, 6);
            const unsigned char *placeMess = sqlite3_column_text(stmt, 7);
            const unsigned char *cankaoMess = sqlite3_column_text(stmt, 8);
            const unsigned char *baocunName = sqlite3_column_text(stmt, 9);
            const unsigned char *imageData = sqlite3_column_text(stmt, 10);
            const unsigned char *fujiaXinxi = sqlite3_column_text(stmt, 11);
            
            
            
            
			PlaceMessage *place = [[PlaceMessage alloc] initWhithID:placeID andplaceName:[NSString stringWithUTF8String:(const char *)placeName] andplaceLat:placeLat andplaceLon:placeLon andcankaoName:[NSString stringWithUTF8String:(const char *)cankaoName] andcankaoLat:cankaoLat andcankaoLon:cankaoLon andplaceMess:[NSString stringWithUTF8String:(const char *)placeMess] andcankaoMess:[NSString stringWithUTF8String:(const char *)cankaoMess] andbaocunName:[NSString stringWithUTF8String:(const char *)baocunName] andimageData:[NSString stringWithUTF8String:(const char *)imageData] andfujiaXinxi:[NSString stringWithUTF8String:(const char *)fujiaXinxi]];
			[stuArray addObject:place];
			[place release];
		}
		sqlite3_finalize(stmt);//结束sql
		return [stuArray autorelease];
	}
	else
	{
		
		sqlite3_finalize(stmt);//结束sql
		return [NSMutableArray array];
	}
}
//判断名字是否正确
+(BOOL) isStudentExistWithName:(NSString *)aName
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    
	//编译sql语句，编译成功的话才能继续进行
	int result = sqlite3_prepare_v2(db, "select count(*) from lookforPlace where baocunname like ?", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
	{
        sqlite3_bind_text(stmt, 1, [aName UTF8String], -1, nil);
        
		if(SQLITE_ROW == sqlite3_step(stmt))//判断学生表中是否有数据
		{
			int count = sqlite3_column_int(stmt, 0);
			sqlite3_finalize(stmt);//结束sql
            BOOL isExist = count > 0 ? YES : NO;
			return isExist;
		}
	}
	else
	{
		
	}
	sqlite3_finalize(stmt);
	return NO;
}

//查找数据总数
+(int) count
{
    //打开数据库
	sqlite3 *db = [DataBase openDB];
	
	sqlite3_stmt *stmt = nil;
	//编译sql语句，编译成功的话才能继续进行
	int result = sqlite3_prepare_v2(db, "select count(*) from lookforPlace", -1, &stmt, nil);
	if(result == SQLITE_OK)//说明sql语句写的无误
	{
		if(SQLITE_ROW == sqlite3_step(stmt))//判断学生表中是否有数据
		{
			int count = sqlite3_column_int(stmt, 0);
			sqlite3_finalize(stmt);//结束sql
			return count;
		}
	}
	else
	{
		
	}
	sqlite3_finalize(stmt);
	return 0;
}
//添加数据
+(int) addPlaceWhithplaceName:(NSString *)theplaceName andplaceLat:(double) theplaceLat andplaceLon:(double) theplacelon andcankaoName:(NSString *) thecankaoName andcankaoLat:(double) thecankaolat andcankaoLon:(double) thecankaoLon andplaceMess:(NSString *) theplaceMess andcankaoMess:(NSString *)thecankaoMess andbaocunName:(NSString *) thebaocunName andimageData:(NSString *) theimageData andfujiaXinxi:(NSString *) thefujiaXinxi
{
    //打开数据库
	sqlite3 *db = [DataBase openDB];
	
	sqlite3_stmt *stmt = nil;
	sqlite3_prepare_v2(db, "insert into lookforPlace(placename,placelat,placelon,cankaoname,cankaolat,cankaolon,placemess,cankaomess,baocunname,imagedata,fujiaxinxi) values(?,?,?,?,?,?,?,?,?,?,?)", -1, &stmt, nil);
	if (theplaceName == NULL) {
        theplaceName = @"";
    }
    if (thecankaoName == NULL) {
        thecankaoName = @"";
    }
    if (theplaceMess == NULL) {
        theplaceMess = @"";
    }
    if (thecankaoMess == NULL) {
        thecankaoMess = @"";
    }
    if (thebaocunName == NULL) {
        thebaocunName = @"";
    }
    if (theimageData == NULL) {
        theimageData = @"";
    }
    if (thefujiaXinxi == NULL) {
        thefujiaXinxi = @"";
    }
	sqlite3_bind_text(stmt,1, [theplaceName UTF8String], -1, nil);
    sqlite3_bind_double(stmt,2, theplaceLat);
    sqlite3_bind_double(stmt,3, theplacelon);
	sqlite3_bind_text(stmt,4, [thecankaoName UTF8String], -1, nil);
    sqlite3_bind_double(stmt,5, thecankaolat);
    sqlite3_bind_double(stmt,6, thecankaoLon);
    sqlite3_bind_text(stmt,7, [theplaceMess UTF8String], -1, nil);
    sqlite3_bind_text(stmt,8, [thecankaoMess UTF8String], -1, nil);
    sqlite3_bind_text(stmt,9, [thebaocunName UTF8String], -1, nil);
    sqlite3_bind_text(stmt,10, [theimageData UTF8String], -1, nil);
    sqlite3_bind_text(stmt,11, [thefujiaXinxi UTF8String], -1, nil);
	int result = sqlite3_step(stmt);
	sqlite3_finalize(stmt);
	return result;
}
//删除
+(int) deletePlaceID:(NSInteger) theID
{
    //打开数据库
	sqlite3 *db = [DataBase openDB];
	
	sqlite3_stmt *stmt = nil;
	sqlite3_prepare_v2(db, "delete from lookforPlace where ID=?", -1, &stmt, nil);
	sqlite3_bind_int(stmt, 1, theID);
	int result = sqlite3_step(stmt);
	sqlite3_finalize(stmt);
    
	return result;
}
//修改
+(int) updatetplaceName:(NSString *)theplaceName andplaceLat:(double) theplaceLat andplaceLon:(double) theplaceLon andcankaoName:(NSString *) thecankaoName andcankaoLat:(double) thecankaoLat andcankaoLon:(double) thecankaoLon andplaceMess:(NSString *) theplaceMess andcankaoMess:(NSString *) thecankaoMess andbaocunName:(NSString *) thebaocunName andimageData:(NSString *) theimageData andfujiaXinxi:(NSString *) thefujiaXinxi fromID:(int) ID
{
	//打开数据库
	sqlite3 *db = [DataBase openDB];
	
	sqlite3_stmt *stmt = nil;
	sqlite3_prepare_v2(db, "update lookforPlace set placename = ?,placelat = ?,placelon = ?,cankaoname = ?,cankaolat = ?,cankaolon = ?,placemess = ?,cankaomess = ?,baocunname = ?,imagedata = ?,fujiaxinxi = ? where ID=?", -1, &stmt, nil);
    if (theplaceName == NULL) {
        theplaceName = @"";
    }
    if (thecankaoName == NULL) {
        thecankaoName = @"";
    }
    if (theplaceMess == NULL) {
        theplaceMess = @"";
    }
    if (thecankaoMess == NULL) {
        thecankaoMess = @"";
    }
    if (thebaocunName == NULL) {
        thebaocunName = @"";
    }
    if (theimageData == NULL) {
        theimageData = @"";
    }
    if (thefujiaXinxi == NULL) {
        thefujiaXinxi = @"";
    }

	sqlite3_bind_text(stmt, 1, [theplaceName UTF8String], -1, nil);
    sqlite3_bind_double(stmt,2, theplaceLat);
    sqlite3_bind_double(stmt,3, theplaceLon);
	sqlite3_bind_text(stmt,4, [thecankaoName UTF8String], -1, nil);
    sqlite3_bind_double(stmt,5, thecankaoLat);
    sqlite3_bind_double(stmt,6, thecankaoLon);
    sqlite3_bind_text(stmt,7, [theplaceMess UTF8String], -1, nil);
    sqlite3_bind_text(stmt,8, [thecankaoMess UTF8String], -1, nil);
    sqlite3_bind_text(stmt,9, [thebaocunName UTF8String], -1, nil);
    sqlite3_bind_text(stmt,10, [theimageData UTF8String], -1, nil);
    sqlite3_bind_text(stmt,11, [thefujiaXinxi UTF8String], -1, nil);
	sqlite3_bind_int(stmt, 12, ID);
	int result = sqlite3_step(stmt);
	sqlite3_finalize(stmt);
   
	return result;
}

@end
