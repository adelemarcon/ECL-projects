class Forme():
    def __init__(self,x,y):
        self.__x = x
        self.__y = y
    def get_x(self):
        return self.__x
    def get_y(self):
        return self.__y
    def set_pos(self,x,y):
        self.__x = x
        self.__y = y
    def translation(self,dx,dy):
        self.__x += dx
        self.__y += dy
    

class Rectangle(Forme):
    def __init__(self,x,y,l,h):
        Forme.__init__(self,x,y)
        self.__l = l
        self.__h = h
    def __str__(self):
        return "Largeur: " + str(self.__l) + " Hauteur: " + str(self.__h)
    def get_dim(self):
        return (self.__l, self.__h)
    def set_dim(self,l,h):
        self.__l = l
        self.__h = h
    def contient_point(self,x,y):
        if self.get_x() <= x <= (self.get_y() + self.__l) and (self.get_y() <= y <= self.get_y() + self.__h):
            print ("Oui! rectangle")
            return True
        else:
            print("Non")
            return False
    def redimension_par_points(self,x0,y0,x1,y1):
        self.set_pos(x0,y0)
        self.__l = abs(x1 - x0)
        self.__h = abs(y0 - y1)

class Ellipse(Forme):
    def __init__(self,x,y,rx,ry):
        Forme.__init__(self,x,y)
        self.__rx = rx
        self.__ry = ry
    def __str__(self):
        return "Rayon x: " + str(self.__rx) + " Rayon y: " + str(self.__ry)
    def get_dim(self):
        return (self.__rx, self.__ry)
    def set_dim(self,rx,ry):
        self.__rx = rx
        self.__ry = ry
    def contient_point(self,x,y):
        a = ((x - self.get_x())/self.__rx)**2
        b = ((y - self.get_y())/self.__ry)**2
        if a+ b <= 1:
            print ("Oui! ellipse")
            return True
        else:
            print("Non")
            return False
    def redimension_par_points(self,x0,y0,x1,y1):
        self.set_pos(((x1 - x0) / 2) + x0,((y1 - y0) / 2) + y0)
        self.__rx = (abs(x1-x0))/2
        self.__ry = (abs(y1-y0))/2

class Cercle(Forme):
    def __init__(self,x,y,r):
        Forme.__init__(self,x,y)
        self.__r = r
    def __str__(self):
        return "Rayon: " + str(self.__r)
    def get_dim(self):
        return self.__r
    def contient_point(self,x,y):
        if ((x-self.get_x())**2 + (y-self.get_y())**2 ) <= (self.__r)**2:
            print ("Oui! cercle")
            return True
        else:
            print( "Non")
            return False
    def redimension_par_points(self,x0,y0,x1,y1):
        m = min(abs(x1-x0),abs(y1-y0))
        self.__r = m/2
        self.set_pos(x0 +m/2, y0 + m/2)
        
if __name__ == '__main__':
    R = Rectangle(2,3,4,5)
    R.contient_point(1,3)
    print(str(R))

class Dessin(Forme):
    def __init__(self,x,y):
        Forme.__init__(self,x,y)