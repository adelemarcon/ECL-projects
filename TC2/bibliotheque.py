from emprunt import Emprunt
class Bibliotheque():
    def __init__(self,n):
        self.__n = n
        self.__livres = []
        self.__lecteurs = []
        self.__emprunts = []
    
    def get_nom(self):
        return self.__n
    def get_livres(self):
        return self.__livres
    def get_lecteurs(self):
        return self.__lecteurs
    def ajout_livre(self,t,a,num,nb):
        self.__livres.append([t,a,num,nb])
    def retrait_livre(self,nLi):
        for k in self.__livres:
            if k[2] == nLi:
                self.__livres.remove(k)
    def ajout_lecteur(self,n,p,a,num):
        self.__lecteurs.append([n,p,a,num])
    def retrait_lecteur(self,nLe):
        for k in self.__lecteurs:
            if k[3] == nLe:
                self.__lecteurs.remove(k)
    def chercher_lecteur_nom(self,n,p):
        for k in self.__lecteurs:
            if k.get_nom() == n and k.get_prenom() == p:
                return k
    def chercher_lecteur_numero(self,num):
        for k in self.__lecteurs:
            if k.get_numero() == num:
                return k
    def chercher_livre_titre(self,t):
        for k in self.__livres:
            if k.get_titre() == t:
                return k
    def chercher_livre_numero(self,num):
        for k in self.__livres:
            if k.get_numero() == num:
                return k
    def emprunt_livre(self,n_lecteur,n_livre):
        n = True
        for k in self.__emprunts:
            if k.get_numerolecteur() == n_lecteur and k.get_numerolivre() == n_livre:
                n = False
        if n:
            if self.__livres != 0:
                self.__emprunts.append([n_lecteur,n_livre])
                self.__livres[a][3] -= 1
                print ("Emprunt réussi")
            if self.__livres[a][3] == 0:
                print("Plus de livre disponible")
    def retour_livre(self,n_lecteur,n_livre):
        for k in self.__emprunts:
            if k[0] == n_lecteur and k[1] == n_livre:
                self.__emprunts.remove(k)
        m = -1
        a = 0
        for j in self.__livres:
            m +=1
            if j[2] == n_livre:
                a = m
            self.__livres[a][3] += 1
                
    def affiche_lecteurs(self):
        print( "Lecteurs: {}".format(self.__lecteurs))
    def affiche_livres(self):
        print("Livres:{}".format(self.__livres))
    def affiche_emprunts(self):
        print ("Emprunts: {}".format(self.__emprunts))