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

class Rectangle(Forme):
    def __init__(self,l,h):
        Forme.__init__(self)
        self.__l = l
        self.__h = h
    def get_dim(self):
        return (self.__l, self.__h)
    def set_dim(self,l,h):
        self.__l = l
        self.__h = h
    def contient_point(self,x,y):
        if self.__x <= x <= (self.__x + self.__l) and (self.y - self.__h <= y <= self.y):
            return True
        else:
            return False
    def redimension_par_points(self,x0,y0,x1,y1):
        self.__x = x0
        self.__y = y0
        self.__l = abs(x1 - x0)
        self.__h = abs(y0 - y1)

class Ellipse(Forme):
    def __init__(self,rx,ry):
        Forme.__init__(self)
        self.__rx = rx
        self.__ry = ry
    def get_dim(self):
        return (self.__rx, self.__ry)
    def set_dim(self,rx,ry):
        self.__rx = rx
        self.__ry = ry
    def contient_point(self,x,y):
        if (x-self.__x)**2 + (y-self.__y)**2 <= self.__rx**2 + self.__ry**2:
            return True
        else:
            return False
    def redimension_par_points(self,x0,y0,x1,y1):
        self.__x = ((x1 - x0) / 2) + x0
        self.__y = ((y1 - y0) / 2) + y0
        self.__rx = (abs(x1-x0))/2
        self.__ry = (abs(y1-y0))/2

class Cercle(Ellipse):
    def __init__(self,r):
        Ellipse.__init__(self)
        self.__r = r
    def get_dim(self):
        return self.__r
    def contient_point(self,x,y):
        if ((x-self.__x)**2 + (y-self.__y)**2 ) <= (self.__r)**2:
            return True
        else:
            return False
    def redimension_par_points(self,x0,y0,x1,y1):
        m = min(abs(x1-x0),abs(y1-y0))
        self.__r = m/2
        self.__x = x0 + m/2
        self.__y = y0 + m/2
        
        
        