//
//  Game.m
//  AirsoftManager
//
//  Created by Paul Bizouard on 25/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import "Game.h"

static Game *sharedGame = nil;

@implementation Game

#pragma mark -
#pragma mark Singleton Methods

+(Game *)sharedGame {
    if (sharedGame == nil)
    {
        sharedGame = [[super allocWithZone:NULL] init];
    }
    return (sharedGame);
}

-(id)initWithData:(int) i name:(NSString *)n date:(NSDate *)d {
    self.id = i;
    self.name = [n copy];
    self.date = [d copy];
    return self;
}

-(NSArray *)getAllGames {
    sqlite3 *database = [[Database sharedDatabase] getDatabase];
    sqlite3_stmt *compiledStatement;
    NSMutableArray *games = [[NSMutableArray alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter  setDateFormat:@"yyyy-MM-dd"];
    
    if (sqlite3_prepare_v2(database, "SELECT id, name, date FROM game", -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            int l_id = sqlite3_column_int(compiledStatement, 0);
            NSString *l_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            NSDate *l_date = [formatter dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)]];
            
            Game *game = [[Game alloc] initWithData:l_id name:l_name date:l_date];
            [game getPlayers];
            [games addObject:game];
        }
    }
    sqlite3_finalize(compiledStatement);
    [games sortUsingComparator:^ NSComparisonResult(Game *g1, Game *g2) {
        return [g1.date compare:g2.date];
    }];
    return games;
}

-(void)getPlayers {
    self.players = [[NSMutableArray alloc] init];
  //  self.players = [[NSMutableArray alloc] initWithArray:[Player getAllPlayersFromGame:self.id]];
}

-(void)save {
    sqlite3 *database = [[Database sharedDatabase] getDatabase];
    sqlite3_stmt *stmt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter  setDateFormat:@"yyyy-MM-dd"];
    
    const char * query = "INSERT OR REPLACE INTO game (id, name, date) VALUES (?,?,?)";
    if (sqlite3_prepare_v2(database, query, -1, &stmt, NULL) != SQLITE_OK)
        NSLog(@"Error sqlite prepare update [%s]", sqlite3_errmsg(database));
    if ([self id] != 0)
        sqlite3_bind_int(stmt, 1, [self id]);
    sqlite3_bind_text(stmt, 2, [[self name] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, [[formatter stringFromDate:[self date]] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    if ([self id] == 0)
        self.id = sqlite3_last_insert_rowid(database);
}

-(void)delete {
    sqlite3 *database = [[Database sharedDatabase] getDatabase];
    sqlite3_stmt *stmt;
    const char * query;
    
    query = "DELETE FROM game WHERE id=?";
    if (sqlite3_prepare_v2(database, query, -1, &stmt, NULL) != SQLITE_OK)
        NSLog(@"Error sqlite prepare update [%s]", sqlite3_errmsg(database));
    sqlite3_bind_int(stmt, 1, [self id]);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

@end
