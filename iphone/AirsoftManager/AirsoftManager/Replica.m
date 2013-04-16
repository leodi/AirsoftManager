//
//  Replica.m
//  AirsoftManager
//
//  Created by Paul Bizouard on 14/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import "Replica.h"

@implementation Replica

+(NSArray *)getAllReplicasByPlayerId:(int)i {
    sqlite3 *database = [[Database sharedDatabase] getDatabase];
    sqlite3_stmt *compiledStatement;
    NSMutableArray *replicas = [[NSMutableArray alloc] init];
    
    if (sqlite3_prepare_v2(database, "SELECT id, name, velocity FROM replica WHERE id_player=?", -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        sqlite3_bind_int(compiledStatement, 1, i);
        while (sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            int l_id = sqlite3_column_int(compiledStatement, 0);
            NSString *l_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            NSString *l_velocity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];

            Replica *replica = [[Replica alloc] initWithData:l_id id_player:i name:l_name velocity:[l_velocity intValue]];
            [replicas addObject:replica];
        }
    }
    sqlite3_finalize(compiledStatement);
    return [[NSArray alloc] initWithArray:replicas];
}


-(id)initWithData:(int)i id_player:(int)id_player name:(NSString *)n velocity:(int)v {
    self.id = i;
    self.id_player = id_player;
    self.name = [n copy];
    self.velocity = v;
    return self;
}


-(void)save {
    sqlite3 *database = [[Database sharedDatabase] getDatabase];
    sqlite3_stmt *stmt;
    
    const char * query = "INSERT OR REPLACE INTO replica (id, id_player, name, velocity) VALUES (?,?,?,?)";
    if (sqlite3_prepare_v2(database, query, -1, &stmt, NULL) != SQLITE_OK)
        NSLog(@"Error sqlite prepare update [%s]", sqlite3_errmsg(database));
    if ([self id] != 0)
        sqlite3_bind_int(stmt, 1, [self id]);
    sqlite3_bind_int(stmt, 2, [self id_player]);
    sqlite3_bind_text(stmt, 3, [[self name] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 4, [self velocity]);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

-(void)delete {
    sqlite3 *database = [[Database sharedDatabase] getDatabase];
    sqlite3_stmt *stmt;
    const char * query;
    
    query = "DELETE FROM replica WHERE id=?";
    if (sqlite3_prepare_v2(database, query, -1, &stmt, NULL) != SQLITE_OK)
        NSLog(@"Error sqlite prepare update [%s]", sqlite3_errmsg(database));
    sqlite3_bind_int(stmt, 1, [self id]);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

@end
