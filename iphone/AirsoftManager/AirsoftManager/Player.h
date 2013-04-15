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

@interface Player : NSObject {
    int id;
    NSString *name;
    NSString *team;
    NSMutableArray *replicas; // Array of replica
}


@property (nonatomic) int id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *team;
@property (nonatomic, retain) NSMutableArray *replicas;

+(Player *)sharedPlayer;

-(NSMutableArray *)getAllPlayers;
-(Player *)initWithData:(NSString *)i name:(NSString *)n team:(NSString *)t;

@end
