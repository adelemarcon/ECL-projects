class Club:
    def __init__(self,nom):
        self.nom = nom
        self.__adherent = []
        self.__acti = []
        self.__association = []
    def ajout_adherent(self,a):
        self.__adherent.append(a)
    def ajout_activite(self,n):
        self.__acti.append(n)
    def associe(self,numAdherent,nomActivite):
        for a in self.__adherent:
            if a.get_numero() == numAdherent:
                for ac in self.__acti:
                    if ac.get_nom() == nomActivite:
                        ac.ajout_adherent(a)
                    else:
                        print("Activité non trouvée")
            else:
                print("Adherent non trouvé")
    def affiche_activistes(self):
        for a in self.__adherent:
            print("Adhérent: {}".format(a.get_nom()))
                    
class Personne:
    def __init__(self,nom):
        self.__nom = nom
    def get_nom(self):
        return self.__nom

class Adherent(Personne):
    def __init__(self,nom,numero):
        Personne.__init__(self,nom)
        self.__numero = numero
        
    def get_numero(self):
        return self.__numero

class Activite:
    def __init__(self,nom):
        self.__nom = nom
        self.__adherents = []
    def get_nom(self):
        return self.__nom
    def ajout_adherent(self,a):
        self.__adherents.append(a)
    def affiche_adherents(self):
        for a in self.__adherents:
            print("Adhérent: {}".format(a.get_nom()))
    def get_adherent(self):
        return self.__adherent