//
//  Database.h
//  AirsoftManager
//
//  Created by Paul Bizouard on 15/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#ifndef __DEBUG__
#define __DEBUG__ 1
#endif

@interface Database : NSObject {
    NSString *databaseName;
    NSString *databasePath;
    sqlite3 *database;
}

@property (nonatomic, retain) NSString *databaseName;
@property (nonatomic, retain) NSString *databasePath;
@property (nonatomic) sqlite3 *database;

@property (nonatomic, retain) Database *sharedDatabase;

+(Database *)sharedDatabase;

-(void)initDatabase;
-(sqlite3 *)getDatabase;
-(void)closeDatabase;

@end
