from personne import *
class Lecteur(Personne):
    def __init__(self,n,p,a,nb):
        Personne.__init__(self,n,p,a)
        self.__nb = nb
        self.__nbemprunts = 0
    def __str__(self):
        return( "Nom: {}, Prénom: {}, Adresse:{}, Numéro:{}".format(self.get_nom(),self.get_prenom(),self.get_adresse(),self.__nb))
    def get_numero(self):
        return self.__nb
    def set_numero(self,nb):
        self.__nb = nb
    def get_nb_emprunts(self):
        return self.__nbemprunts
    def set_nb_emprunts(self,nb):
        self.__nbemprunts = nb