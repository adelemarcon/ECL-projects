from tkinter import *
from random import randint
from tkinter import colorchooser
from formes import *

class MonBoutonLettre(Button):
    def __init__(self, parent, lettre, callback):
        Button.__init__(self, parent, text=lettre, width=3)
        self.__lettre = lettre
        self.config(command=self.cliquer)
        self.__callback = callback
    
    def cliquer(self):
        self.__callback(self.__lettre)
    
    def get_lettre(self):
        return self.__lettre


class ZoneAffichage(Canvas):
    def __init__(self, parent, largeur, hauteur):
        Canvas.__init__(self, parent, width=largeur, height=hauteur, bg="white")
        self.__mot = None
        self.__boutons = []
        self.__lettres_trouvees = []
        self.__erreurs = 0
        self.__max_erreurs = 10
        self.__texte_mot = None
        self.__couleur_base = "#452821"
        self.__couleur_perso = "black"
        
    def set_boutons(self, B):
        self.__boutons = B

    def chargeMots(self):
        f = open('mots.txt', 'r')
        s = f.read()
        self.__mots = s.split('\n')
        f.close()

    def nouveau_mot(self):
        k = randint(0, len(self.__mots) - 1)
        self.__mot = self.__mots[k].upper()
        print(f"Mot choisi: {self.__mot}")

    def afficher_mot(self):
        mot_affiche = ""
        for lettre in self.__mot:
            if lettre in self.__lettres_trouvees:
                mot_affiche += lettre + " "
            else:
                mot_affiche += "_ "
        
        if self.__texte_mot:
            self.delete(self.__texte_mot)
        self.__texte_mot = self.create_text(300, 350, text=mot_affiche, font=("Arial", 24, "bold"), fill="black")

    def dessiner_pendu(self):
        if self.__erreurs == 1:
            # Base
            Rectangle(self, 50,  270, 150,  26, self.__couleur_base)
        elif self.__erreurs == 2:
            # Poteau
            Rectangle(self, 87,   83,  26, 200, self.__couleur_base)
        elif self.__erreurs == 3:
            # Traverse
            Rectangle(self, 87,   70, 150,  26, self.__couleur_base)
        elif self.__erreurs == 4:
            # Corde
            Rectangle(self, 183,  70,  10,  40, self.__couleur_base)
        elif self.__erreurs == 5:
            # Tête
            Ellipse(self,188,128,15,15,self.__couleur_perso)
        elif self.__erreurs == 6:
            # Tronc
            Rectangle(self, 175, 146,  26,  60, self.__couleur_perso)
        elif self.__erreurs == 7:
            # Bras gauche
            Rectangle(self, 133, 153,  40,  10, self.__couleur_perso)
        elif self.__erreurs == 8:
            # Bras droit
            Rectangle(self, 203, 153,  40,  10, self.__couleur_perso)
        elif self.__erreurs == 9:
            # Jambe gauche
            Rectangle(self, 175, 208,  10,  40, self.__couleur_perso)
        elif self.__erreurs == 10:
            # Jambe droite
            Rectangle(self, 191, 208,  10,  40, self.__couleur_perso)
    
    def verifier_victoire(self):
        for lettre in self.__mot:
            if lettre not in self.__lettres_trouvees:
                return False
        return True

    def verifier_defaite(self):
        return self.__erreurs >= self.__max_erreurs

    def bloquer_clavier(self):
        for bouton in self.__boutons:
            bouton.config(state=DISABLED)

    def fin_partie(self, victoire):
        if victoire:
            message = "BRAVO ! Vous avez gagné !"
            couleur = "#3d7247"
        else:
            message = f"PERDU ! Le mot était : {self.__mot}"
            couleur = "#723d3d"
        
        self.create_text(300, 50, text=message, 
                        font=("Arial", 20, "bold"), 
                        fill=couleur, 
                        tags="message_fin")

    def get_mot(self):
        return self.__mot

    def get_lettres_trouvees(self):
        return self.__lettres_trouvees

    def ajouter_lettre_trouvee(self, lettre):
        self.__lettres_trouvees.append(lettre)

    def incr_erreurs(self):
        self.__erreurs += 1

    def get_erreurs(self):
        return self.__erreurs

    def nouvelle_partie(self):
        # Réactiver tous les boutons
        for bouton in self.__boutons:
            bouton.config(state=NORMAL)
        
        # Réinitialiser les variables
        self.__lettres_trouvees = []
        self.__erreurs = 0
        
        # Effacer le canvas
        self.delete("all")
        
        # Charger un nouveau mot
        self.chargeMots()
        self.nouveau_mot()
        
        # Afficher le mot caché
        self.afficher_mot()
    
    def set_couleur_base(self,couleur):
        self.__couleur_base = couleur
    
    def set_couleur_perso(self,couleur):
        self.__couleur_perso = couleur

