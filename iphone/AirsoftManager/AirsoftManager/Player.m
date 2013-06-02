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

-(id)initWithData:(int) i name:(NSString *)n team:(NSString *)t {
    self.id = i;
    self.name = [n copy];
    self.team = [t copy];
    return self;
}

-(NSMutableArray *)getAllPlayers {
    sqlite3 *database = [[Database sharedDatabase] getDatabase];
    sqlite3_stmt *compiledStatement;
    NSMutableArray *players = [[NSMutableArray alloc] init];
    char *tmp;
    
    if (sqlite3_prepare_v2(database, "SELECT id, name, team FROM player", -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            int l_id = sqlite3_column_int(compiledStatement, 0);
            
            NSString *l_name;
            tmp = (char *)sqlite3_column_text(compiledStatement, 1);
            if (tmp)
                l_name = [NSString stringWithUTF8String:tmp];
            else
                l_name = [NSString alloc];
            
            NSString *l_team;
            tmp = (char *)sqlite3_column_text(compiledStatement, 2);
            if (tmp)
                l_team = [NSString stringWithUTF8String:tmp];
            else
                l_team = [NSString alloc];
            
            Player *player = [[Player alloc] initWithData:l_id name:l_name team:l_team];
            [player getReplicas];
            [players addObject:player];
        }
    }
    sqlite3_finalize(compiledStatement);
    [players sortUsingComparator:^ NSComparisonResult(Player *p1, Player *p2) {
        if ([p1.team isEqualToString:p2.team])
            return [p1.name localizedCaseInsensitiveCompare:p2.name];
        return [p1.team localizedCaseInsensitiveCompare:p2.team];
    }];
    return players;
}

-(void)getReplicas {
    self.replicas = [[NSMutableArray alloc] initWithArray:[Replica getAllReplicasByPlayerId:self.id]];
}

-(void)save {
    sqlite3 *database = [[Database sharedDatabase] getDatabase];
    sqlite3_stmt *stmt;
    
    if ([self.team length] == 0)
        self.team = @"Freelance";
    
    const char * query = "INSERT OR REPLACE INTO player (id, name, team) VALUES (?,?,?)";
    if (sqlite3_prepare_v2(database, query, -1, &stmt, NULL) != SQLITE_OK)
        NSLog(@"Error sqlite prepare update [%s]", sqlite3_errmsg(database));
    if ([self id] != 0)
        sqlite3_bind_int(stmt, 1, [self id]);
    sqlite3_bind_text(stmt, 2, [[self name] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, [[self team] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    if ([self id] == 0)
        self.id = sqlite3_last_insert_rowid(database);
}

-(void)delete {
    sqlite3 *database = [[Database sharedDatabase] getDatabase];
    sqlite3_stmt *stmt;
    const char * query;
    
    query = "DELETE FROM replica WHERE id_player=?";
    if (sqlite3_prepare_v2(database, query, -1, &stmt, NULL) != SQLITE_OK)
        NSLog(@"Error sqlite prepare update [%s]", sqlite3_errmsg(database));
    sqlite3_bind_int(stmt, 1, [self id]);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    query = "DELETE FROM player WHERE id=?";
    if (sqlite3_prepare_v2(database, query, -1, &stmt, NULL) != SQLITE_OK)
        NSLog(@"Error sqlite prepare update [%s]", sqlite3_errmsg(database));
    sqlite3_bind_int(stmt, 1, [self id]);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);    
}

@end
