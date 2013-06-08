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
    
#if __DEBUG__
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    [fileManager removeItemAtPath:databasePathFromApp error:nil];
#endif

    if (![fileManager fileExistsAtPath:databasePath])
    {
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    }
    
    [self getDatabase];
    /**
     * Players
     */
#if __DEBUG__
    sqlStatement = @"DROP TABLE IF EXISTS player";
    if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
        NSLog(@"KO Drop player, %s", error);
#endif
    
    sqlStatement = @"CREATE TABLE IF NOT EXISTS player (id INTEGER PRIMARY KEY, name VARCHAR(50), team VARCHAR(50))";
    if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
        NSLog(@"KO Create table player, %s", error);
    
    /**
     * Replica
     */
#if __DEBUG__
    sqlStatement = @"DROP TABLE IF EXISTS replica";
    if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
        NSLog(@"KO Drop replica, %s", error);
#endif
    
    sqlStatement = @"CREATE TABLE IF NOT EXISTS replica (id INTEGER PRIMARY KEY, id_player INTEGER, name VARCHAR(50), velocity INTEGER)";
    if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
        NSLog(@"KO Create table replica, %s", error);
    
#if __DEBUG__
    sqlStatement = @"DROP INDEX IF EXISTS replica.IDX_ID_PLAYER";
    if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
        NSLog(@"KO Rm index, %s", error);
#endif
    
    sqlStatement = @"CREATE INDEX IF NOT EXISTS IDX_ID_PLAYER ON replica (id_player)";
    if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
        NSLog(@"KO Add index, %s", error);
    
    /**
     * Games
     */
#if __DEBUG__
    sqlStatement = @"DROP TABLE IF EXISTS game";
    if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
        NSLog(@"KO Drop game, %s", error);
#endif
    
    sqlStatement = @"CREATE TABLE IF NOT EXISTS game (id INTEGER PRIMARY KEY, name VARCHAR(50), `date` DATE)";
    if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
        NSLog(@"KO Create table game, %s", error);
    
    /**
     * Games <> Players
     */
#if __DEBUG__
    sqlStatement = @"DROP TABLE IF EXISTS game_player";
    if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
        NSLog(@"KO Drop game, %s", error);
#endif
    
    sqlStatement = @"CREATE TABLE IF NOT EXISTS game_player (id_game INTEGER, id_player INTEGER, chrony INTEGER, payment INTEGER)";
    if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
        NSLog(@"KO Create table game_player, %s", error);
    
    /*
     sqlStatement = @"DELETE FROM game_player WHERE 1";
    if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
        NSLog(@"KO Create table game_player, %s", error);
    */
    
    /**
     * Insert
     */
#if __DEBUG__
    sqlStatement = @"INSERT INTO player (name, team) VALUES ('Leodi', 'BAT91'), ('Arma', 'BAT91'), ('ZZ', 'Freelance')";
    if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
        NSLog(@"KO Insert player, %s", error);
    sqlStatement = @"INSERT INTO replica (id_player, name, velocity) VALUES (1, 'M16', '350'), (1, 'P90', '330'), (2, 'MP9', '600'), (2, 'Scar L', '330')";
    if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
        NSLog(@"KO Insert player, %s", error);
    sqlStatement = @"INSERT INTO game (name, date) VALUES ('Test', '2013-04-28'), ('Test 2', '2013-05-20'), ('Test 3', '2013-02-20')";
    if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
        NSLog(@"KO Insert game, %s", error);
    sqlStatement = @"INSERT INTO game_player (id_game, id_player) VALUES (1,1),(1,2),(1,3),(2,1),(2,2),(3,1)";
    if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, &error) != SQLITE_OK)
        NSLog(@"KO Insert game_player, %s", error);
#endif
    
}

-(void)initDatabase {
    databaseName = @"AirsoftManager.sql";
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    
    [self checkAndCreateDatabase];
}

@end
