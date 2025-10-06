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
        

class Personne():
    def __init__(self,n,p,a):
        self.__n = n
        self.__p = p
        self.__a = a
    def __str__(self):
        print("Nom: {}, Prénom: {}, Adresse: {}".format(self.__n,self.__p,self.__a))
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


class Bibliothecaire(Personne):
    def __init__(self,n,p,a,num):
        Personne.__init__(self,n,p,a)
        self.__num = num
    def __str__(self):
        return( "Nom: {}, Prénom: {}, Adresse:{}, Numéro:{}".format(self.get_nom(),self.get_prenom(),self.get_adresse(),self.__num))
    def get_numero(self):
        return self.__num
    def set_numero(self,num):
        self.__num = num

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

from datetime import date
class Emprunt():
    def __init__(self,numL,numLi,numBiblio):
        self.__numlecteur = numL
        self.__numlivre = numLi
        self.__numBiblio = numBiblio
        self.__date = date.isoformat(date.today())
    def __str__(self):
        return ("Lect: {}, Livre: {}, Bibliothécaire: {},date: {}".format(self.__numlecteur,self.__numlivre,self.__numBiblio,self.__date))
    def get_numero_lecteur(self):
        return self.__numlecteur
    def get_numero_livre(self):
        return self.__numlivre
    def get_date(self):
        return self.__date
    def get_numero_bibliothecaire(self):
        return self.__numBiblio

class Livre():
    def __init__(self,t,a,num,nb):
        self.__a = a
        self.__t = t
        self.__num = num
        self.__nb = nb
        self.__nbdispo = nb
    def __str__(self):
        return( "Auteur: {}, Titre: {}, Numéro: {}, Nombre acheté: {}, Nombre dispo: {}".format(self.__a,self.__t,self.__num, self.__nb,self.__nbdispo))
    def get_titre(self):
        return self.__t
    def set_titre(self,t):
        self.__t = t
    def get_auteur(self):
        return self.__a
    def set_auteur(self,a):
        self.__a = a
    def get_numero(self):
        return self.__num
    def set_numero(self,num):
        self.__num = num
    def get_nb_total(self):
        return self.__nb
    def set_nb_total(self,n):
        self.__nb = n
    def get_nb_dispo(self):
        return self.__nbdispo
    def set_nb_dispo(self,nb):
        self.__nbdispo = nb