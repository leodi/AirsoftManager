//
//  Player.h
//  AirsoftManager
//
//  Created by Paul Bizouard on 14/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Replica.h"
#import "Game.h"
#import "Database.h"

@class Game;

@interface Player : NSObject {
    int id;
    NSString *name;
    NSString *team;
    BOOL chrony;
    BOOL payment;
}


@property (nonatomic) int id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *team;
@property (nonatomic) BOOL chrony;
@property (nonatomic) BOOL payment;

@property (nonatomic, retain) NSMutableArray *replicas;

+(Player *)sharedPlayer;
+(NSArray *)playersArrayToSection:(NSArray *)players;

-(NSMutableArray *)getAllPlayers;
-(NSMutableArray *)getAllPlayersWitchIsNotInGame:(Game *)game;

-(Player *)initWithData:(int)i name:(NSString *)n team:(NSString *)t;
-(void)getReplicas;
-(void)save;
-(void)delete;

@end
