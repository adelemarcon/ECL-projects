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
    def chercher_lecteur_nom(self,n):
        for k in self.__lecteurs:
            if k.get_nom() == n:
                return k
    def chercher_lecteur_num(self,num):
        for k in self.__lecteurs:
            if k.get_num() == num:
                return k
    def chercher_livre_titre(self,t):
        for k in self.__livres:
            if k.get_titre() == t:
                return k
    def chercher_livre_num(self,num):
        for k in self.__livres:
            if k.get_num() == num:
                return k