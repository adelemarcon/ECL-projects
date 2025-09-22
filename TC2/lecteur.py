class Lecteur(Personne):
    def __init__(self,n,p,a,nb):
        Personne.__init__(self,n,p,a)
        self.__nb = nb
        self.__nbemprunts = []
    def get_num(self):
        return self.__nb
    def set_numero(self,nb):
        self.__nb = nb
    def get_nbemprunts(self):
        return self.__nbemprunts
    def set_nbemprunts(self,nb):
        self.__nbemprunts = nb