class FenPrincipale(Tk):
    def __init__(self):
        Tk.__init__(self)
        
        # Disposition des composants de l'interface
        self.configure(bg="grey")
        self.title("Jeu du Pendu")
        barreOutils = Frame(self)
        barreOutils.pack(side=TOP)
        boutonQuitter = Button(barreOutils, text="Quitter")
        boutonQuitter.pack(side=LEFT, padx=5, pady=5)
        boutonCouleur = Button(barreOutils, text="Couleur fond")
        boutonCouleur.pack(side=LEFT, padx=5, pady=5)
        boutonCouleurbase = Button(barreOutils, text="Couleur base")
        boutonCouleurpendu = Button(barreOutils, text="Couleur pendu")
        boutonCouleurbase.pack(side=LEFT, padx=5, pady=5)
        boutonCouleurpendu.pack(side=LEFT, padx=5, pady=5)

        self.__canevas = ZoneAffichage(self, 600, 400)
        self.__canevas.pack(side=TOP, padx=10, pady=10)
        
        clavier = Frame(self)
        clavier.pack(side=BOTTOM)
        
        # Créer 26 instances de MonBoutonLettre
        self.__B = []        
        for l in range(26):
            t = chr(ord('A') + l)
            b = MonBoutonLettre(clavier, t, self.traitement)
            self.__B.append(b)

        # Création du clavier (pas la méthode la plus effficace)
        for k in range(26):
            if k < 7:
                j = k + 1
                i = 1
                self.__B[k].grid(row=i, column=j, padx=2, pady=2)
            elif 7 <= k < 14:
                i = 2
                j = k - 6
                self.__B[k].grid(row=i, column=j, padx=2, pady=2)
            elif 14 <= k < 21:
                i = 3
                j = k - 13
                self.__B[k].grid(row=i, column=j, padx=2, pady=2)
            else:
                i = 4
                j = k - 19
                self.__B[k].grid(row=i, column=j, padx=2, pady=2)
        
        boutonNew = Button(barreOutils, text="Nouvelle Partie")
        boutonNew.pack(side=LEFT, padx=5, pady=5)
        
        # Commandes
        boutonQuitter.config(command=self.destroy)
        boutonCouleur.config(command=self.selection_couleur)
        boutonCouleurbase.config(command=self.selection_couleur_base)
        boutonCouleurpendu.config(command=self.selection_couleur_perso)

        boutonNew.config(command=self.__canevas.nouvelle_partie)
    
        # Passer la liste des boutons au canevas
        self.__canevas.set_boutons(self.__B)
        
        # Lancer une première partie
        self.__canevas.nouvelle_partie()
        
    def selection_couleur(self):
        self.__couleur_fond = colorchooser.askcolor()[1]
        self.configure(bg=self.__couleur_fond)
        
    def selection_couleur_base(self):
        self.__couleur_base = colorchooser.askcolor()[1]
        self.__canevas.set_couleur_base(self.__couleur_base)
        
    def selection_couleur_perso(self):
        self.__couleur_perso = colorchooser.askcolor()[1]
        self.__canevas.set_couleur_perso(self.__couleur_perso)
        
    def traitement(self, lettre):
        # Griser le bouton qui vient d'être cliqué
        index = ord(lettre) - ord('A')
        self.__B[index].config(state=DISABLED)
        
        # Vérifier si la lettre est dans le mot
        mot = self.__canevas.get_mot()
        if lettre in mot:
            # La lettre est présente dans le mot
            self.__canevas.ajouter_lettre_trouvee(lettre)
            self.__canevas.afficher_mot()
            
            # Vérifier si la partie est gagnée
            if self.__canevas.verifier_victoire():
                self.__canevas.bloquer_clavier()
                self.__canevas.fin_partie(victoire=True)
        else:
            # La lettre n'est pas dans le mot : erreur
            self.__canevas.incr_erreurs()
            self.__canevas.dessiner_pendu()
            
            # Vérifier si la partie est perdue
            if self.__canevas.verifier_defaite():
                # Révéler le mot complet
                for l in mot:
                    if l not in self.__canevas.get_lettres_trouvees():
                        self.__canevas.ajouter_lettre_trouvee(l)
                self.__canevas.afficher_mot()
                self.__canevas.bloquer_clavier()
                self.__canevas.fin_partie(victoire=False)

if __name__ == '__main__':
    fen = FenPrincipale()
    fen.mainloop()