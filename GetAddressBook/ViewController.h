//
//  ViewController.h
//  GetAddressBook
//
//  Created by Patrik Jonsson on 5/4/15.
//  Copyright (c) 2015 Patrik Jonsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)readAddressBook:(id) sender;

@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

