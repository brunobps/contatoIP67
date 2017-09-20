//
//  Contato.m
//  ContatosIP67
//
//  Created by ios7126 on 9/12/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

#import "Contato.h"

@implementation Contato

@dynamic nome, telefone, endereco, site, latitude, longitude, foto;

-(NSString *)description {
    return [NSString stringWithFormat:@"Nome: %@, Telefone: %@,Endereco: %@, Site: %@", self.nome, self.telefone, self.endereco, self.site];
}

-(CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

-(NSString *)title {
    return self.nome;
}

-(NSString *)subtitle {
    return self.site;
}

@end
