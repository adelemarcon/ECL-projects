from emprunt import *
from livre import *
from lecteur import *

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
        liv = self.chercher_livre_numero(nLi)
        if liv == None:
            print ("Livre non trouvé")
            return False
        for e in self.__emprunts:
            if e.get_numro_livre() == nLi:
                print("Le livre est en cours d'emprunt")
                return False
        self.__livres.remove(liv)
        print("Livre retiré")
        return True
    def ajout_lecteur(self,n,p,a,num):
        L = Lecteur(n,p,a,num)
        self.__lecteurs.append(L)
    def retrait_lecteur(self,nLe):
        lec = self.chercher_lecteur_numero(nLe)
        if lec == None:
            print ("Le lecteur n'a pas été trouvé")
            return False
        for e in self.__emprunts:
            if e.get_numero_lecteur() == nLe:
                print("Le lecteur possède encore des emprunts")
                return False
        self.__lecteurs.remove(lec)
        print ("Lecteur retiré")
        return True
    def chercher_lecteur_nom(self,n,p):
        for k in self.__lecteurs:
            if k.get_nom() == n and k.get_prenom() == p:
                return k
        return None
    def chercher_lecteur_numero(self,num):
        for k in self.__lecteurs:
            if k.get_numero() == num:
                return k
        return None
    def chercher_livre_titre(self,t):
        for k in self.__livres:
            if k.get_titre() == t:
                return k
        return None
    def chercher_livre_numero(self,num):
        for k in self.__livres:
            if k.get_numero() == num:
                return k
        return None
    def emprunt_livre(self,n_lecteur,n_livre):
       liv = self.chercher_livre_numero(n_livre)
       if liv == None:
           print("Livre non trouvé")
           return False
       if liv.get_nb_dispo() == 0:
           print("Plus d'exemplaire disponibles")
           return False
       lec = self.chercher_lecteur_numero(n_lecteur)
       if lec == None:
           print("Le lecteur n'existe pas")
           return False
       emp = self.chercher_emprunt(n_lecteur,n_livre)
       if emp != None:
           print("Le livre est déjà emprunté par le lecteur")
           return False
       e = Emprunt(n_lecteur,n_livre)
       self.__emprunts.append(e)
       liv.set_nb_dispo(liv.get_nb_dispo() - 1)
       return True
    def retour_livre(self,n_lecteur,n_livre):
        e = self.chercher_emprunt(n_lecteur,n_livre)
        if e == None:
            print("Lemprunt n'existe pas")
            return False
        self.__emprunts.remov(e)
        liv = self.chercher_livre_numero(n_livre)
        if liv != None: 
            liv.set_nb_dispo(liv.get_nb_dispo()+1)                
                
    def affiche_lecteurs(self):
        for k in self.__lecteurs:
            k.affiche_lecteur()
    def affiche_livres(self):
        for k in self.__livres:
            k.affiche_livre()
    def affiche_emprunts(self):
        for k in self.__emprunts:
            k.affiche_emprunt()