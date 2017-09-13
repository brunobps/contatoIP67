//
//  Contato.m
//  ContatosIP67
//
//  Created by ios7126 on 9/12/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

#import "Contato.h"

@implementation Contato

-(NSString *)description {
    return [NSString stringWithFormat:@"Nome: %@, Telefone: %@,Endereco: %@, Site: %@", self.nome, self.telefone, self.endereco, self.site];
}

@end
