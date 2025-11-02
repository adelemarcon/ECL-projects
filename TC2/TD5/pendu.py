from tkinter import *
from random import randint
from tkinter import colorchooser
from formes import *
import copy

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
        self.__mots = []  # Liste privée pour stocker les mots
        self.__historique = []
        self.__compteur_triche = 0
                
        # Charger les mots une seule fois au lancement
        self.chargeMots()
        
    def set_boutons(self, B):
        self.__boutons = B

    def chargeMots(self):
        """Charge les mots depuis le fichier mots.txt une fois pour toute"""
        f = open('mots.txt', 'r')
        s = f.read()
        self.__mots = s.split('\n')
        f.close()

    def nouveau_mot(self):
        """Tire un nouveau mot au hasard dans la liste"""
        k = randint(0, len(self.__mots) - 1)
        self.__mot = self.__mots[k].upper()
        print(f"Mot choisi: {self.__mot}")

    def afficher_mot(self):
        """Affiche le mot avec les lettres trouvées et les underscores"""
        mot_affiche = ""
        for lettre in self.__mot:
            if lettre in self.__lettres_trouvees:
                mot_affiche += lettre + " "
            else:
                mot_affiche += "_ "
        
        if self.__texte_mot:
            self.delete(self.__texte_mot)
        self.__texte_mot = self.create_text(500, 650, text=mot_affiche, font=("Arial", 24, "bold"), fill="black")
    
    def afficher_compteur_triche(self):
        compteur = f"Alors comme ça vous trichez ? Je compte: {self.__compteur_triche}"
        
        self.__compteur = self.create_text(600,800, text = compteur, font=("Arial", 18, "bold"), fill="black")

    def dessiner_pendu(self):
        if self.__erreurs == 1:
            Rectangle(self, 350, 470, 150, 26, self.__couleur_base)
        elif self.__erreurs == 2:
            Rectangle(self, 387, 283, 26, 200, self.__couleur_base)
        elif self.__erreurs == 3:
            Rectangle(self, 387, 270, 150, 26, self.__couleur_base)
        elif self.__erreurs == 4:
            Rectangle(self, 483, 270, 10, 40, self.__couleur_base)
        elif self.__erreurs == 5:
            Ellipse(self, 488, 328, 15, 15, self.__couleur_perso)
        elif self.__erreurs == 6:
            Rectangle(self, 475, 346, 26, 60, self.__couleur_perso)
        elif self.__erreurs == 7:
            Rectangle(self, 433, 353, 40, 10, self.__couleur_perso)
        elif self.__erreurs == 8:
            Rectangle(self, 503, 353, 40, 10, self.__couleur_perso)
        elif self.__erreurs == 9:
            Rectangle(self, 475, 408, 10, 40, self.__couleur_perso)
        elif self.__erreurs == 10:
            Rectangle(self, 491, 408, 10, 40, self.__couleur_perso)
    
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
        
        self.create_text(600, 50, text=message, font=("Arial", 20, "bold"), fill=couleur)

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

    def sauvegarder_etat(self, lettre_jouee):
        # Sauvegarde l'état actuel du jeu dans l'historique
        etat = {
            'lettres_trouvees': copy.deepcopy(self.__lettres_trouvees),
            'erreurs': self.__erreurs,
            'lettre_jouee': lettre_jouee
        }
        self.__historique.append(etat)
    
    def undo(self):
        # Augmenter le compteur de triche
        self.__compteur_triche += 1
        
        # Retirer le dernier état
        dernier_etat = self.__historique.pop()
        
        # Restaurer l'état précédent
        self.__lettres_trouvees = dernier_etat['lettres_trouvees']
        self.__erreurs = dernier_etat['erreurs']
        
        # Redessiner l'interface
        self.delete("all")
        self.afficher_mot()
        
        self.afficher_compteur_triche()

        # Redessiner le pendu
        for i in range(1, self.__erreurs + 1):
            temp_erreurs = self.__erreurs
            self.__erreurs = i
            self.dessiner_pendu()
            self.__erreurs = temp_erreurs
        
        # Retourner la lettre qui a été annulée pour réactiver le bouton lorsqu'on appelle undo
        return dernier_etat['lettre_jouee']
    
    def undo_possible(self):
        return len(self.__historique)

    def nouvelle_partie(self):
        """Réinitialise complètement l'interface pour une nouvelle partie"""
        # Tirer un nouveau mot au hasard et réinitialiser le mot à découvrir
        self.nouveau_mot()
        self.__lettres_trouvees = []
        self.__erreurs = 0
        self.__historique = []
        
        # Dégriser les boutons-lettres
        for bouton in self.__boutons:
            bouton.config(state=NORMAL)
        
        # Effacer le dessin du pendu (effacer tout le canvas)
        self.delete("all")
        
        # Afficher le nouveau mot caché
        self.afficher_mot()
    
    def set_couleur_base(self, couleur):
        self.__couleur_base = couleur
    
    def set_couleur_perso(self, couleur):
        self.__couleur_perso = couleur


