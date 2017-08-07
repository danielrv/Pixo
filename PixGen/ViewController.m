//
//  ViewController.m
//  PixGen
//
//  Created by Daniel on 11/1/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [_popUpPantalla removeAllItems];
    [_popUpPantalla addItemWithTitle:@"NHD-C12864A1Z-FSW-FBW-HTT"];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


#define width 128
#define height 64
#define pages 8
#define heighP 8

- (IBAction)generarCodigo:(id)sender {
    
    if(_imgInputWell.image == nil){ return;}
    NSImage* img = [_imgInputWell image];
    NSBitmapImageRep* raw_img;
    
    if ([_debeInvertir state]==NSOnState) {
        
        CIImage* ciImage = [[CIImage alloc] initWithData:[img TIFFRepresentation]];
        if ([img isFlipped])
        {
            CGRect cgRect    = [ciImage extent];
            CGAffineTransform transform;
            transform = CGAffineTransformMakeTranslation(0.0,64);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            ciImage   = [ciImage imageByApplyingTransform:transform];
        }
        CIFilter* filter = [CIFilter filterWithName:@"CIColorInvert"];
        [filter setDefaults];
        [filter setValue:ciImage forKey:@"inputImage"];
        CIImage* output = [filter valueForKey:@"outputImage"];
        
        NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:output];
        NSImage *nsImage = [[NSImage alloc] initWithSize:rep.size];
        [nsImage addRepresentation:rep];
        
        [_imgInputWell setImage:nsImage];
        
        
        
        raw_img = [NSBitmapImageRep imageRepWithData:[nsImage TIFFRepresentation]];
        
    }else{
        raw_img = [NSBitmapImageRep imageRepWithData:[img TIFFRepresentation]];
    }
    
  
    NSMutableString *st = [[NSMutableString alloc] init];
    [st appendFormat:@"unsigned char %@  []",_txtNombre.stringValue];
    [st appendString:@"= {\n"];
    int fila = 0;
    
    while(fila < 64){
        NSLog(@"Fila %d",fila);
        for (int columna=0; columna<128; columna++) {
            NSLog(@"Columna %d para Fila %d",columna, fila);
            uint8_t phv = 0;
            for (int bit = 0; bit<8; bit++) {
                NSColor* color = [raw_img colorAtX:columna y:fila+bit];
                int binval =  round(color.redComponent);
                if (binval == 1) {
                    phv |= 1<< bit;
                }
            }
            NSLog(@"-> 0x%02x",phv);
            NSString *sb = [NSString stringWithFormat:@"0x%02x,",phv];
            [st appendString:sb];
        
        }
        [st appendString:@"\n"];
        
        fila = fila+8;
    }
    NSLog(@"%lu",(unsigned long)st.length);
    NSRange range = NSMakeRange([st length]-2,2);
    [st replaceCharactersInRange:range withString:@"\n"];
    [st appendString:@"};"];
    
    [[[_textoCodigo textContainer] textView] setString:st];
    
}
@end
