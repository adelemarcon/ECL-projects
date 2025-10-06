from tkinter import *
import tkinter as tk
from formes import *
from tkinter import colorchooser

class ZoneAffichage(Canvas):
    def __init__(self, parent, largeur, hauteur):
        Canvas.__init__(self, parent, width=largeur, height=hauteur)
        self.__formes = []
        self.__type_forme = 'rectangle'
        self.__couleur = 'red'
        self.__forme = None
    def selection_rectangle(self):
        self.__type_forme = 'rectangle'
    def selection_ellipse(self):
        self.__type_forme = 'ellipse'
    def ajout_forme(self,x,y):
        if self.__type_forme == 'rectangle':
            f = Rectangle(self,x,y,10,20,self.__couleur)
        if self.__type_forme == 'ellipse':
            f = Ellipse(self,x,y,5,10, self.__couleur)
        self.__formes.append(f)
    
    def expand_shape(self,startx,starty,x,y):
        if:
            self.__formes[-1].redimension_par_points(startx,starty,x,y)
            self.__formes[-1].update
    
    def suppression_forme(self,x,y)  :
        for k in self.__formes:
            if k.contient_point(x,y):
                self.__formes.remove(k)
                k.effacer()
    def changement_couleur(self,couleur):
        self.__couleur = couleur
        
    def changement_forme(self,x1,y1):
        f = self.__formes[-1]
        if f != None:
            if self.__type_forme == 'rectangle':
                x,y = f.get_pos()
                l,h = f.get_dim()
                f.redimension_par_points(x,y,x1,y1)
                f.set_item (f.get_canevas().create_rectangle(x, y, x+l, y+h, fill=self.__couleur))
            elif self.__type_forme == 'ellipse':
                x,y = f.get_pos()
                rx,ry = f.get_dim()
                f.redimension_par_points(x,y,x1,y1)
                f.set_item (f.get_canevas().create_oval(x-rx, y-ry, x+rx, y+ry, fill=self.__couleur))  
            return True
        return False
                
class FenPrincipale(Tk):
    def __init__(self):
        Tk.__init__(self)
        self.configure(bg="grey")
        self.title('Dessin')
        
        barreOutils = Frame(self)
        barreOutils.pack(side = TOP)
        
        boutonRectangle = Button(barreOutils, text='Rectangle')
        boutonRectangle.pack(side=LEFT, padx=15, pady=15)
        boutonEllipse = Button(barreOutils, text='Ellipse')
        boutonEllipse.pack(side=LEFT, padx=15, pady=15)
        boutonCouleur = Button(barreOutils, text='Couleur')
        boutonCouleur.pack(side=LEFT, padx=15, pady=15)
        boutonQuitter = Button(barreOutils, text='Quitter')
        boutonQuitter.pack(side=LEFT, padx=15, pady=15)
        
        
        self.__canevas = ZoneAffichage(self,600,400)
        self.__canevas.pack(side = TOP,padx = 15, pady = 15)
        
        boutonQuitter.config(command=self.destroy)
        boutonRectangle.config(command = self.__canevas.selection_rectangle)
        boutonEllipse.config(command = self.__canevas.selection_ellipse)
        boutonCouleur.config(command = self.choose_color)
        
        self.__canevas.bind("<ButtonRelease-1>",self.release_canevas)
        self.__canevas.bind("<Control-ButtonRelease-1>", self.suppr_canevas)
        self.__canevas.bind("<Button-1>",self.clic_canevas)
        self.__scale_en_cours = False
        self.__dernier_x = 0
        self.__dernier_y = 0
        self.__canevas.bind("<B1-Motion>",self.drag_canevas)
        
    def release_canevas(self,event):
        if not self.__scale_en_cours:
            self.__canevas.ajout_forme(event.x,event.y) 
        self.__scale_en_cours = False
    
    def suppr_canevas(self,event):
        self.__canevas.suppression_forme(event.x,event.y)
    
    def choose_color(self):
        self.__color_code = colorchooser.askcolor(title = "Choisissez la couleur")
        self.__canevas.changement_couleur(self.__color_code[1])
    
    def clic_canevas(self,event):
        self.__dernier_x = event.x
        self.__dernier_y = event.y
    
    def drag_canevas(self,event):
        self.__canevas.expand_shape(self.__dernier_x, self.__dernier_y,event.x,event.y)
        self.__scale_en_cours = True

if __name__ == "__main__":
    fen = FenPrincipale()
    fen.mainloop()
