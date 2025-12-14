from personne import *

class Conservateur(Personne):
    def __init__(self,n,p,a):
        Personne.__init__(self,n,p,a)
        self.__bibliotheque = None
    def __str__(self):
        return( "Nom: {}, Prénom: {}, Adresse:{}".format(self.get_nom(),self.get_prenom(),self.get_adresse()))
    def get_biblio(self):
        return self.__bibliotheque
    def set_bibliotheque(self,biblio):
        self.__bibliotheque = biblio