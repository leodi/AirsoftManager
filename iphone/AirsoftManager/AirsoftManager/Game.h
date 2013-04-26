//
//  Game.h
//  AirsoftManager
//
//  Created by Paul Bizouard on 25/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Database.h"
#import "Player.h"

@interface Game : NSObject

@property (nonatomic) int id;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSArray *players;

+(Game *)sharedGame;

-(NSArray *)getAllGames;
-(Game *)initWithData:(int)i name:(NSString *)n date:(NSDate *)d;
-(void)getPlayers;
-(void)save;
-(void)delete;

@end
