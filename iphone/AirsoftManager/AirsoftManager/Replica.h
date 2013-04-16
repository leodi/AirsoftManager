//
//  Replica.h
//  AirsoftManager
//
//  Created by Paul Bizouard on 14/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Database.h"

@interface Replica : NSObject

@property (nonatomic) int id;
@property (nonatomic) int id_player;
@property (nonatomic) NSString *name;
@property (nonatomic) int velocity;


+(NSArray *)getAllReplicasByPlayerId:(int)id;
-(Replica *)initWithData:(int)i id_player:(int)id_player name:(NSString *)n velocity:(int)v;

-(void)save;
-(void)delete;

@end