class FenPrincipale(Tk):
    def __init__(self):
        Tk.__init__(self)
        
        # Configuration de la fenêtre
        self.configure(bg="grey")
        self.title("Jeu du Pendu")

        barreOutils = Frame(self)
        barreOutils.pack(side=TOP)
        
        boutonNew = Button(barreOutils, text="Nouvelle Partie")
        boutonNew.pack(side=LEFT, padx=5, pady=5)
        
        boutonUndo = Button(barreOutils, text="Undo (Triche!)")
        boutonUndo.pack(side=LEFT, padx=5, pady=5)
        
        boutonQuitter = Button(barreOutils, text="Quitter")
        boutonQuitter.pack(side=LEFT, padx=5, pady=5)
        
        boutonCouleur = Button(barreOutils, text="Couleur fond")
        boutonCouleur.pack(side=LEFT, padx=5, pady=5)
        
        boutonCouleurbase = Button(barreOutils, text="Couleur base")
        boutonCouleurbase.pack(side=LEFT, padx=5, pady=5)
        
        boutonCouleurpendu = Button(barreOutils, text="Couleur pendu")
        boutonCouleurpendu.pack(side=LEFT, padx=5, pady=5)

        # Zone d'affichage (canvas)
        self.__canevas = ZoneAffichage(self, 1200, 900)
        self.__canevas.pack(side=TOP, padx=10, pady=10)
        
        # Clavier
        clavier = Frame(self)
        clavier.pack(side=BOTTOM)
        
        # Créer 26 instances de MonBoutonLettre
        self.__B = []        
        for l in range(26):
            t = chr(ord('A') + l)
            b = MonBoutonLettre(clavier, t, self.traitement)
            self.__B.append(b)

        # Disposition du clavier en 4 rangées
        for k in range(26):
            if k < 7:
                i, j = 1, k + 1
            elif 7 <= k < 14:
                i, j = 2, k - 6
            elif 14 <= k < 21:
                i, j = 3, k - 13
            else:
                i, j = 4, k - 19
            self.__B[k].grid(row=i, column=j, padx=2, pady=2)
        
        # Configuration des commandes
        boutonQuitter.config(command=self.destroy)
        boutonCouleur.config(command=self.selection_couleur)
        boutonCouleurbase.config(command=self.selection_couleur_base)
        boutonCouleurpendu.config(command=self.selection_couleur_perso)
        boutonNew.config(command=self.__canevas.nouvelle_partie)
        boutonUndo.config(command=self.undo_action)
    
        # Passer la liste des boutons au canevas
        self.__canevas.set_boutons(self.__B)
        
        # Griser toutes les lettres au démarrage
        # L'utilisateur doit comprendre qu'il doit appuyer sur "Nouvelle Partie"
        for bouton in self.__B:
            bouton.config(state=DISABLED)
        
    def selection_couleur(self):
        couleur = colorchooser.askcolor()[1]
        if couleur:
            self.configure(bg=couleur)
        
    def selection_couleur_base(self):
        couleur = colorchooser.askcolor()[1]
        if couleur:
            self.__canevas.set_couleur_base(couleur)
        
    def selection_couleur_perso(self):
        couleur = colorchooser.askcolor()[1]
        if couleur:
            self.__canevas.set_couleur_perso(couleur)
    
    def undo_action(self):
        if not (self.__canevas.undo_possible() > 0):
            print("Impossible de revenir en arrière : aucun coup joué")
            return
        
        # Effectuer le undo et récupérer la lettre annulée
        lettre_annulee = self.__canevas.undo()
        
        if lettre_annulee:
            # Réactiver le bouton de la lettre annulée
            index = ord(lettre_annulee) - ord('A')
            self.__B[index].config(state=NORMAL)
            print(f"Coup annulé : lettre '{lettre_annulee}' réactivée")
        
    def traitement(self, lettre):
        # Sauvegarder l'état AVANT de jouer
        self.__canevas.sauvegarder_etat(lettre)
        
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