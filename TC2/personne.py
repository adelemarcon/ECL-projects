class Lecteur(Personne):
    def __init__(self,n,p,a,nb):
        self.__n = n
        self.__p = p
        self.__a = a
    def get_nom(self):
        return self.__n
    def set_nom(self,n):
        self.__n = n
    def get_prenom(self):
        return self.__p
    def set_prenom(self,p):
        self.__p = p
    def get_adresse(self):
        return self.__a
    def set_adresse(self,a):
        self.__a = a