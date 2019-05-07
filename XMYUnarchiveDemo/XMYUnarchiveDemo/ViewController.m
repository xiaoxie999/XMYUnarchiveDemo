//
//  ViewController.m
//  XMYUnarchiveDemo
//
//  Created by apple on 2019/5/6.
//  Copyright © 2019 xiaoxie. All rights reserved.
//

#import "ViewController.h"

#import "SSZipArchive.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)unarchiveButtonAction:(id)sender {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    NSString * filePath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),@"test.zip"];
    if ([fileManager fileExistsAtPath:filePath]) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [SSZipArchive unzipFileAtPath:filePath toDestination:[filePath stringByDeletingPathExtension] overwrite:YES password:@"" progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
                NSString * progressValue = [NSString stringWithFormat:@"%.2f",entryNumber*1.0/total];
                NSLog(@"%@,%@",progressValue,entry);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.stateLabel.text = progressValue;
                });
                
            } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
                
                NSLog(@"%@,%d,%@",path,succeeded,error);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.stateLabel.text = @"解压完成";
                    
//                    [fileManager removeItemAtPath:filePath error:nil];
                });
            }];
        });
    }
    else {
        NSLog(@"没有文件");
    }
}


@end
