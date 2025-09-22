class Bibliotheque():
    def __init__(self,n):
        self.__n = n
        self.__livres = []
        self.__lecteurs = []
        self.__emprunt = []
    
    def get_nom(self):
        return self.__n
    def get_livres(self):
        return self.__livres
    def get_lecteurs(self):
        return self.__lecteurs
    def ajout_livre(self,a,t,num,nb):
        self.__livres.append([a,t,num,nb])
    def retrait_livre(self,nLi):
        for k in self.__livres:
            if k[3] == nLi:
                self.__livres.remove(k)
    def ajout_lecteur(self,n,p,a,num):
        self.__lecteurs.append([n,p,a,num])
    def retrait_lecteur(self,nLe):
        for k in self.__lecteurs:
            if k[3] == nLe:
                self.__lecteurs.remove(k)
    def chercher_lecteur_nom(self,n):
        for k in self.__lecteurs:
            if k[0] == n:
                return k
    def chercher_lecteur_num(self,num):
        for k in self.__lecteurs:
            if k[3] == num:
                return k
    def chercher_livre_titre(self,t):
        for k in self.__livres:
            if k[1] == t:
                return k
    def chercher_livre_num(self,num):
        for k in self.__livres:
            if k[3] == num:
                return k
    def emprunt_livre(self,n_lecteur,n_livre):
        n = True
        for k in self.__emprunt:
            if k == [n_lecteur,n_livre]:
                n = False
        if n:
            self.__emprunt.append([n_lecteur,n_livre])