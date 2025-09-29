from datetime import date
class Emprunt():
    def __init__(self,numL,numLi):
        self.__numlecteur = numL
        self.__numlivre = numLi
        self.__date = date.isoformat(date.today())
    def affiche_emprunt(self):
        print ("Lect: {}, Livre: {}".format(self.__numlecteur,self.__numlivre))
    def get_numero_lecteur(self):
        return self.__numlecteur
    def get_numero_livre(self):
        return self.__numlivre
    def get_date(self):
        return self.__date