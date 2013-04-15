//
//  FirstViewController.h
//  AirsoftManager
//
//  Created by Paul Bizouard on 13/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *message;
- (IBAction)reagir:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textfield;

- (IBAction)textChange:(id)sender forEvent:(UIEvent *)event;

@end
