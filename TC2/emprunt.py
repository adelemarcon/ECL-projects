class Emprunt():
    def __init__(self,d,numL,numLi):
        self.__d = d
        self.__numlecteur = numL
        self.__numlivre = numLi
    def get_numerolecteur(self):
        return self.__numlecteur
    def get_numerolivre(self):
        return self.__numlivre