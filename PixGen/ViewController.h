//
//  ViewController.h
//  PixGen
//
//  Created by Daniel on 11/1/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreImage/CoreImage.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ViewController : NSViewController


@property (weak) IBOutlet NSButton *debeInvertir;


@property (weak) IBOutlet NSImageView *imgInputWell;
@property (weak) IBOutlet NSTextField *txtNombre;

@property (weak) IBOutlet NSPopUpButton *popUpPantalla;

- (IBAction)generarCodigo:(id)sender;

@property (strong) IBOutlet NSTextView *textoCodigo;




@end

