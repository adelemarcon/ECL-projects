from emprunt import *
from livre import *
from lecteur import *
from conservateur import *
from bibliothecaire import *

class Bibliotheque():
    def __init__(self,n):
        self.__n = n
        self.__livres = []
        self.__lecteurs = []
        self.__emprunts = []
        self.__bibliothecaires = []
        self.__conservateur = None
    
    def get_nom(self):
        return self.__n
    def ajout_livre(self,t,a,num,nb):
        L = Livre(t,a,num,nb)
        self.__livres.append(L)
    def retrait_livre(self,nLi):
        liv = self.chercher_livre_numero(nLi)
        if liv == None:
            print ("Livre non trouvé")
            return False
        for e in self.__emprunts:
            if e.get_numero_livre() == nLi:
                print("Le livre est en cours d'emprunt")
                return False
        self.__livres.remove(liv)
        return True
    def ajout_lecteur(self,n,p,a,num):
        L = Lecteur(n,p,a,num)
        self.__lecteurs.append(L)
    def retrait_lecteur(self,nLe):
        lec = self.chercher_lecteur_numero(nLe)
        if lec != None:
            for e in self.__emprunts:
                if e.get_numero_lecteur() == nLe:
                    print("Le lecteur possède encore des emprunts")
                    return False
            self.__lecteurs.remove(lec)
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
    def chercher_emprunt(self,n_lecteur,n_livre):
        for k in self.__emprunts:
            if k.get_numero_lecteur() == n_lecteur and k.get_numero_livre() == n_livre:
                return k
        return None
        
    def emprunt_livre(self,n_lecteur,n_livre,n_bibliothecaire):
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
       biblio = self.chercher_bibliothecaire_numero(n_bibliothecaire)
       if biblio == None:
           print("Le/la Bibliothécaire n'existe pas")
           return False
       e = Emprunt(n_lecteur,n_livre,n_bibliothecaire)
       self.__emprunts.append(e)
       print("Emprunt réussi")
       liv.set_nb_dispo(liv.get_nb_dispo() - 1)
       lec.set_nb_emprunts(lec.get_nb_emprunts()+1)
       return True
    def retour_livre(self,n_lecteur,n_livre):
        e = self.chercher_emprunt(n_lecteur,n_livre)
        if e == None:
            print("L'emprunt n'existe pas")
            return False
        self.__emprunts.remove(e)
        lecteur = self.chercher_lecteur_numero(n_lecteur)
        if lecteur != None : 
            lecteur.set_nb_emprunts(lecteur.get_nb_emprunts()-1)
        liv = self.chercher_livre_numero(n_livre)
        if liv != None: 
            liv.set_nb_dispo(liv.get_nb_dispo()+1)
            print("Retour réussi")
        return True              
                
    def affiche_lecteurs(self):
        for l in self.__lecteurs:
            print(l)

    def affiche_livres(self):
        for l in self.__livres:
            print(l)           
            
    def affiche_emprunts(self):
        for e in self.__emprunts:
            print(e)
            
    def affiche_bibliothecaires(self):
        for b in self.__bibliothecaires:
            print(b)
    
    def affiche_conservateur(self):
        print(self.__conservateur)
    
    def chercher_bibliothecaire_nom(self,n,p):
        for k in self.__bibliothecaires:
            if k.get_nom() == n and k.get_prenom() == p:
                return k
        return None
    def chercher_bibliothecaire_numero(self,num):
        for k in self.__bibliothecaires:
            if k.get_numero() == num:
                return k
        print("Le bibliothécaire n'existe pas")
        return None
    def ajout_bibliothecaire(self,n,p,a,num):
        b = Bibliothecaire(n,p,a,num)
        self.__bibliothecaires.append(b)
    
    def retrait_bibliothecaire(self,num):
        biblio = self.chercher_bibliothecaire_numero(num)
        if biblio != None:
            for e in self.__emprunts:
                if e.get_numero_bibliothecaire() == num:
                    print("Le(La) bibliothécaire est encore lié(e) à des emprunts")
                    return False
            self.__bibliothecaires.remove(biblio)
            print ("Bibliothécaire retiré")
            return True
            
    def get_conservateur(self):
        return self.__conervateur
    
    def set_conservateur(self,nom,prenom,adresse):
        c = Conservateur(nom,prenom,adresse)
        self.__conservateur = c