//
//  Database.m
//  AirsoftManager
//
//  Created by Paul Bizouard on 15/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import "Database.h"

static Database *sharedDatabase;

@implementation Database

@synthesize sharedDatabase;
@synthesize databasePath, databaseName, database;

#pragma mark -
#pragma mark Singleton Methods

+(Database *)sharedDatabase {
    if (sharedDatabase == nil)
    {
        sharedDatabase = [[super allocWithZone:NULL] init];
        [sharedDatabase initDatabase];
    }
    return (sharedDatabase);
}

-(sqlite3 *)getDatabase {
    if (self.database == nil)
    {
        sqlite3_open([databasePath UTF8String], &database);
    }
    return self.database;
}

-(void)closeDatabase {
    if (self.database != nil)
    {
        sqlite3_close(self.database);
    }
}

-(void) checkAndCreateDatabase {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *sqlStatement;
    char *error;
    
    if (![fileManager fileExistsAtPath:databasePath])
    {
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    }
    
    [self getDatabase];
        /**
         * Players
         */
        sqlStatement = @"DROP TABLE IF EXISTS player";
        if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
            NSLog(@"KO Drop player, %s", error);
        
        sqlStatement = @"CREATE TABLE IF NOT EXISTS player (id INTEGER PRIMARY KEY, name VARCHAR(50), team VARCHAR(50))";
        if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
            NSLog(@"KO Create table player, %s", error);
        
        /**
         * Replica
         */
        sqlStatement = @"DROP TABLE IF EXISTS replica";
        if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
            NSLog(@"KO Drop replica, %s", error);
        
        sqlStatement = @"CREATE TABLE IF NOT EXISTS replica (id INTEGER PRIMARY KEY, id_player INTEGER, name VARCHAR(50), velocity INTEGER)";
        if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
            NSLog(@"KO Create table replica, %s", error);
        
        sqlStatement = @"DROP INDEX IF EXISTS replica.IDX_ID_PLAYER";
        if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
            NSLog(@"KO Rm index, %s", error);
        
        sqlStatement = @"CREATE INDEX IDX_ID_PLAYER ON replica (id_player)";
        if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
            NSLog(@"KO Add index, %s", error);
        
        
        /**
         * Insert
         */
        sqlStatement = @"INSERT INTO player (name, team) VALUES ('name1', 'team'), ('name2', 'team'), ('name3', 'team')";
        if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
            NSLog(@"KO Insert player, %s", error);
        sqlStatement = @"INSERT INTO replica (id_player, name, velocity) VALUES (1, 'name1', 'team'), (1, 'name2', 'team'), (2, 'name3', 'team')";
        if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
            NSLog(@"KO Insert player, %s", error);
        
    
}

-(void)initDatabase {
    databaseName = @"AirsoftManager.sql";
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    
    [self checkAndCreateDatabase];
}

@end
