class Lecteur():
    def __init__(self,n,p,a,nb):
        self.__n = n
        self.__p = p
        self.__a = a
        self.__nb = nb
        self.__Biblio = []
    def get_n(self):
        return self.__n
    def get_num(self):
        return self.__nb
    def set_numero(self,nb):
        self.__nb = nb
    def add_bibliotheque(self,B):
        self.__Biblio.append(B)