//
//  DataBase.h
//  MySQL
//
//  Created by cyy on 11-8-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 此类用于打开以及关闭数据库
 
 数据库做成了一个单例，方便频繁操作数据库
 */

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DataBase : NSObject 


//open the database
+(sqlite3 *)openDB;

//close the database
+(void) closeDB;
@end
