from personne import *

class Bibliothecaire(Personne):
    def __init__(self,n,p,a,num):
        Personne.__init__(self,n,p,a)
        self.__num = num
    def __str__(self):
        return( "Nom: {}, Prénom: {}, Adresse:{}, Numéro:{}".format(self.get_nom(),self.get_prenom(),self.get_adresse(),self.__num))
    def get_numero(self):
        return self.__num
    def set_numero(self,num):
        self.__num = num