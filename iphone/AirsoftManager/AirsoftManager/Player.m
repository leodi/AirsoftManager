//
//  Player.m
//  AirsoftManager
//
//  Created by Paul Bizouard on 14/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import <sqlite3.h>
#import "Player.h"
#import "Database.h"

static Player *sharedPlayer = nil;

@implementation Player

@synthesize id, name, team, replicas;


#pragma mark -
#pragma mark Singleton Methods

+(Player *)sharedPlayer {
    if (sharedPlayer == nil)
    {	
        sharedPlayer = [[super allocWithZone:NULL] init];
    }
    return (sharedPlayer);
}

-(id)initWithData:(NSString *)i name:(NSString *)n team:(NSString *)t {
    self.id = [i intValue];
    self.name = [n copy];
    self.team = [t copy];
    return self;
}

-(NSMutableArray *)getAllPlayers {
    sqlite3 *database = [[Database sharedDatabase] getDatabase];
    sqlite3_stmt *compiledStatement;
    NSMutableArray *players = [[NSMutableArray alloc] init];
    
    if (sqlite3_prepare_v2(database, "SELECT id, name, team FROM player", -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            NSString *l_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            NSString *l_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            NSString *l_team = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
            
            Player *player = [[Player alloc] initWithData:l_id name:l_name team:l_team];
            
            [players addObject:player];
        }
    }
    sqlite3_finalize(compiledStatement);
    return players;
}


@end
