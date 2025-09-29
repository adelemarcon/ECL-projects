# -*- coding: utf-8 -*-
"""
@author: dellandrea
"""

from bibliotheque import *

# Creation d'une bibliotheque et de son conservateur
b = Bibliotheque('Bibliotheque ECL')
b.set_conservateur('Vivier','Merlin','rue des Papillons')

# Ajout de lecteurs
b.ajout_lecteur('Duval','Pierre','rue de la Paix',1)
b.ajout_lecteur('Dupond','Laurent','rue de la Gare',2)
b.ajout_lecteur('Martin','Marie','rue La Fayette',3)
b.ajout_lecteur('Dubois','Sophie','rue du Stade',4)

# Ajout de livres
b.ajout_livre('Le Pere Goriot','Honore de Balzac',101,2)
b.ajout_livre('Les Hauts de Hurlevent','Emilie Bronte',102,2)
b.ajout_livre('Le Petit Prince','Antoine de Saint Exupery',103,2)
b.ajout_livre('L\'Etranger','Albert Camus',104,2)

# Ajout de ibliothécaires

b.ajout_bibliothecaire('Duval','Marion','rue des Hirondelles',1)
b.ajout_bibliothecaire('Desjardins','Anne','rue Sainte-Adèle',2)

# Affichage des lecteurs et des livres
print('\n--- Liste des lecteurs :')
print('-------------------------------')
b.affiche_lecteurs()
print('\n--- Liste des livres :')
print('-------------------------------')
b.affiche_livres()

# Recherches de lecteurs par numero
print('\n--- Recherche de lecteurs :')
print('-------------------------------')
lect = b.chercher_lecteur_numero(1)
if lect != None:
    print(lect)
else:
    print('Lecteur non trouve')

lect = b.chercher_lecteur_numero(6)
if lect != None:
    print(lect)
else:
    print('Lecteur non trouve')

# Recherches de lecteurs par nom
lect = b.chercher_lecteur_nom('Martin','Marie')
if lect != None:
    print(lect)
else:
    print('Lecteur non trouve')
    
lect = b.chercher_lecteur_nom('Le Grand','Paul')
if lect != None:
    print(lect)
else:
    print('Lecteur non trouve')

# Recherches de livres par numero
print('\n--- Recherche de livres :')
print('-------------------------------')
livre = b.chercher_livre_numero(101)
if livre != None:
    print('Livre trouve :',livre)
else:
    print('Livre non trouve')

livre = b.chercher_livre_numero(106)
if livre != None:
    print('Livre trouve :',livre)
else:
    print('Livre non trouve')

# Recherches de livres par titre
livre = b.chercher_livre_titre('Les Hauts de Hurlevent')
if livre != None:
    print('Livre trouve :',livre)
else:
    print('Livre non trouve')

livre = b.chercher_livre_titre('Madame Bovarie')
if livre != None:
    print('Livre trouve :',livre)
else:
    print('Livre non trouve')
    
# Recherches de bibliothécaires par numero

print('\n--- Recherche de bibliothécaires :')
print('-------------------------------')
biblio = b.chercher_bibliothecaire_numero(1)
if biblio != None:
    print(biblio)
else:
    print('Bibliothécaire non trouve')

biblio = b.chercher_lecteur_numero(96)
if biblio != None:
    print(biblio)
else:
    print('Bibliothécaire non trouve')

# Recherche de Bibliothécaires par nom
biblio = b.chercher_bibliothecaire_nom('Desjardins','Anne')
if biblio != None:
    print(biblio)
else:
    print('Bibliothécaire non trouve')

biblio = b.chercher_lecteur_nom('Pierre','Caillou')
if biblio != None:
    print(biblio)
else:
    print('Bibliothécaire non trouve')

# Quelques emprunts
print('\n--- Quelques emprunts :')
print('-------------------------------')
b.emprunt_livre(1,101)
b.emprunt_livre(1,104)
b.emprunt_livre(2,101)
b.emprunt_livre(2,105)
b.emprunt_livre(3,101)
b.emprunt_livre(3,104)
b.emprunt_livre(4,102)
b.emprunt_livre(4,103)

# Affichage des emprunts, des lecteurs et des livres
print('\n--- Liste des emprunts :')
print('-------------------------------')
b.affiche_emprunts()
print('\n--- Liste des lecteurs :')
print('-------------------------------')
b.affiche_lecteurs()
print('\n--- Liste des livres :')
print('-------------------------------')
b.affiche_livres()

# Quelques retours de livres
print('\n--- Quelques retours de livres :')
print('-------------------------------')
b.retour_livre(1,101)
b.retour_livre(1,102)
b.retour_livre(3,104)
b.retour_livre(10,108)

# Affichage des emprunts, des lecteurs et des livres
print('\n--- Liste des emprunts :')
print('-------------------------------')
b.affiche_emprunts()
print('\n--- Liste des lecteurs :')
print('-------------------------------')
b.affiche_lecteurs()
print('\n--- Liste des livres :')
print('-------------------------------')
b.affiche_livres()

# Suppression de quelques livres
rep = b.retrait_livre(101)
if not rep:
    print('Retrait du livre impossible')
else:
    print('Retrait du livre effectue')

b.retour_livre(2,101)

rep = b.retrait_livre(101)
if not rep:
    print('Retrait du livre impossible')
else:
    print('Retrait du livre effectue')

# Suppression de quelques lecteurs
rep = b.retrait_lecteur(1)
if not rep:
    print('Retrait du lecteur impossible')
else:
    print('Retrait du lecteur effectue')

b.retour_livre(1,104)

rep = b.retrait_lecteur(1)
if not rep:
    print('Retrait du lecteur impossible')
else:
    print('Retrait du lecteur effectue')

# Affichage des emprunts, des lecteurs et des livres
print('\n--- Liste des emprunts :')
print('-------------------------------')
b.affiche_emprunts()
print('\n--- Liste des lecteurs :')
print('-------------------------------')
b.affiche_lecteurs()
print('\n--- Liste des livres :')
print('-------------------------------')
b.affiche_livres()


