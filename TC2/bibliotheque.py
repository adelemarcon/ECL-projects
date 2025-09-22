from emprunt import Emprunt
from livre import Livre
from lecteur import Lecteur
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
        L = Livre(t,a,num,nb)
        self.__livres.append(L)
    def retrait_livre(self,nLi):
        for k in self.__livres:
            if k.get_numero() == nLi:
                self.__livres.remove(k)
                return True
            return False
    def ajout_lecteur(self,n,p,a,num):
        L = Lecteur(n,p,a,num)
        self.__lecteurs.append(L)
    def retrait_lecteur(self,nLe):
        for k in self.__lecteurs:
            if k.get_numero() == nLe:
                self.__lecteurs.remove(k)
                return True
            return False
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
            if k.get_numero_lecteur() == n_lecteur and k.get_numero_livre() == n_livre:
                n = False
        if n:
            for k in self.__livres:
                if k.get_nb_dispo() != 0 and k.get_numero == n_livre:
                    e = Emprunt(n_lecteur,n_livre)
                    self.__emprunts.append(e)
                    k.set_nb_dispo(k.get_nb_dispo() - 1)
    def retour_livre(self,n_lecteur,n_livre):
        for k in self.__emprunts:
            if k.get_numero_lecteur() == n_lecteur and k.get_numero_livre() == n_livre:
                self.__emprunts.remove(k)
                k.set_nb_dispo(k.get_nb_dispo() + 1)
                
                
    def affiche_lecteurs(self):
        for k in self.__lecteurs:
            k.affiche_lecteur()
    def affiche_livres(self):
        for k in self.__livres:
            k.affiche_livre()
    def affiche_emprunts(self):
        for k in self.__emprunts:
            k.affiche_emprunt()