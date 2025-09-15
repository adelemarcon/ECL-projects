class Forme:
    def __init__(self,x,y):
        self.__x = x
        self.__y = y
    def get_pos(self):
        return (self.__x,self.__y)
    def set_pos(self,x,y):
        self.__x = x
        self.__y = y
    def translation(self,dx,dy):
        self.__x += dx
        self.__y += dy

class Rectangle:
    def __init__(self,l,h):
        self.__l = l
        self.__h = h
    def get_dim(self):
        return (self.__l, self.__h)

class Ellipse:
    def __init__(self,rx,ry):
        self.__rx = rx
        self.__ry = ry
    def get_dim(self):
        return (self.__rx, self.__ry)
    def set_dim(self,rx,ry):
        self.__rx = rx
        self.__ry = ry

class Cercle:
    def __init__(self,r):
        self.__r = r
    def get_dim(self):
        return self.__r