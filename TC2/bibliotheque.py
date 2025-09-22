class Bibliotheque():
    def __init__(self,n):
        self.__n = n
        self.__livres = []
        self.__lecteurs = []
    
    def get_nom(self):
        return self.__n
    def get_livres(self):
        return self.__livres
    def get_lecteurs(self):
        return self.__lecteurs
    def add_livre(self,nLi):
        self.__livres.append(nLi)
    def del_livre(self,nLi):
        self.__livres.remove(nLi)
    def add_lecteur(self,nLe):
        self.__lecteurs.append(nLe)
    def del_lecteur(self,nLe):
        if get_emprunt(nLe) == 0:
            self.__lecteurs.remove(nLe)
    