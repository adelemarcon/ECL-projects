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
    