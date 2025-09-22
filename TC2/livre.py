class Livre():
    def __init__(self,a,t,num,nb):
        self.__a = a
        self.__t = t
        self.__num = num
        self.__nb = nb
        self.__nbdispo = nb
    def __str__(self):
        return "Auteur: {}, Titre: {}, Numéro: {}, Nombre acheté: {}, Nombre dispo: {}".f(self.__a,self.__t,self.__num, self.__nb,self.__nbdispo)
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