class Livre():
    def __init__(self,a,t,num,nb):
        self.__a = a
        self.__t = t
        self.__num = num
        self.__nb = nb
    def get_titre(self):
        return self.__t
    def get_num(self):
        return self.__num
    def get_nb (self):
        return self.__nb
    def set_nb(self,n):
        self.__nb = n
    