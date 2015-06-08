//
//  ViewController.m
//  GetAddressBook
//
//  Created by Patrik Jonsson on 5/4/15.
//  Copyright (c) 2015 Patrik Jonsson. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)readAddressBook:(id)sender {
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    __block BOOL accessGranted = NO;
    
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
        
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    //dispatch_release(semaphore);
    
    if (accessGranted) {
        [self getContactsWithAddressBook:addressBook];
    }
}

- (void)getContactsWithAddressBook:(ABAddressBookRef )addressBook {
    
    NSMutableArray * contactList = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i=0;i < nPeople;i++) {
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        //For username and surname
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
        
        CFStringRef *firstName;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        if (firstName != nil)
        {
          [dOfPerson setObject:[NSString stringWithFormat:@"%@", firstName] forKey:@"kABPersonFirstNameProperty"];
        }
        CFStringRef *middleName;
        middleName = ABRecordCopyValue(ref, kABPersonMiddleNameProperty);
        if (middleName != nil)
        {
            [dOfPerson setObject:[NSString stringWithFormat:@"%@", middleName] forKey:@"kABPersonMiddleNameProperty"];
        }
        CFStringRef *lastName;
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        if (lastName != nil)
        {
            [dOfPerson setObject:[NSString stringWithFormat:@"%@", lastName] forKey:@"kABPersonLastNameProperty"];
        }
        CFStringRef *nickname;
        nickname  = ABRecordCopyValue(ref, kABPersonNicknameProperty);
        if (nickname != nil)
        {
            [dOfPerson setObject:[NSString stringWithFormat:@"%@", nickname] forKey:@"kABPersonNicknameProperty"];
        }
        CFStringRef *companyName;
        companyName  = ABRecordCopyValue(ref, kABPersonOrganizationProperty);
        if (companyName != nil)
        {
            [dOfPerson setObject:[NSString stringWithFormat:@"%@", companyName] forKey:@"kABPersonOrganizationProperty"];
        }
        CFStringRef *jobTitle;
        jobTitle  = ABRecordCopyValue(ref, kABPersonJobTitleProperty);
        if (jobTitle != nil)
        {
            [dOfPerson setObject:[NSString stringWithFormat:@"%@", jobTitle] forKey:@"kABPersonJobTitleProperty"];
        }
        CFStringRef *department;
        department  = ABRecordCopyValue(ref, kABPersonJobTitleProperty);
        if (department != nil)
        {
            [dOfPerson setObject:[NSString stringWithFormat:@"%@", department] forKey:@"kABPersonJobTitleProperty"];
        }
        CFDateRef *birthday;
        birthday  = ABRecordCopyValue(ref, kABPersonBirthdayProperty);
        if (birthday != nil)
        {
            [dOfPerson setObject:[NSString stringWithFormat:@"%@", birthday] forKey:@"kABPersonBirthdayProperty"];
        }
        //kABPersonDepartmentProperty;         // Department name - kABStringPropertyType
        //kABPersonBirthdayProperty;           // Birthday associated with this person - kABDateTimePropertyType
        

        //[dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        for(CFIndex i = 0; i < ABMultiValueGetCount(eMail);i++) {
            NSString *emailKey = [NSString stringWithFormat:@"%@%ld", @"email", i];
            [dOfPerson setObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:emailKey];
        }
        
        //For Addresses
        ABMultiValueRef street = ABRecordCopyValue(ref, kABPersonAddressProperty);
        if (ABMultiValueGetCount(street) > 0) {
            CFDictionaryRef dict = ABMultiValueCopyValueAtIndex(street, 0);
            if (CFDictionaryGetValue(dict, kABPersonAddressStreetKey) != nil)
                [dOfPerson setObject: CFDictionaryGetValue(dict, kABPersonAddressStreetKey) forKey:@"kABPersonAddressStreetKey"];
            if (CFDictionaryGetValue(dict, kABPersonAddressCityKey) != nil)
                [dOfPerson setObject: CFDictionaryGetValue(dict, kABPersonAddressCityKey) forKey:@"kABPersonAddressCityKey"];
            if (CFDictionaryGetValue(dict, kABPersonAddressStateKey) != nil)
                [dOfPerson setObject: CFDictionaryGetValue(dict, kABPersonAddressStateKey) forKey:@"kABPersonAddressStateKey"];
            if (CFDictionaryGetValue(dict, kABPersonAddressZIPKey) != nil)
                [dOfPerson setObject: CFDictionaryGetValue(dict, kABPersonAddressZIPKey) forKey:@"kABPersonAddressZIPKey"];
            if (CFDictionaryGetValue(dict, kABPersonAddressCountryKey) != nil)
                [dOfPerson setObject: CFDictionaryGetValue(dict, kABPersonAddressCountryKey) forKey:@"kABPersonAddressCountryKey"];
            if (CFDictionaryGetValue(dict, kABPersonAddressCountryCodeKey) != nil)
                [dOfPerson setObject: CFDictionaryGetValue(dict, kABPersonAddressCountryCodeKey) forKey:@"kABPersonAddressCountryCodeKey"];
        }
        //kABPersonAddressProperty;            // Street address - kABMultiDictionaryPropertyType
        //kABPersonAddressStreetKey;
        //kABPersonAddressCityKey;
        //kABPersonAddressStateKey;
        //kABPersonAddressZIPKey;
        //kABPersonAddressCountryKey;
        //kABPersonAddressCountryCodeKey;
        //For Phone number
        NSString* mobileLabel;
        
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"mobile"];
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"iPhone"];
                break ;
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneHomeFAXLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"homeFax"];
                break ;
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneMainLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"main"];
                break ;
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneOtherFAXLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"otherFax"];
                break ;
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhonePagerLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"pager"];
                break ;
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneWorkFAXLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"workFax"];
                break ;
            }
            
        }

        [contactList addObject:dOfPerson];
        
    }

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contactList
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData)
    {
        //Deal with error
    }
    else
    {
        NSString *requestJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",requestJson);
        _textView.text = requestJson;

    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [textView selectAll:nil];
    });
    return YES;
}

//// All Personal Information Properties
//kABPersonFirstNameProperty;          // First name - kABStringPropertyType
//kABPersonLastNameProperty;           // Last name - kABStringPropertyType
//kABPersonMiddleNameProperty;         // Middle name - kABStringPropertyType
//kABPersonPrefixProperty;             // Prefix ("Sir" "Duke" "General") - kABStringPropertyType
//kABPersonSuffixProperty;             // Suffix ("Jr." "Sr." "III") - kABStringPropertyType
//kABPersonNicknameProperty;           // Nickname - kABStringPropertyType
//kABPersonFirstNamePhoneticProperty;  // First name Phonetic - kABStringPropertyType
//kABPersonLastNamePhoneticProperty;   // Last name Phonetic - kABStringPropertyType
//kABPersonMiddleNamePhoneticProperty; // Middle name Phonetic - kABStringPropertyType
//kABPersonOrganizationProperty;       // Company name - kABStringPropertyType
//kABPersonJobTitleProperty;           // Job Title - kABStringPropertyType
//kABPersonDepartmentProperty;         // Department name - kABStringPropertyType
//kABPersonBirthdayProperty;           // Birthday associated with this person - kABDateTimePropertyType

//kABPersonEmailProperty;              // Email(s) - kABMultiStringPropertyType
//kABPersonNoteProperty;               // Note - kABStringPropertyType
//kABPersonCreationDateProperty;       // Creation Date (when first saved)
//kABPersonModificationDateProperty;   // Last saved date
//

@end
