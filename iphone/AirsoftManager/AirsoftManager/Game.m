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
            char * tmp_date = (char *)sqlite3_column_text(compiledStatement, 2);
            
            
            NSDate *l_date;
            
            if (tmp_date == nil)
                l_date = [[NSDate alloc] init];
            else
                l_date = [formatter dateFromString:[NSString stringWithUTF8String:tmp_date]];
            
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

-(NSMutableArray *)getAllPlayers {
    sqlite3 *database = [[Database sharedDatabase] getDatabase];
    sqlite3_stmt *compiledStatement;
    NSMutableArray *players = [[NSMutableArray alloc] init];
    char *tmp;
    
    if (sqlite3_prepare_v2(database, "SELECT P.id, P.name, P.team, GP.chrony, GP.payment FROM player P, game_player GP WHERE GP.id_player=P.id AND GP.id_game=?", -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        sqlite3_bind_int(compiledStatement, 1, [self id]);
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
            
            [player setChrony:(sqlite3_column_int(compiledStatement, 3) == 1 ? YES : NO)];
            [player setPayment:(sqlite3_column_int(compiledStatement, 4) == 1 ? YES : NO)];

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


-(void)addPlayer:(Player *)player {
    sqlite3 *database = [[Database sharedDatabase] getDatabase];
    sqlite3_stmt *stmt;
    
    const char * query;
    
    query = "DELETE FROM game_player WHERE id_game=? AND id_player=?";
    if (sqlite3_prepare_v2(database, query, -1, &stmt, NULL) != SQLITE_OK)
        NSLog(@"Error sqlite prepare update [%s]", sqlite3_errmsg(database));
    sqlite3_bind_int(stmt, 1, [self id]);
    sqlite3_bind_int(stmt, 2, [player id]);
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    query = "INSERT INTO game_player (id_game, id_player) VALUES (?,?)";
    if (sqlite3_prepare_v2(database, query, -1, &stmt, NULL) != SQLITE_OK)
        NSLog(@"Error sqlite prepare update [%s]", sqlite3_errmsg(database));
    sqlite3_bind_int(stmt, 1, [self id]);
    sqlite3_bind_int(stmt, 2, [player id]);
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}


-(void)removePlayer:(Player *)player {
    sqlite3 *database = [[Database sharedDatabase] getDatabase];
    sqlite3_stmt *stmt;
    
    const char * query = "DELETE FROM game_player WHERE id_game=? AND id_player=?";
    if (sqlite3_prepare_v2(database, query, -1, &stmt, NULL) != SQLITE_OK)
        NSLog(@"Error sqlite prepare update [%s]", sqlite3_errmsg(database));
    sqlite3_bind_int(stmt, 1, [self id]);
    sqlite3_bind_int(stmt, 2, [player id]);
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

-(void)delete {
    sqlite3 *database = [[Database sharedDatabase] getDatabase];
    sqlite3_stmt *stmt;
    const char * query;
    
    query = "DELETE FROM game_player WHERE id_game=?";
    if (sqlite3_prepare_v2(database, query, -1, &stmt, NULL) != SQLITE_OK)
        NSLog(@"Error sqlite prepare update [%s]", sqlite3_errmsg(database));
    sqlite3_bind_int(stmt, 1, [self id]);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    
    query = "DELETE FROM game WHERE id=?";
    if (sqlite3_prepare_v2(database, query, -1, &stmt, NULL) != SQLITE_OK)
        NSLog(@"Error sqlite prepare update [%s]", sqlite3_errmsg(database));
    sqlite3_bind_int(stmt, 1, [self id]);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

-(void)setChronyStateFor:(Player *)player state:(BOOL)state {
    sqlite3 *database = [[Database sharedDatabase] getDatabase];
    sqlite3_stmt *stmt;
    
    const char * query = "UPDATE game_player SET chrony=? WHERE id_game=? AND id_player=?";
    if (sqlite3_prepare_v2(database, query, -1, &stmt, NULL) != SQLITE_OK)
        NSLog(@"Error sqlite prepare update [%s]", sqlite3_errmsg(database));
    sqlite3_bind_int(stmt, 1, (state == YES ? 1 : 0));
    sqlite3_bind_int(stmt, 2, [self id]);
    sqlite3_bind_int(stmt, 3, [player id]);
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

-(void)setPaymentStateFor:(Player *)player state:(BOOL)state {
    sqlite3 *database = [[Database sharedDatabase] getDatabase];
    sqlite3_stmt *stmt;
    
    const char * query = "UPDATE game_player SET `payment`=? WHERE id_game=? AND id_player=?";
    if (sqlite3_prepare_v2(database, query, -1, &stmt, NULL) != SQLITE_OK)
        NSLog(@"Error sqlite prepare update [%s]", sqlite3_errmsg(database));
    sqlite3_bind_int(stmt, 1, (state == YES ? 1 : 0));
    sqlite3_bind_int(stmt, 2, [self id]);
    sqlite3_bind_int(stmt, 3, [player id]);

    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

@end
