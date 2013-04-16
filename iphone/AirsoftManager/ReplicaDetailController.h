//
//  ReplicaDetailController.h
//  AirsoftManager
//
//  Created by Paul Bizouard on 16/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerDetailController.h"
#import "Replica.h"

@class PlayerDetailController;

@interface ReplicaDetailController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) PlayerDetailController *playerDetailController;
@property (strong, nonatomic) Replica    *replicaDetail;

@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UITextField *replicaText;
@property (weak, nonatomic) IBOutlet UITextField *velocityText;

- (IBAction)name:(id)sender;
- (IBAction)velocity:(id)sender;
- (IBAction)save:(id)sender;

@end
