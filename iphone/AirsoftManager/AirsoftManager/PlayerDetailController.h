//
//  PlayerDetailController.h
//  AirsoftManager
//
//  Created by Paul Bizouard on 15/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerListController.h"
#import "ReplicaDetailController.h"
#import "GameDetailController.h"
#import "Player.h"

@class PlayerListController;
@class GameDetailController;
@interface PlayerDetailController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property BOOL isFromGames;
@property (strong, nonatomic) Player    *playerDetail;
@property (strong, nonatomic) PlayerListController *playerListController;
@property (strong, nonatomic) GameDetailController *gameDetailController;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *team;
@property (weak, nonatomic) IBOutlet UITableView *replicaTable;


@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonValidateChrony;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonValidatePayment;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonCancelToolbar;


@property (weak, nonatomic) IBOutlet UIButton *addReplica;


- (IBAction)name:(id)sender;
- (IBAction)team:(id)sender;
- (IBAction)save:(id)sender;

- (IBAction)validateChrony:(id)sender;
- (IBAction)validatePayment:(id)sender;
- (IBAction)cancel:(id)sender;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
