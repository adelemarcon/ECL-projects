class Forme:
    def __init__(self, canevas, x, y):
        self.__canevas = canevas
        self.__item = None
        self.__x = x
        self.__y = y
    
    def get_pos(self):
        return self.__x, self.__y
    
    def set_pos(self, x, y):
        self.__x = x
        self.__y = y

    def effacer(self):
        self.__canevas.delete(self.__item)
    
    def deplacement(self, dx, dy):
        self.__canevas.move(self.__item, dx, dy)
        self.__x += dx
        self.__y += dy
        
    def get_cavenas(self):
        return self.__canevas
    
    def set_item(self,item):
        self.__item = item
    
    def get_item(self):
        return self.__item

class Rectangle(Forme):
    def __init__(self, canevas, x, y, l, h, couleur):
        Forme.__init__(self, canevas, x, y)
        item = canevas.create_rectangle(x, y, x+l, y+h, fill=couleur)
        self.set_item(item)
        self.__l = l
        self.__h = h
    
    def __str__(self):
        x, y = self.get_pos()
        return f"Rectangle d'origine {x},{y} et de dimensions {self.__l}x{self.__h}"

    def get_dim(self):
        return self.__l, self.__h

    def set_dim(self, l, h):
        self.__l = l
        self.__h = h

    def contient_point(self, x, y):
        x0, y0 = self.get_pos()
        return x0 <= x <= x0 + self.__l and \
               y0 <= y <= y0 + self.__h

    def redimension_par_points(self, x0, y0, x1, y1):
        self.set_pos( min(x0, x1) , min(y0, y1) )
        self.__l = abs(x0 - x1)
        self.__h = abs(y0 - y1)

class Ellipse(Forme):
    def __init__(self, canevas, x, y, rx, ry, couleur):
        Forme.__init__(self, canevas, x, y)
        item = canevas.create_oval(x-rx, y-ry, x+rx, y+ry, fill=couleur)
        self.set_item(item)
        self.__rx = rx
        self.__ry = ry

    def __str__(self):
        x, y = self.get_pos()
        return f"Ellipse de centre {x},{y} et de rayons {self.__rx}x{self.__ry}"

    def get_dim(self):
        return self.__rx, self.__ry

    def set_dim(self, rx, ry):
        self.__rx = rx
        self.__ry = ry

    def contient_point(self, x, y):
        x0, y0 = self.get_pos()
        return ((x - x0) / self.__rx) ** 2 + ((y - y0) / self.__ry) ** 2 <= 1

    def redimension_par_points(self, x0, y0, x1, y1):
        self.set_pos( (x0 + x1) // 2 , (y0 + y1) // 2 )
        self.__rx = abs(x0 - x1) / 2
        self.__ry = abs(y0 - y1) / 2


